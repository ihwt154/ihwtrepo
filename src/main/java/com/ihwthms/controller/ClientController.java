package com.ihwthms.controller;

import com.ihwthms.entity.ClientEntity;
import com.ihwthms.entity.User;
import com.ihwthms.model.ClientDTO;
import com.ihwthms.model.ImportErrorRow;
import com.ihwthms.model.ImportResultDTO;
import com.ihwthms.repository.CityRepository;
import com.ihwthms.repository.UserRepository;
import com.ihwthms.service.ClientImportService;
import com.ihwthms.service.ClientService;
import com.ihwthms.service.ClientSourceService;
import com.ihwthms.service.ClientTemplateService;
import com.ihwthms.service.ClientTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.MediaType;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@Controller
public class ClientController {

    private static final String SESSION_IMPORT_ERRORS = "importErrors";

    @Autowired
    private ClientService clientService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private ClientSourceService clientSourceService;
    @Autowired
    private ClientTypeService clientTypeService;
    @Autowired
    private CityRepository cityRepository;
    @Autowired
    private ClientImportService clientImportService;
    @Autowired
    private ClientTemplateService clientTemplateService;

    private static final List<String> CLIENT_STATUSES = Arrays.asList(
            "Active", "Inactive");

    private User getLoggedInUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username).orElse(null);
    }

    // ─── ADD CLIENT FORM ─────────────────────────────────────────────────────
    @GetMapping("view_add_client_form")
    public ModelAndView viewAddClientForm() {
        User loggedIn = getLoggedInUser();
        boolean hasAccess = loggedIn != null &&
                (loggedIn.hasRole("ADMIN") || loggedIn.hasRole("SUPERADMIN") || loggedIn.hasRole("CLIENT_CREATE"));
        if (!hasAccess) {
            return new ModelAndView("redirect:/dashboard");
        }

        boolean canManage = loggedIn != null &&
                (loggedIn.hasRole("ADMIN") || loggedIn.hasRole("SUPERADMIN") || loggedIn.hasRole("CLIENT_MANAGE"));
        String clientListUrl = canManage ? "view_clients_list" : "view_my_clients";

        ModelAndView mv = new ModelAndView("admin/client/Admin_Add_Client");
        mv.addObject("CLIENT_OBJ", new ClientDTO());
        mv.addObject("CLIENT_STATUSES", CLIENT_STATUSES);
        mv.addObject("CLIENT_SOURCES", clientSourceService.findAllActive());
        mv.addObject("CLIENT_TYPES", clientTypeService.findAllActive());
        mv.addObject("CITIES", cityRepository.findAll());
        mv.addObject("CLIENT_LIST_URL", clientListUrl);
        return mv;
    }

    // ─── CREATE CLIENT ───────────────────────────────────────────────────────
    @PostMapping("create_client")
    public String createClient(@ModelAttribute("CLIENT_OBJ") ClientDTO dto,
            RedirectAttributes ra) {
        User loggedIn = getLoggedInUser();
        if (loggedIn == null || !(loggedIn.hasRole("ADMIN") || loggedIn.hasRole("SUPERADMIN")
                || loggedIn.hasRole("CLIENT_CREATE"))) {
            ra.addFlashAttribute("error", "You do not have permission to create clients.");
            return "redirect:/dashboard";
        }

        if (dto.getMobile() != null && !dto.getMobile().trim().isEmpty()
                && clientService.isMobileExists(dto.getMobile())) {
            ra.addFlashAttribute("error", "A client with this mobile number already exists.");
            return "redirect:view_add_client_form";
        }

        ClientEntity entity = buildEntityFromDTO(dto, null, loggedIn);
        clientService.saveClient(entity);
        ra.addFlashAttribute("success", "Client created successfully!");

        // CLIENT_MANAGE (or ADMIN/SUPERADMIN) → full list
        // CLIENT_CREATE only → their own clients list
        boolean canManage = loggedIn.hasRole("ADMIN") || loggedIn.hasRole("SUPERADMIN")
                || loggedIn.hasRole("CLIENT_MANAGE");
        return canManage ? "redirect:view_clients_list" : "redirect:view_my_clients";
    }

    // ─── CLIENT LIST (All — for CLIENT_MANAGE / ADMIN) ───────────────────────
    @GetMapping("view_clients_list")
    public ModelAndView viewClientList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String clientName,
            @RequestParam(required = false) Boolean active,
            @RequestParam(required = false) String city) {

        User user = getLoggedInUser();
        // Only ADMIN / SUPERADMIN / CLIENT_MANAGE roles see all clients
        boolean canManageAll = user != null &&
                (user.hasRole("ADMIN") || user.hasRole("SUPERADMIN") || user.hasRole("CLIENT_MANAGE"));
        // CLIENT_CREATE-only users who somehow navigate here are redirected to their
        // own list
        if (!canManageAll) {
            return new ModelAndView("redirect:/view_my_clients");
        }

        ModelAndView mv = new ModelAndView("admin/client/viewClientListing");
        Page<ClientEntity> paged = clientService.filterClients(clientName, active, city, null,
                PageRequest.of(page, pageSize));

        List<ClientDTO> dtoList = new ArrayList<>();
        for (ClientEntity e : paged.getContent()) {
            dtoList.add(new ClientDTO(e));
        }

        mv.addObject("CLIENT_LIST", dtoList);
        mv.addObject("currentPage", page);
        mv.addObject("totalPages", paged.getTotalPages());
        mv.addObject("totalClients", paged.getTotalElements());
        mv.addObject("pageSize", pageSize);
        mv.addObject("f_clientName", clientName);
        mv.addObject("f_active", active);
        mv.addObject("f_city", city);
        mv.addObject("CLIENT_STATUSES", CLIENT_STATUSES);
        mv.addObject("CITIES", cityRepository.findAll());
        mv.addObject("MY_CLIENTS_ONLY", false);
        return mv;
    }

    // ─── MY CLIENT LIST (Scoped — for CLIENT_CREATE users) ───────────────────
    @GetMapping("view_my_clients")
    public ModelAndView viewMyClientList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String clientName,
            @RequestParam(required = false) Boolean active,
            @RequestParam(required = false) String city) {

        User user = getLoggedInUser();
        if (user == null || !(user.hasRole("ADMIN") || user.hasRole("SUPERADMIN")
                || user.hasRole("CLIENT_CREATE") || user.hasRole("CLIENT_MANAGE"))) {
            return new ModelAndView("redirect:/dashboard");
        }

        Long createdBy = user.getId();

        ModelAndView mv = new ModelAndView("admin/client/viewClientListing");
        Page<ClientEntity> paged = clientService.filterClients(clientName, active, city, createdBy,
                PageRequest.of(page, pageSize));

        List<ClientDTO> dtoList = new ArrayList<>();
        for (ClientEntity e : paged.getContent()) {
            dtoList.add(new ClientDTO(e));
        }

        mv.addObject("CLIENT_LIST", dtoList);
        mv.addObject("currentPage", page);
        mv.addObject("totalPages", paged.getTotalPages());
        mv.addObject("totalClients", paged.getTotalElements());
        mv.addObject("pageSize", pageSize);
        mv.addObject("f_clientName", clientName);
        mv.addObject("f_active", active);
        mv.addObject("f_city", city);
        mv.addObject("CLIENT_STATUSES", CLIENT_STATUSES);
        mv.addObject("CITIES", cityRepository.findAll());
        mv.addObject("MY_CLIENTS_ONLY", true); // flag so JSP can adapt labels/links
        return mv;
    }

    // ─── VIEW CLIENT DETAILS ─────────────────────────────────────────────────
    @GetMapping("view_client_details")
    public ModelAndView viewClientDetails(@RequestParam Long clientId) {
        User loggedIn = getLoggedInUser();
        boolean canManage = loggedIn != null &&
                (loggedIn.hasRole("ADMIN") || loggedIn.hasRole("SUPERADMIN") || loggedIn.hasRole("CLIENT_MANAGE"));
        String clientListUrl = canManage ? "view_clients_list" : "view_my_clients";

        ModelAndView mv = new ModelAndView("admin/client/Admin_View_Client");
        ClientEntity entity = clientService.findById(clientId);
        mv.addObject("CLIENT_OBJ", new ClientDTO(entity));
        mv.addObject("CLIENT_LIST_URL", clientListUrl);
        return mv;
    }

    // ─── EDIT CLIENT FORM ────────────────────────────────────────────────────
    @GetMapping("view_edit_client_form")
    public ModelAndView viewEditClientForm(@RequestParam Long clientId) {
        User loggedIn = getLoggedInUser();
        boolean canManage = loggedIn != null &&
                (loggedIn.hasRole("ADMIN") || loggedIn.hasRole("SUPERADMIN") || loggedIn.hasRole("CLIENT_MANAGE"));
        String clientListUrl = canManage ? "view_clients_list" : "view_my_clients";

        ModelAndView mv = new ModelAndView("admin/client/Admin_Edit_Client");
        ClientEntity entity = clientService.findById(clientId);
        mv.addObject("CLIENT_OBJ", new ClientDTO(entity));
        mv.addObject("CLIENT_STATUSES", CLIENT_STATUSES);
        mv.addObject("CLIENT_SOURCES", clientSourceService.findAllActive());
        mv.addObject("CLIENT_TYPES", clientTypeService.findAllActive());
        mv.addObject("CITIES", cityRepository.findAll());
        mv.addObject("CLIENT_LIST_URL", clientListUrl);
        return mv;
    }

    // ─── UPDATE CLIENT ───────────────────────────────────────────────────────
    @PostMapping("edit_client")
    public String editClient(@ModelAttribute("CLIENT_OBJ") ClientDTO dto,
            RedirectAttributes ra) {
        if (dto.getMobile() != null && !dto.getMobile().trim().isEmpty()
                && clientService.isMobileExistsForOther(dto.getMobile(), dto.getClientId())) {
            ra.addFlashAttribute("error", "Another client already uses this mobile number.");
            return "redirect:view_edit_client_form?clientId=" + dto.getClientId();
        }
        User loggedIn = getLoggedInUser();
        ClientEntity existing = clientService.findById(dto.getClientId());
        buildEntityFromDTO(dto, existing, loggedIn);
        clientService.saveClient(existing);
        ra.addFlashAttribute("success", "Client updated successfully!");
        boolean canManage = loggedIn != null &&
                (loggedIn.hasRole("ADMIN") || loggedIn.hasRole("SUPERADMIN") || loggedIn.hasRole("CLIENT_MANAGE"));
        return canManage ? "redirect:view_clients_list" : "redirect:view_my_clients";
    }

    // ─── TOGGLE ACTIVE ───────────────────────────────────────────────────────
    @PostMapping("toggle_client")
    public String toggleClient(@RequestParam Long clientId, RedirectAttributes ra) {
        clientService.toggleActive(clientId);
        ra.addFlashAttribute("success", "Client status updated.");
        User loggedIn = getLoggedInUser();
        boolean canManage = loggedIn != null &&
                (loggedIn.hasRole("ADMIN") || loggedIn.hasRole("SUPERADMIN") || loggedIn.hasRole("CLIENT_MANAGE"));
        return canManage ? "redirect:view_clients_list" : "redirect:view_my_clients";
    }

    // ─── EXPORT EXCEL ────────────────────────────────────────────────────────
    @GetMapping("clients/export/excel")
    public void exportToExcel(
            @RequestParam(required = false) String clientName,
            @RequestParam(required = false) Boolean active,
            @RequestParam(required = false) String city,
            HttpServletResponse response) throws IOException {

        User user = getLoggedInUser();
        boolean canManageAll = user != null &&
                (user.hasRole("ADMIN") || user.hasRole("SUPERADMIN") || user.hasRole("CLIENT_MANAGE"));
        Long createdBy = canManageAll ? null : (user != null ? user.getId() : null);
        List<ClientEntity> clients = clientService.filterClientsList(clientName, active, city, createdBy);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Clients");

        // Header style
        org.apache.poi.ss.usermodel.Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 12);
        headerFont.setColor(IndexedColors.WHITE.getIndex());

        CellStyle headerCellStyle = workbook.createCellStyle();
        headerCellStyle.setFont(headerFont);
        headerCellStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        headerCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerCellStyle.setAlignment(HorizontalAlignment.CENTER);

        // Header Row
        Row headerRow = sheet.createRow(0);
        String[] columns = { "ID", "Client Name", "Mobile", "Email", "City", "Country", "Source", "Type", "Status" };
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
            cell.setCellStyle(headerCellStyle);
        }

        // Data Rows
        int rowNum = 1;
        for (ClientEntity client : clients) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(client.getClientId() != null ? client.getClientId() : 0);
            row.createCell(1).setCellValue(client.getClientName() != null ? client.getClientName() : "");
            row.createCell(2).setCellValue(client.getMobile() != null ? client.getMobile() : "");
            row.createCell(3).setCellValue(client.getEmailId() != null ? client.getEmailId() : "");
            row.createCell(4).setCellValue(client.getCity() != null ? client.getCity().getName() : "");
            row.createCell(5).setCellValue(client.getCountry() != null ? client.getCountry() : "");
            row.createCell(6).setCellValue(client.getClientSource() != null ? client.getClientSource() : "");
            row.createCell(7).setCellValue(client.getClientType() != null ? client.getClientType() : "");
            row.createCell(8).setCellValue(Boolean.TRUE.equals(client.getActive()) ? "Active" : "Inactive");
        }

        // Auto-size columns
        for (int i = 0; i < columns.length; i++) {
            sheet.autoSizeColumn(i);
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=clients.xlsx");
        workbook.write(response.getOutputStream());
        workbook.close();
    }

    // ─── EXPORT PDF ──────────────────────────────────────────────────────────
    @GetMapping("clients/export/pdf")
    public void exportToPdf(
            @RequestParam(required = false) String clientName,
            @RequestParam(required = false) Boolean active,
            @RequestParam(required = false) String city,
            HttpServletResponse response) throws IOException, DocumentException {

        User user = getLoggedInUser();
        boolean canManageAll = user != null &&
                (user.hasRole("ADMIN") || user.hasRole("SUPERADMIN") || user.hasRole("CLIENT_MANAGE"));
        Long createdBy = canManageAll ? null : (user != null ? user.getId() : null);
        List<ClientEntity> clients = clientService.filterClientsList(clientName, active, city, createdBy);

        Document document = new Document(PageSize.A4.rotate());
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=clients.pdf");

        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        // Title
        com.itextpdf.text.Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
        Paragraph title = new Paragraph("Client Directory", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // Table
        PdfPTable table = new PdfPTable(9);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        // Header style
        com.itextpdf.text.Font headerPdfFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
        String[] headers = { "ID", "Client Name", "Mobile", "Email", "City", "Country", "Source", "Type", "Status" };
        for (String h : headers) {
            PdfPCell headerCell = new PdfPCell(new Phrase(h, headerPdfFont));
            headerCell.setBackgroundColor(new BaseColor(15, 23, 42));
            headerCell.setPadding(8);
            headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(headerCell);
        }

        // Data rows style
        com.itextpdf.text.Font dataFont = FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.BLACK);
        for (ClientEntity client : clients) {
            table.addCell(new PdfPCell(
                    new Phrase(String.valueOf(client.getClientId() != null ? client.getClientId() : 0), dataFont)));
            table.addCell(
                    new PdfPCell(new Phrase(client.getClientName() != null ? client.getClientName() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(client.getMobile() != null ? client.getMobile() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(client.getEmailId() != null ? client.getEmailId() : "", dataFont)));
            table.addCell(
                    new PdfPCell(new Phrase(client.getCity() != null ? client.getCity().getName() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(client.getCountry() != null ? client.getCountry() : "", dataFont)));
            table.addCell(new PdfPCell(
                    new Phrase(client.getClientSource() != null ? client.getClientSource() : "", dataFont)));
            table.addCell(
                    new PdfPCell(new Phrase(client.getClientType() != null ? client.getClientType() : "", dataFont)));
            table.addCell(new PdfPCell(
                    new Phrase(Boolean.TRUE.equals(client.getActive()) ? "Active" : "Inactive", dataFont)));
        }

        document.add(table);
        document.close();
    }

    // ── BULK IMPORT: Download Excel Template ─────────────────────────────────
    @GetMapping("clients/import/template/excel")
    public void downloadExcelTemplate(HttpServletResponse response) throws IOException {
        User user = getLoggedInUser();
        if (user == null || !(user.hasRole("ADMIN") || user.hasRole("SUPERADMIN")
                || user.hasRole("CLIENT_CREATE"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        clientTemplateService.writeExcelTemplate(response);
    }

    // ── BULK IMPORT: Download PDF Quick Reference ─────────────────────────────
    @GetMapping("clients/import/template/pdf")
    public void downloadPdfGuide(HttpServletResponse response) throws IOException, DocumentException {
        User user = getLoggedInUser();
        if (user == null || !(user.hasRole("ADMIN") || user.hasRole("SUPERADMIN")
                || user.hasRole("CLIENT_CREATE"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        clientTemplateService.writePdfGuide(response);
    }

    // ── BULK IMPORT: Upload & Process Excel ───────────────────────────────────
    @PostMapping(value = "clients/import/upload", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String uploadImportFile(@RequestParam("file") MultipartFile file,
                                   HttpSession session) {
        User user = getLoggedInUser();
        if (user == null || !(user.hasRole("ADMIN") || user.hasRole("SUPERADMIN")
                || user.hasRole("CLIENT_CREATE"))) {
            return "{\"error\":\"Access Denied\"}";
        }
        if (file == null || file.isEmpty()) {
            return "{\"error\":\"No file uploaded\"}";
        }
        String originalName = file.getOriginalFilename();
        if (originalName == null || (!originalName.endsWith(".xlsx") && !originalName.endsWith(".xls"))) {
            return "{\"error\":\"Only .xlsx or .xls files are accepted\"}";
        }
        try {
            ImportResultDTO result = clientImportService.processImport(file, user.getId());
            // Store errors in session for later download
            session.setAttribute(SESSION_IMPORT_ERRORS, result.getErrors());
            return String.format(
                "{\"total\":%d,\"success\":%d,\"failed\":%d}",
                result.getTotalProcessed(), result.getSuccessCount(), result.getFailedCount());
        } catch (Exception ex) {
            return "{\"error\":\"Import failed: " + ex.getMessage().replace('"', '\'' ) + "\"}";
        }
    }

    // ── BULK IMPORT: Download Error Report (.txt) ─────────────────────────────
    @GetMapping("clients/import/error-report/txt")
    public void downloadErrorReportTxt(HttpServletResponse response, HttpSession session)
            throws IOException {
        User user = getLoggedInUser();
        if (user == null || !(user.hasRole("ADMIN") || user.hasRole("SUPERADMIN")
                || user.hasRole("CLIENT_CREATE"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        @SuppressWarnings("unchecked")
        List<ImportErrorRow> errors = (List<ImportErrorRow>) session.getAttribute(SESSION_IMPORT_ERRORS);
        if (errors == null) errors = new ArrayList<>();
        clientTemplateService.writeErrorReportTxt(response, errors);
    }

    // ─── Helper ──────────────────────────────────────────────────────────────
    private ClientEntity buildEntityFromDTO(ClientDTO dto, ClientEntity existing, User loggedIn) {
        ClientEntity entity = existing != null ? existing : new ClientEntity();
        entity.setClientName(dto.getClientName());
        entity.setMobile(dto.getMobile());
        entity.setEmailId(dto.getEmailId());
        if (dto.getCityId() != null) {
            entity.setCity(cityRepository.findById(dto.getCityId()).orElse(null));
        } else {
            entity.setCity(null);
        }
        entity.setCountry(dto.getCountry());
        entity.setClientStatus(dto.getClientStatus() != null ? dto.getClientStatus() : "Active");
        entity.setClientSource(dto.getClientSource());
        entity.setClientType(dto.getClientType());
        entity.setOrganizationName(dto.getOrganizationName());
        entity.setOrganizationType(dto.getOrganizationType());
        entity.setRegistrationNumber(dto.getRegistrationNumber());
        entity.setWebsite(dto.getWebsite());
        entity.setAddress(dto.getAddress());
        entity.setPostalCode(dto.getPostalCode());
        entity.setDesignation(dto.getDesignation());
        entity.setRemarks(dto.getRemarks());
        entity.setActive(dto.getActive() != null ? dto.getActive() : Boolean.TRUE);
        if (loggedIn != null) {
            if (existing == null)
                entity.setCreatedBy(loggedIn.getId());
            entity.setUpdatedBy(loggedIn.getId());
        }
        return entity;
    }
}
