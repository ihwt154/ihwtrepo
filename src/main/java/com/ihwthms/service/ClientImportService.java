package com.ihwthms.service;

import com.ihwthms.entity.City;
import com.ihwthms.entity.ClientEntity;
import com.ihwthms.entity.ClientSourceEntity;
import com.ihwthms.entity.ClientTypeEntity;
import com.ihwthms.model.ImportErrorRow;
import com.ihwthms.model.ImportResultDTO;
import com.ihwthms.repository.CityRepository;
import com.ihwthms.repository.ClientRepository;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.*;
import java.util.regex.Pattern;

/**
 * Handles bulk client import from an Excel file.
 *
 * Expected column order (Sheet "Client-Data", row 0 = header, data from row 1):
 *   A=ClientName  B=Mobile  C=Email  D=City  E=Country  F=Source  G=Type
 *
 * Validation Rules:
 *  1. Client Name is mandatory.
 *  2. Both Mobile AND Email are mandatory.
 *  3. Mobile must be exactly 10 numeric digits.
 *  4. Email must follow standard email format.
 *  5. City must exist in the city master table (case-insensitive name match).
 *  6. Country must be a non-empty value (stored as free text — no master table).
 *  7. Source must exist in the active client-source master table.
 *  8. Duplicate: a row is rejected if its Mobile OR Email already exists in DB.
 *
 * Only INSERT is supported; no updates are performed.
 */
@Service
public class ClientImportService {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern MOBILE_PATTERN =
            Pattern.compile("^\\d{10}$");

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private CityRepository cityRepository;

    @Autowired
    private ClientSourceService clientSourceService;

    @Autowired
    private ClientTypeService clientTypeService;

