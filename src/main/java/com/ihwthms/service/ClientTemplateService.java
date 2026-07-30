package com.ihwthms.service;

import com.ihwthms.entity.City;
import com.ihwthms.entity.ClientSourceEntity;
import com.ihwthms.entity.ClientTypeEntity;
import com.ihwthms.model.ImportErrorRow;
import com.ihwthms.repository.CityRepository;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Generates the Excel import template (with reference sheet) and PDF quick-reference guide.
 * Also generates downloadable error-report files (Excel & PDF) after an import run.
 */
@Service
public class ClientTemplateService {

    // Template column indices (0-based) matching the user's actual template
    private static final int COL_CITY   = 3; // Column D
    private static final int COL_SOURCE = 5; // Column F
    private static final int COL_TYPE   = 6; // Column G

    // Path to the user's master template file
    private static final String TEMPLATE_PATH =
        "d:/temp/ihwtrepo/src/main/webapp/resources/templates/Client_Import_Template.xlsx";

    @Autowired
    private CityRepository cityRepository;

    @Autowired
    private ClientSourceService clientSourceService;

    @Autowired
    private ClientTypeService clientTypeService;

    // ── Excel Template ────────────────────────────────────────────────────────

    /**
     * Serves the user's actual Client_Import_Template.xlsx with the "Values"
     * sheet regenerated from live DB data and Excel dropdown validations applied
     * to the City, Source and Type columns.
     */
    public void writeExcelTemplate(HttpServletResponse response) throws IOException {
        response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition",
                "attachment; filename=Client_Import_Template.xlsx");

        // Load the base template file
        java.io.File templateFile = new java.io.File(TEMPLATE_PATH);
        XSSFWorkbook wb;
        if (templateFile.exists()) {
            try (java.io.InputStream fis = new java.io.FileInputStream(templateFile)) {
                wb = new XSSFWorkbook(fis);
            }
        } else {
            // Fallback: create a minimal workbook
            wb = new XSSFWorkbook();
            XSSFSheet data = wb.createSheet("Client-Data");
            String[] headers = {"Client Name", "Mobile", "Email", "City", "Country", "Source", "Type"};
            Row hdr = data.createRow(0);
            for (int i = 0; i < headers.length; i++) hdr.createCell(i).setCellValue(headers[i]);
        }

