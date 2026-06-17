package com.ihwthms.controller;

import com.ihwthms.entity.ClientEntity;
import com.ihwthms.entity.Lead;
import com.ihwthms.entity.LeadsFollowupEntity;
import com.ihwthms.entity.User;
import com.ihwthms.model.LeadDTO;
import com.ihwthms.model.LeadFollowupVO;
import com.ihwthms.repository.UserRepository;
import com.ihwthms.service.ClientService;
import com.ihwthms.service.LeadService;
import com.ihwthms.service.WorkloadStatusService;
import com.ihwthms.service.ClientSourceService;
import com.ihwthms.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@Controller
public class LeadController {

    @Autowired private LeadService leadService;
    @Autowired private ClientService clientService;
    @Autowired private UserRepository userRepository;
    @Autowired private WorkloadStatusService workloadStatusService;
    @Autowired private ClientSourceService clientSourceService;
    @Autowired private NotificationService notificationService;

    private static final DateTimeFormatter DTF = DateTimeFormatter.ofPattern("dd/MMM/yyyy HH:mm");

    private static final List<String> PRIORITIES = Arrays.asList("HIGH", "MEDIUM", "LOW");

    private User getLoggedInUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username).orElse(null);
    }

    private Map<Long, String> getActiveUsersMap() {
        return userRepository.findAll().stream()
                .filter(User::isActive)
                .collect(Collectors.toMap(User::getId, User::getUsername));
    }

    // ─── ADD LEAD FORM ───────────────────────────────────────────────────────
    @GetMapping("/view_add_lead_form")
    public ModelAndView viewAddLeadForm() {
        ModelAndView mv = new ModelAndView("leads/createLead");
        mv.addObject("LEAD_OBJ", new LeadDTO());
        mv.addObject("ACTIVE_USERS_MAP", getActiveUsersMap());
        mv.addObject("LEAD_STATUSES", workloadStatusService.getActiveLeadStatuses());
        mv.addObject("PRIORITIES", PRIORITIES);
        mv.addObject("CLIENT_SOURCES", clientSourceService.findAllActive());
        return mv;
    }

    // ─── CREATE LEAD ─────────────────────────────────────────────────────────
    @PostMapping("/create_lead")
    public String createLead(@ModelAttribute("LEAD_OBJ") LeadDTO dto,
                             RedirectAttributes ra) {
        // Validate client selection
        if (dto.getClientId() == null || dto.getClientId() <= 0) {
            ra.addFlashAttribute("error", "Please select a valid client before creating a lead.");
            return "redirect:/view_add_lead_form";
        }

        // Validate required lead fields
        if (dto.getLeadTitle() == null || dto.getLeadTitle().trim().isEmpty()) {
            ra.addFlashAttribute("error", "Lead Title is required.");
            return "redirect:/view_add_lead_form";
        }
        if (dto.getLeadSource() == null || dto.getLeadSource().trim().isEmpty()) {
            ra.addFlashAttribute("error", "Lead Source is required.");
            return "redirect:/view_add_lead_form";
        }
        if (dto.getEventName() == null || dto.getEventName().trim().isEmpty()) {
            ra.addFlashAttribute("error", "Event Name is required.");
            return "redirect:/view_add_lead_form";
        }
        if (dto.getAssignedTo() == null) {
            ra.addFlashAttribute("error", "Assigned To is required.");
            return "redirect:/view_add_lead_form";
        }

        // Load client entity
        ClientEntity client = clientService.findById(dto.getClientId());
        if (client == null) {
            ra.addFlashAttribute("error", "Selected client does not exist.");
            return "redirect:/view_add_lead_form";
        }

        // Client mobile/email are optional — lead can still be created without them

        // Create new Lead entity and populate from DTO
        Lead lead = new Lead();
        User loggedIn = getLoggedInUser();
        populateLeadFromDTO(lead, dto, loggedIn);

        // Fallback for lead name if not provided
        if (lead.getLeadName() == null || lead.getLeadName().trim().isEmpty()) {
            lead.setLeadName(client.getClientName());
        }

        // Set client contact details on the lead
        lead.setClient(client);
        lead.setMobileNumber(client.getMobile());
        lead.setEmail(client.getEmailId());
        lead.setCity(client.getCity());
        lead.setCountry(client.getCountry());

        // Auto-populate organisation fields from the linked client (stored in DB, not shown on form)
        lead.setOrganizationName(client.getOrganizationName());
        lead.setOrganizationType(client.getOrganizationType());
        lead.setRegistrationNumber(client.getRegistrationNumber());
        lead.setWebsite(client.getWebsite());
        lead.setAddress(client.getAddress());
        lead.setPostalCode(client.getPostalCode());
        lead.setDesignation(client.getDesignation());

        // Persist and notify
        leadService.saveLead(lead);
        notificationService.sendLeadRegistrationNotifications(lead);
        ra.addFlashAttribute("success", "Lead created successfully!");
        return "redirect:/view_filter_leads";
    }

    // ─── FILTER / LIST LEADS ─────────────────────────────────────────────────
    @GetMapping("/view_filter_leads")
    public ModelAndView viewFilterLeads(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) List<String> leadStatus,
            @RequestParam(required = false) String leadSource,
            @RequestParam(required = false) String clientName,
            @RequestParam(required = false) Long assignedTo,
            @RequestParam(required = false) String priority) {

        ModelAndView mv = new ModelAndView("leads/view_filterLeads");
        Page<Lead> pagedLeads = leadService.filterLeads(page, pageSize, leadStatus,
                leadSource, clientName, assignedTo, priority);

        List<LeadDTO> dtoList = new ArrayList<>();
        for (Lead lead : pagedLeads.getContent()) {
            dtoList.add(buildLeadDTO(lead));
        }

        String statusJoined = "";
        if (leadStatus != null && !leadStatus.isEmpty()) {
            List<String> activeList = new java.util.ArrayList<>();
            for (String s : leadStatus) {
                if (s != null && !s.trim().isEmpty()) activeList.add(s.trim());
            }
            statusJoined = String.join(",", activeList);
        }

        mv.addObject("LEADS_LIST", dtoList);
        mv.addObject("currentPage", page);
        mv.addObject("totalPages", pagedLeads.getTotalPages());
        mv.addObject("totalLeads", pagedLeads.getTotalElements());
        mv.addObject("pageSize", pageSize);
        mv.addObject("ACTIVE_USERS_MAP", getActiveUsersMap());
        mv.addObject("LEAD_STATUSES", workloadStatusService.getActiveLeadStatuses());
        mv.addObject("PRIORITIES", PRIORITIES);
        mv.addObject("CLIENT_SOURCES", clientSourceService.findAllActive());
        mv.addObject("f_leadStatus", leadStatus);
        mv.addObject("f_leadStatusString", statusJoined);
        mv.addObject("f_leadSource", leadSource);
        mv.addObject("f_clientName", clientName);
        mv.addObject("f_assignedTo", assignedTo);
        mv.addObject("f_priority", priority);
        return mv;
    }

    // ─── VIEW LEAD DETAILS ───────────────────────────────────────────────────
    @GetMapping("/view_lead_details")
    public ModelAndView viewLeadDetails(@RequestParam Long leadId) {
        ModelAndView mv = new ModelAndView("leads/viewLeadDetails");
        Lead lead = leadService.findById(leadId);
        mv.addObject("LEAD_OBJ", buildLeadDTO(lead));
        return mv;
    }

    // ─── EDIT LEAD FORM ──────────────────────────────────────────────────────
    @GetMapping("/view_edit_lead_form")
    public ModelAndView viewEditLeadForm(@RequestParam Long leadId) {
        ModelAndView mv = new ModelAndView("leads/editLead");
        Lead lead = leadService.findById(leadId);
        mv.addObject("LEAD_OBJ", buildLeadDTO(lead));
        mv.addObject("ACTIVE_USERS_MAP", getActiveUsersMap());
        mv.addObject("LEAD_STATUSES", workloadStatusService.getActiveLeadStatuses());
        mv.addObject("PRIORITIES", PRIORITIES);
        mv.addObject("CLIENT_SOURCES", clientSourceService.findAllActive());
        return mv;
    }

    // ─── UPDATE LEAD ─────────────────────────────────────────────────────────
    @PostMapping("/edit_lead")
    public String editLead(@ModelAttribute("LEAD_OBJ") LeadDTO dto,
                           RedirectAttributes ra) {
        User loggedIn = getLoggedInUser();
        Lead lead = leadService.findById(dto.getLeadId());
        populateLeadFromDTO(lead, dto, loggedIn);

        if (dto.getClientId() != null && dto.getClientId() > 0) {
            ClientEntity client = clientService.findById(dto.getClientId());
            lead.setClient(client);
            lead.setMobileNumber(client.getMobile());
            lead.setEmail(client.getEmailId());
            lead.setCity(client.getCity());
            lead.setCountry(client.getCountry());
        }

        leadService.saveLead(lead);
        ra.addFlashAttribute("success", "Lead updated successfully!");
        return "redirect:/view_filter_leads";
    }

    // ─── FOLLOWUP DETAILS PAGE ───────────────────────────────────────────────
    @GetMapping("view_lead_followup_details")
    public ModelAndView viewFollowupDetails(@RequestParam Long leadId) {
        ModelAndView mv = new ModelAndView("leads/viewLeadFollowupDetails");
        Lead lead = leadService.findById(leadId);
        mv.addObject("LEAD_OBJ", buildLeadDTO(lead));

        List<LeadFollowupVO> followups = new ArrayList<>();
        for (LeadsFollowupEntity f : leadService.findFollowupsByLeadId(leadId)) {
            LeadFollowupVO vo = new LeadFollowupVO();
            vo.setLeadFollowupId(f.getLeadFollowupId());
            vo.setLeadId(leadId);
            vo.setResponse(f.getResponse());
            vo.setNextactionplan(f.getNextactionplan());
            if (f.getFollowuptime() != null)
                vo.setFormattedFollowupTime(f.getFollowuptime().format(DTF));
            if (f.getNextfollowuptime() != null)
                vo.setFormattedNextFollowupTime(f.getNextfollowuptime().format(DTF));
            if (f.getUpdatedBy() != null) {
                Optional<User> u = userRepository.findById(f.getUpdatedBy());
                if (u.isPresent()) vo.setUpdatedByName(u.get().getUsername());
            }
            followups.add(vo);
        }

        mv.addObject("FOLLOWUP_LIST", followups);
        mv.addObject("FOLLOWUP_OBJ", new LeadFollowupVO());
        return mv;
    }

    // ─── SAVE FOLLOWUP ───────────────────────────────────────────────────────
    @PostMapping("/create_lead_followup")
    public String createFollowup(@RequestParam Long leadId,
                                 @ModelAttribute("FOLLOWUP_OBJ") LeadFollowupVO vo,
                                 RedirectAttributes ra) {
        User loggedIn = getLoggedInUser();
        Lead lead = leadService.findById(leadId);

        LeadsFollowupEntity followup = new LeadsFollowupEntity();
        followup.setLeadEntity(lead);
        followup.setFollowuptime(vo.getFollowuptime());
        followup.setResponse(vo.getResponse());
        followup.setNextfollowuptime(vo.getNextfollowuptime());
        followup.setNextactionplan(vo.getNextactionplan());
        if (loggedIn != null) {
            followup.setUpdatedBy(loggedIn.getId());
            followup.setCreatedBy(loggedIn.getId());
        }

        leadService.saveFollowup(followup);
        ra.addFlashAttribute("success", "Followup recorded successfully!");
        return "redirect:view_lead_followup_details?leadId=" + leadId;
    }

    // ─── EXPORT EXCEL ────────────────────────────────────────────────────────
    @GetMapping("/leads/export/excel")
    public void exportToExcel(
            @RequestParam(required = false) List<String> leadStatus,
            @RequestParam(required = false) String leadSource,
            @RequestParam(required = false) String clientName,
            @RequestParam(required = false) Long assignedTo,
            @RequestParam(required = false) String priority,
            HttpServletResponse response) throws IOException {

        List<Lead> leads = leadService.filterLeadsList(leadStatus, leadSource, clientName, assignedTo, priority);
        Map<Long, String> usersMap = getActiveUsersMap();

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Leads");

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

        Row headerRow = sheet.createRow(0);
        String[] columns = {"ID", "Lead Title", "Lead Name", "Client", "Mobile", "City", "Status", "Source", "Event Name", "Priority", "Assigned To"};
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
            cell.setCellStyle(headerCellStyle);
        }

        int rowNum = 1;
        for (Lead lead : leads) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(lead.getId() != null ? lead.getId() : 0);
            row.createCell(1).setCellValue(lead.getLeadTitle() != null ? lead.getLeadTitle() : "");
            row.createCell(2).setCellValue(lead.getLeadName() != null ? lead.getLeadName() : "");
            row.createCell(3).setCellValue(lead.getClient() != null ? lead.getClient().getClientName() : "");
            row.createCell(4).setCellValue(lead.getMobileNumber() != null ? lead.getMobileNumber() : "");
            row.createCell(5).setCellValue(lead.getCity() != null ? lead.getCity() : "");
            row.createCell(6).setCellValue(lead.getLeadStatus() != null ? lead.getLeadStatus() : "");
            row.createCell(7).setCellValue(lead.getLeadSource() != null ? lead.getLeadSource() : "");
            row.createCell(8).setCellValue(lead.getEventName() != null ? lead.getEventName() : "");
            row.createCell(9).setCellValue(lead.getPriority() != null ? lead.getPriority() : "");
            String assignedName = "";
            if (lead.getAssignedTo() != null && usersMap.containsKey(lead.getAssignedTo())) {
                assignedName = usersMap.get(lead.getAssignedTo());
            }
            row.createCell(10).setCellValue(assignedName);
        }

        for (int i = 0; i < columns.length; i++) {
            sheet.autoSizeColumn(i);
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=leads.xlsx");
        workbook.write(response.getOutputStream());
        workbook.close();
    }

    // ─── EXPORT PDF ──────────────────────────────────────────────────────────
    @GetMapping("/leads/export/pdf")
    public void exportToPdf(
            @RequestParam(required = false) List<String> leadStatus,
            @RequestParam(required = false) String leadSource,
            @RequestParam(required = false) String clientName,
            @RequestParam(required = false) Long assignedTo,
            @RequestParam(required = false) String priority,
            HttpServletResponse response) throws IOException, DocumentException {

        List<Lead> leads = leadService.filterLeadsList(leadStatus, leadSource, clientName, assignedTo, priority);
        Map<Long, String> usersMap = getActiveUsersMap();

        Document document = new Document(PageSize.A4.rotate());
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=leads.pdf");

        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        com.itextpdf.text.Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
        Paragraph title = new Paragraph("Lead Directory", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        PdfPTable table = new PdfPTable(11);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        com.itextpdf.text.Font pdfHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
        String[] headers = {"ID", "Lead Title", "Lead Name", "Client", "Mobile", "City", "Status", "Source", "Event Name", "Priority", "Assigned To"};
        for (String h : headers) {
            PdfPCell headerCell = new PdfPCell(new Phrase(h, pdfHeaderFont));
            headerCell.setBackgroundColor(new BaseColor(15, 23, 42));
            headerCell.setPadding(8);
            headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(headerCell);
        }

        com.itextpdf.text.Font dataFont = FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.BLACK);
        for (Lead lead : leads) {
            table.addCell(new PdfPCell(new Phrase(String.valueOf(lead.getId() != null ? lead.getId() : 0), dataFont)));
            table.addCell(new PdfPCell(new Phrase(lead.getLeadTitle() != null ? lead.getLeadTitle() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(lead.getLeadName() != null ? lead.getLeadName() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(lead.getClient() != null ? lead.getClient().getClientName() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(lead.getMobileNumber() != null ? lead.getMobileNumber() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(lead.getCity() != null ? lead.getCity() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(lead.getLeadStatus() != null ? lead.getLeadStatus() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(lead.getLeadSource() != null ? lead.getLeadSource() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(lead.getEventName() != null ? lead.getEventName() : "", dataFont)));
            table.addCell(new PdfPCell(new Phrase(lead.getPriority() != null ? lead.getPriority() : "", dataFont)));
            String assignedName = "";
            if (lead.getAssignedTo() != null && usersMap.containsKey(lead.getAssignedTo())) {
                assignedName = usersMap.get(lead.getAssignedTo());
            }
            table.addCell(new PdfPCell(new Phrase(assignedName, dataFont)));
        }

        document.add(table);
        document.close();
    }

    // ─── JSON: client typeahead ──────────────────────────────────────────────────
    @GetMapping("/getClientList")
    @ResponseBody
    public List<Map<String, Object>> getClientList(
            @RequestParam(defaultValue = "") String clientName) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<ClientEntity> clients = clientName.trim().isEmpty()
                ? clientService.findAllActive()
                : clientService.searchByName(clientName);
        for (ClientEntity c : clients) {
            Map<String, Object> m = new HashMap<>();
            m.put("clientId",           c.getClientId());
            m.put("clientName",         c.getClientName());
            m.put("mobile",             c.getMobile());
            m.put("emailId",            c.getEmailId());
            m.put("city",               c.getCity());
            m.put("country",            c.getCountry());
            m.put("organizationName",   c.getOrganizationName());
            m.put("organizationType",   c.getOrganizationType());
            m.put("registrationNumber", c.getRegistrationNumber());
            m.put("website",            c.getWebsite());
            m.put("address",            c.getAddress());
            m.put("postalCode",         c.getPostalCode());
            m.put("designation",        c.getDesignation());
            m.put("clientType",         c.getClientType());
            m.put("clientSource",       c.getClientSource());
            result.add(m);
        }
        return result;
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────
    private void populateLeadFromDTO(Lead lead, LeadDTO dto, User loggedIn) {
        lead.setLeadTitle(dto.getLeadTitle());
        lead.setLeadName(dto.getLeadName());
        lead.setLeadStatus(dto.getLeadStatus() != null ? dto.getLeadStatus() : "Open");
        lead.setLeadSource(dto.getLeadSource());
        lead.setEventName(dto.getEventName());
        lead.setPriority(dto.getPriority());
        lead.setAssignedTo(dto.getAssignedTo());
        lead.setRemarks(dto.getRemarks());
        lead.setIsActive(dto.getIsActive() != null ? dto.getIsActive() : Boolean.TRUE);
        if (loggedIn != null) {
            if (lead.getId() == null) lead.setCreatedBy(loggedIn.getId());
            lead.setUpdatedBy(loggedIn.getId());
        }
    }

    private LeadDTO buildLeadDTO(Lead lead) {
        LeadDTO dto = new LeadDTO(lead);
        if (lead.getAssignedTo() != null) {
            Optional<User> u = userRepository.findById(lead.getAssignedTo());
            if (u.isPresent()) dto.setAssignedToName(u.get().getUsername());
        }
        return dto;
    }
}