    /**
     * Processes the uploaded Excel file and returns an {@link ImportResultDTO}.
     *
     * @param file        the uploaded .xlsx / .xls file
     * @param createdById the ID of the user performing the import
     * @return full import result with summary and error list
     */
    public ImportResultDTO processImport(MultipartFile file, Long createdById) throws Exception {
        ImportResultDTO result = new ImportResultDTO();

        // ── Build lookup maps once (case-insensitive name → entity) ───────────
        Map<String, City>   cityMap   = buildCityMap();
        Map<String, String> sourceMap = buildSourceMap();
        Map<String, String> typeMap   = buildTypeMap();

        int success = 0;
        int failed  = 0;

        try (InputStream is = file.getInputStream();
             Workbook workbook = WorkbookFactory.create(is)) {

            // Accept "Client-Data" sheet (user template) or first sheet
            Sheet sheet = workbook.getSheet("Client-Data");
            if (sheet == null) sheet = workbook.getSheetAt(0);

            int lastRow = sheet.getLastRowNum();

            for (int i = 1; i <= lastRow; i++) { // row 0 = header, skip it
                Row row = sheet.getRow(i);
                if (row == null) continue;

                int displayRow = i + 1; // 1-based display (row 1 = header, row 2 = first data)

                // ── Read cells ───────────────────────────────────────────────
                String clientName = cellStr(row, 0);
                String mobile     = cellStr(row, 1);
                String email      = cellStr(row, 2);
                String cityName   = cellStr(row, 3);
                String country    = cellStr(row, 4);
                String sourceName = cellStr(row, 5);
                String typeName   = cellStr(row, 6);

                // Skip entirely blank rows silently
                if (clientName.isEmpty() && mobile.isEmpty() && email.isEmpty()) continue;

                // ── 1. Mandatory: Client Name ────────────────────────────────
                if (clientName.isEmpty()) {
                    result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                            "Client Name is required"));
                    failed++;
                    continue;
                }

                // ── 2. Mandatory: Mobile ─────────────────────────────────────
                if (mobile.isEmpty()) {
                    result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                            "Mobile is required"));
                    failed++;
                    continue;
                }

                // ── 3. Mandatory: Email ──────────────────────────────────────
                if (email.isEmpty()) {
                    result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                            "Email is required"));
                    failed++;
                    continue;
                }

                // ── 4. Mobile format: exactly 10 digits ──────────────────────
                if (!MOBILE_PATTERN.matcher(mobile).matches()) {
                    result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                            "Mobile must be exactly 10 numeric digits (no spaces or dashes)"));
                    failed++;
                    continue;
                }

                // ── 5. Email format ──────────────────────────────────────────
                if (!EMAIL_PATTERN.matcher(email).matches()) {
                    result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                            "Invalid Email format (expected: user@domain.com)"));
                    failed++;
                    continue;
                }

                // ── 6. City: must exist in master table ──────────────────────
                City resolvedCity = null;
                if (!cityName.isEmpty()) {
                    resolvedCity = cityMap.get(cityName.toLowerCase().trim());
                    if (resolvedCity == null) {
                        result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                                "City '" + cityName + "' not found in master table"));
                        failed++;
                        continue;
                    }
                }

                // ── 7. Source: must exist in master table (if provided) ───────
                String resolvedSource = null;
                if (!sourceName.isEmpty()) {
                    resolvedSource = sourceMap.get(sourceName.toLowerCase().trim());
                    if (resolvedSource == null) {
                        result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                                "Source '" + sourceName + "' not found in master table"));
                        failed++;
                        continue;
                    }
                }

                // ── 8. Type: must exist in master table (if provided) ─────────
                String resolvedType = null;
                if (!typeName.isEmpty()) {
                    resolvedType = typeMap.get(typeName.toLowerCase().trim());
                    if (resolvedType == null) {
                        result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                                "Type '" + typeName + "' not found in master table"));
                        failed++;
                        continue;
                    }
                }

                // ── 9. Duplicate: Mobile already exists ───────────────────────
                if (clientRepository.existsByMobile(mobile)) {
                    result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                            "Duplicate: Mobile " + mobile + " already exists"));
                    failed++;
                    continue;
                }

                // ── 10. Duplicate: Email already exists ───────────────────────
                if (clientRepository.existsByEmailId(email)) {
                    result.addError(new ImportErrorRow(displayRow, clientName, mobile, email,
                            "Duplicate: Email " + email + " already exists"));
                    failed++;
                    continue;
                }

                // ── Build and save entity ─────────────────────────────────────
                ClientEntity entity = new ClientEntity();
                entity.setClientName(clientName);
                entity.setMobile(mobile);
                entity.setEmailId(email);
                entity.setCity(resolvedCity);
                entity.setCountry(country.isEmpty() ? null : country);
                entity.setClientSource(resolvedSource);
                entity.setClientType(resolvedType);
                entity.setClientStatus("Active");
                entity.setActive(true);
                entity.setCreatedBy(createdById);
                entity.setUpdatedBy(createdById);
                entity.setCreatedAt(LocalDateTime.now());
                entity.setUpdatedAt(LocalDateTime.now());
                entity.setClientCode(generateNextClientCode());

                clientRepository.save(entity);
                success++;
            }
        }

        result.setTotalProcessed(success + failed);
        result.setSuccessCount(success);
        result.setFailedCount(failed);
        return result;
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private String cellStr(Row row, int col) {
        Cell cell = row.getCell(col, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING:  return cell.getStringCellValue().trim();
            case NUMERIC: return String.valueOf((long) cell.getNumericCellValue());
            case BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                try { return cell.getStringCellValue().trim(); }
                catch (Exception e) { return String.valueOf((long) cell.getNumericCellValue()); }
            default: return "";
        }
    }

    /** Builds a lowercase-name → City map from all cities in DB. */
    private Map<String, City> buildCityMap() {
        Map<String, City> map = new HashMap<>();
        for (City c : cityRepository.findAll()) {
            if (c.getName() != null) {
                map.put(c.getName().toLowerCase().trim(), c);
            }
        }
        return map;
    }

    /** Builds a lowercase-name → canonical-name map for active sources. */
    private Map<String, String> buildSourceMap() {
        Map<String, String> map = new HashMap<>();
        for (ClientSourceEntity s : clientSourceService.findAllActive()) {
            if (s.getSourceName() != null) {
                map.put(s.getSourceName().toLowerCase().trim(), s.getSourceName());
            }
        }
        return map;
    }

    /** Builds a lowercase-name → canonical-name map for active types. */
    private Map<String, String> buildTypeMap() {
        Map<String, String> map = new HashMap<>();
        for (ClientTypeEntity t : clientTypeService.findAllActive()) {
            if (t.getTypeName() != null) {
                map.put(t.getTypeName().toLowerCase().trim(), t.getTypeName());
            }
        }
        return map;
    }

    /**
     * Generates the next sequential Client Code in format CLI-XXXXX.
     */
    public synchronized String generateNextClientCode() {
        String maxCode = clientRepository.findMaxClientCode();
        int next = 10001;
        if (maxCode != null && maxCode.startsWith("CLI-")) {
            try {
                next = Integer.parseInt(maxCode.substring(4)) + 1;
            } catch (NumberFormatException ignored) {}
        }
        return String.format("CLI-%05d", next);
    }
}