        try {
            // ── Fetch live lookup values from DB ─────────────────────────────
            List<City> cities   = cityRepository.findAll();
            List<ClientSourceEntity> sources = clientSourceService.findAllActive();
            List<ClientTypeEntity>   types   = clientTypeService.findAllActive();

            String[] cityNames   = cities.stream().map(City::getName).toArray(String[]::new);
            String[] sourceNames = sources.stream().map(ClientSourceEntity::getSourceName).toArray(String[]::new);
            String[] typeNames   = types.stream().map(ClientTypeEntity::getTypeName).toArray(String[]::new);

            // ── Rebuild the "Values" reference sheet with live data ───────────
            int valIdx = wb.getSheetIndex("Values");
            if (valIdx >= 0) wb.removeSheetAt(valIdx);
            // Also remove old Master Reference sheet if present
            int masterIdx = wb.getSheetIndex("Master Reference");
            if (masterIdx >= 0) wb.removeSheetAt(masterIdx);

            XSSFSheet valSheet = wb.createSheet("Values");
            // Hide the sheet so users don't accidentally edit it
            wb.setSheetHidden(wb.getSheetIndex("Values"), true);

            // Write header row
            Row valHeader = valSheet.createRow(0);
            valHeader.createCell(0).setCellValue("City");
            valHeader.createCell(1).setCellValue("Country");
            valHeader.createCell(2).setCellValue("Source");
            valHeader.createCell(3).setCellValue("Type");

            // Write city values
            for (int i = 0; i < cityNames.length; i++) {
                Row r = valSheet.getRow(i + 1);
                if (r == null) r = valSheet.createRow(i + 1);
                r.createCell(0).setCellValue(cityNames[i]);
            }
            // Write source values
            for (int i = 0; i < sourceNames.length; i++) {
                Row r = valSheet.getRow(i + 1);
                if (r == null) r = valSheet.createRow(i + 1);
                r.createCell(2).setCellValue(sourceNames[i]);
            }
            // Write type values
            for (int i = 0; i < typeNames.length; i++) {
                Row r = valSheet.getRow(i + 1);
                if (r == null) r = valSheet.createRow(i + 1);
                r.createCell(3).setCellValue(typeNames[i]);
            }

            // ── Add Excel Data-Validation dropdowns on the data sheet ─────────
            XSSFSheet dataSheet = wb.getSheet("Client-Data");
            if (dataSheet == null) dataSheet = wb.getSheetAt(0);

            String valSheetName = "Values";
            int maxRow = 1000; // allow dropdowns up to row 1000

            // City dropdown (column D = index 3)
            if (cityNames.length > 0) {
                addDropdownValidation(dataSheet, valSheetName,
                        "$A$2:$A$" + (cityNames.length + 1),
                        COL_CITY, 1, maxRow);
            }
            // Source dropdown (column F = index 5)
            if (sourceNames.length > 0) {
                addDropdownValidation(dataSheet, valSheetName,
                        "$C$2:$C$" + (sourceNames.length + 1),
                        COL_SOURCE, 1, maxRow);
            }
            // Type dropdown (column G = index 6)
            if (typeNames.length > 0) {
                addDropdownValidation(dataSheet, valSheetName,
                        "$D$2:$D$" + (typeNames.length + 1),
                        COL_TYPE, 1, maxRow);
            }

            wb.write(response.getOutputStream());
        } finally {
            wb.close();
        }
    }

    /**
     * Adds a dropdown (list) data-validation to a range of cells in a sheet,
     * pulling allowed values from a named range in another sheet.
     */
    private void addDropdownValidation(XSSFSheet dataSheet, String refSheetName,
                                       String refRange, int col, int firstRow, int lastRow) {
        org.apache.poi.ss.util.CellRangeAddressList addressList =
                new org.apache.poi.ss.util.CellRangeAddressList(firstRow, lastRow, col, col);

        org.apache.poi.xssf.usermodel.XSSFDataValidationHelper dvHelper =
                new org.apache.poi.xssf.usermodel.XSSFDataValidationHelper(dataSheet);

        org.apache.poi.ss.usermodel.DataValidationConstraint constraint =
                dvHelper.createFormulaListConstraint(refSheetName + "!" + refRange);

        org.apache.poi.ss.usermodel.DataValidation validation =
                dvHelper.createValidation(constraint, addressList);
        validation.setSuppressDropDownArrow(true);
        validation.setShowErrorBox(false); // allow typing a name not in list
        dataSheet.addValidationData(validation);
    }

    // ── PDF Quick Reference Guide ─────────────────────────────────────────────

    public void writePdfGuide(HttpServletResponse response) throws IOException, DocumentException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Client_Import_Guide.pdf");

        java.io.File customPdfFile = new java.io.File("d:/temp/ihwtrepo/src/main/webapp/resources/templates/Client_Import_Guide.pdf");
        if (customPdfFile.exists()) {
            try (java.io.InputStream is = new java.io.FileInputStream(customPdfFile)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    response.getOutputStream().write(buffer, 0, bytesRead);
                }
                response.getOutputStream().flush();
                return;
            }
        }

        Document doc = new Document(PageSize.A4, 40, 40, 50, 50);
        PdfWriter.getInstance(doc, response.getOutputStream());
        doc.open();

        // Fonts
        Font titleFont  = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.WHITE);
        Font h2Font     = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 13, new BaseColor(15, 23, 42));
        Font bodyFont   = FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.BLACK);
        Font codeFont   = FontFactory.getFont(FontFactory.COURIER, 9, new BaseColor(30, 64, 175));
        Font noteFont   = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 9, new BaseColor(100, 116, 139));

        // ── Title Banner ──────────────────────────────────────────────────────
        PdfPTable titleTable = new PdfPTable(1);
        titleTable.setWidthPercentage(100);
        PdfPCell titleCell = new PdfPCell(new Phrase("Bulk Client Import – Quick Reference Guide", titleFont));
        titleCell.setBackgroundColor(new BaseColor(15, 23, 42));
        titleCell.setPadding(16);
        titleCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        titleCell.setBorder(Rectangle.NO_BORDER);
        titleTable.addCell(titleCell);
        doc.add(titleTable);
        doc.add(Chunk.NEWLINE);

        // ── Overview ──────────────────────────────────────────────────────────
        doc.add(new Paragraph("Overview", h2Font));
        doc.add(new Paragraph(
            "This guide explains how to use the Excel template to perform a bulk import of client records. " +
            "Download the template, fill in data from Row 3, and upload the file via the 'Bulk Import' button " +
            "on the Client Listing page.", bodyFont));
        doc.add(Chunk.NEWLINE);

        // ── Column Reference Table ────────────────────────────────────────────
        doc.add(new Paragraph("Column Reference", h2Font));
        PdfPTable colTable = new PdfPTable(new float[]{2f, 1.2f, 3.8f});
        colTable.setWidthPercentage(100);
        colTable.setSpacingBefore(6);

        addTableHeader(colTable, "Column", "Mandatory?", "Rules / Notes");

        Object[][] columns = {
            {"Client Name",     "YES", "Non-empty string. Max 200 characters."},
            {"Mobile",          "YES*","Exactly 10 digits, numeric only. (*Mobile OR Email required)"},
            {"Email",           "YES*","Standard email format e.g. user@domain.com. (*Mobile OR Email required)"},
            {"City",            "No",  "Must match a city name in the Master Reference sheet exactly (case-insensitive)."},
            {"Country",         "No",  "Free text. e.g. India, USA."},
            {"Source",          "No",  "Must match a Source name in the Master Reference sheet."},
            {"Type",            "No",  "Must match a Type name in the Master Reference sheet."},
            {"Status",          "No",  "Must be 'Active' or 'Inactive'. Defaults to Active if blank."},
            {"Organization",    "No",  "Organization name (optional)."},
            {"Designation",     "No",  "Contact designation / job title."},
            {"Website",         "No",  "Website URL e.g. https://example.com"},
            {"Address",         "No",  "Full postal address."},
            {"Postal Code",     "No",  "ZIP / Pin code."},
            {"Remarks",         "No",  "Internal notes about this client."},
        };

        Font boldSmall = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, BaseColor.BLACK);
        for (Object[] col : columns) {
            boolean isMandatory = "YES".equals(col[1]) || "YES*".equals(col[1]);
            addTableRow(colTable, (String) col[0], (String) col[1], (String) col[2],
                        isMandatory ? boldSmall : bodyFont);
        }
        doc.add(colTable);
        doc.add(Chunk.NEWLINE);

        // ── Validation Rules ──────────────────────────────────────────────────
        doc.add(new Paragraph("Validation Rules", h2Font));
        String[] rules = {
            "• Client Name must not be empty.",
            "• At least one of Mobile or Email must be provided.",
            "• Mobile must be exactly 10 numeric digits (no spaces, dashes, or country codes).",
            "• Email must follow standard format: user@domain.tld",
            "• Status must be exactly 'Active' or 'Inactive' (case-insensitive).",
            "• City, Source, and Type values must match entries in the Master Reference sheet.",
            "• Records with a Mobile or Email that already exists in the system will be rejected (duplicate).",
            "• Client Code (CLI-XXXXX) is auto-generated — do not include it in the template.",
        };
        for (String rule : rules) {
            Paragraph p = new Paragraph(rule, bodyFont);
            p.setSpacingAfter(3);
            doc.add(p);
        }
        doc.add(Chunk.NEWLINE);

        // ── Process Steps ─────────────────────────────────────────────────────
        doc.add(new Paragraph("Import Process Steps", h2Font));
        String[] steps = {
            "1. Download Template — Click 'Download Excel Template' from the Bulk Import modal.",
            "2. Fill Data — Add client records from Row 3 onwards in the 'Client Import Data' sheet.",
            "3. Reference — Use the 'Master Reference' sheet to find valid values for City, Source, Type.",
            "4. Upload — Click 'Bulk Import Clients' → select your filled file → click Upload.",
            "5. Review Summary — An on-screen summary will show Processed, Success, and Failed counts.",
            "6. Download Errors — If there are failures, download the Error Report (Excel or PDF).",
        };
        for (String step : steps) {
            Paragraph p = new Paragraph(step, bodyFont);
            p.setSpacingAfter(4);
            doc.add(p);
        }
        doc.add(Chunk.NEWLINE);

        // ── Valid Lookup Values ───────────────────────────────────────────────
        doc.add(new Paragraph("Valid Lookup Values (at time of download)", h2Font));

        // Cities
        List<City> cities = cityRepository.findAll();
        addLookupSection(doc, "Cities", codeFont, noteFont,
                cities.stream().map(City::getName).toArray(String[]::new));

        // Sources
        List<ClientSourceEntity> sources = clientSourceService.findAllActive();
        addLookupSection(doc, "Client Sources", codeFont, noteFont,
                sources.stream().map(ClientSourceEntity::getSourceName).toArray(String[]::new));

        // Types
        List<ClientTypeEntity> types = clientTypeService.findAllActive();
        addLookupSection(doc, "Client Types", codeFont, noteFont,
                types.stream().map(ClientTypeEntity::getTypeName).toArray(String[]::new));

        addLookupSection(doc, "Status Values", codeFont, noteFont, new String[]{"Active", "Inactive"});

        // ── Footer Note ───────────────────────────────────────────────────────
        doc.add(Chunk.NEWLINE);
        Paragraph note = new Paragraph(
            "Note: Only INSERT is supported. Existing clients will not be updated through import. " +
            "Auto-creating missing master values is not supported — ensure all lookup values exist first.",
            noteFont);
        note.setSpacingBefore(6);
        doc.add(note);

        doc.close();
    }

    // ── Error Report — Plain Text (.txt) ──────────────────────────────────────

    public void writeErrorReportTxt(HttpServletResponse response, List<ImportErrorRow> errors) throws IOException {
        response.setContentType("text/plain;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=Import_Error_Report.txt");

        StringBuilder sb = new StringBuilder();
        sb.append("========================================================================\n");
        sb.append("                   BULK CLIENT IMPORT - ERROR REPORT                    \n");
        sb.append("========================================================================\n");
        sb.append("Generated At : ").append(java.time.LocalDateTime.now()).append("\n");
        sb.append("Total Failed : ").append(errors.size()).append(" record(s)\n");
        sb.append("========================================================================\n\n");

        if (errors.isEmpty()) {
            sb.append("No errors found. All records imported successfully.\n");
        } else {
            sb.append(String.format("%-8s | %-20s | %-12s | %-25s | %s\n",
                    "ROW NO.", "CLIENT NAME", "MOBILE", "EMAIL", "FAILURE REASON"));
            sb.append("----------------------------------------------------------------------------------------------------\n");

            for (ImportErrorRow err : errors) {
                String rowNumStr = "Row " + err.getRowNumber();
                String nameStr = nvl(err.getClientName());
                if (nameStr.length() > 20) nameStr = nameStr.substring(0, 17) + "...";
                String mobileStr = nvl(err.getMobile());
                String emailStr = nvl(err.getEmail());
                if (emailStr.length() > 25) emailStr = emailStr.substring(0, 22) + "...";
                String reasonStr = nvl(err.getReason());

                sb.append(String.format("%-8s | %-20s | %-12s | %-25s | %s\n",
                        rowNumStr, nameStr, mobileStr, emailStr, reasonStr));
            }
        }
        sb.append("\n========================================================================\n");

        response.getWriter().write(sb.toString());
        response.getWriter().flush();
    }

    // ── Private Helpers ───────────────────────────────────────────────────────

    private XSSFCellStyle createHeaderStyle(XSSFWorkbook wb, byte[] rgb) {
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 11);
        font.setColor(new XSSFColor(new byte[]{(byte)255, (byte)255, (byte)255}, null));
        style.setFont(font);
        style.setFillForegroundColor(new XSSFColor(rgb, null));
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    private XSSFCellStyle createSampleStyle(XSSFWorkbook wb) {
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setFontHeightInPoints((short) 10);
        style.setFont(font);
        style.setFillForegroundColor(new XSSFColor(new byte[]{(byte)241, (byte)245, (byte)249}, null));
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    private XSSFCellStyle createInfoStyle(XSSFWorkbook wb) {
        XSSFCellStyle style = wb.createCellStyle();
        XSSFFont font = wb.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 10);
        font.setColor(new XSSFColor(new byte[]{(byte)120, (byte)53, (byte)15}, null));
        style.setFont(font);
        style.setFillForegroundColor(new XSSFColor(new byte[]{(byte)254, (byte)243, (byte)199}, null));
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setWrapText(true);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        return style;
    }

    private int writeRefSection(XSSFSheet sheet, int startRow, String title,
                                XSSFCellStyle headerStyle, XSSFCellStyle dataStyle,
                                String[] values) {
        Row headerRow = sheet.createRow(startRow++);
        Cell hc = headerRow.createCell(0);
        hc.setCellValue(title);
        hc.setCellStyle(headerStyle);

        for (String v : values) {
            Row dataRow = sheet.createRow(startRow++);
            Cell dc = dataRow.createCell(0);
            dc.setCellValue(v);
            dc.setCellStyle(dataStyle);
        }
        return startRow;
    }

    private void addTableHeader(PdfPTable table, String... headers) {
        Font hf = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, hf));
            cell.setBackgroundColor(new BaseColor(15, 23, 42));
            cell.setPadding(7);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }
    }

    private void addTableRow(PdfPTable table, String col, String mandatory, String notes,
                             Font dataFont) {
        table.addCell(new PdfPCell(new Phrase(col, dataFont)));
        PdfPCell mc = new PdfPCell(new Phrase(mandatory,
                mandatory.startsWith("YES") ?
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, new BaseColor(185, 28, 28)) :
                    FontFactory.getFont(FontFactory.HELVETICA, 9, new BaseColor(100, 116, 139))));
        mc.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(mc);
        table.addCell(new PdfPCell(new Phrase(notes, FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.BLACK))));
    }

    private void addLookupSection(Document doc, String title, Font codeFont, Font noteFont,
                                  String[] values) throws DocumentException {
        Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, new BaseColor(30, 64, 175));
        Paragraph titleP = new Paragraph(title + ":", boldFont);
        titleP.setSpacingBefore(6);
        doc.add(titleP);

        if (values.length == 0) {
            doc.add(new Paragraph("  (No active records found)", noteFont));
        } else {
            StringBuilder sb = new StringBuilder("  ");
            for (int i = 0; i < values.length; i++) {
                sb.append(values[i]);
                if (i < values.length - 1) sb.append("  |  ");
            }
            doc.add(new Paragraph(sb.toString(), codeFont));
        }
    }

    private String nvl(String s) { return s == null ? "" : s; }
}
