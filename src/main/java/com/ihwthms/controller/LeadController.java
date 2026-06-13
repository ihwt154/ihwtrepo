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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class LeadController {

    @Autowired private LeadService leadService;
    @Autowired private ClientService clientService;
    @Autowired private UserRepository userRepository;

    private static final DateTimeFormatter DTF = DateTimeFormatter.ofPattern("dd/MMM/yyyy HH:mm");

    private static final List<String> LEAD_STATUSES = Arrays.asList(
            "NEW", "CONTACTED", "QUALIFIED", "PROPOSAL_SENT", "NEGOTIATION", "LOST", "WON");
    private static final List<String> LEAD_SOURCES = Arrays.asList(
            "WEBSITE", "REFERRAL", "COLD_CALL", "EMAIL_CAMPAIGN", "SOCIAL_MEDIA", "WALK_IN", "OTHER");
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
    @GetMapping("view_add_lead_form")
    public ModelAndView viewAddLeadForm() {
        ModelAndView mv = new ModelAndView("leads/createLead");
        mv.addObject("LEAD_OBJ", new LeadDTO());
        mv.addObject("ACTIVE_USERS_MAP", getActiveUsersMap());
        mv.addObject("LEAD_STATUSES", LEAD_STATUSES);
        mv.addObject("LEAD_SOURCES", LEAD_SOURCES);
        mv.addObject("PRIORITIES", PRIORITIES);
        return mv;
    }

    // ─── CREATE LEAD ─────────────────────────────────────────────────────────
    @PostMapping("create_lead")
    public String createLead(@ModelAttribute("LEAD_OBJ") LeadDTO dto,
                             RedirectAttributes ra) {
        User loggedIn = getLoggedInUser();
        Lead lead = new Lead();
        populateLeadFromDTO(lead, dto, loggedIn);

        if (dto.getClientId() != null && dto.getClientId() > 0) {
            ClientEntity client = clientService.findById(dto.getClientId());
            lead.setClient(client);
            if (lead.getLeadName() == null || lead.getLeadName().trim().isEmpty()) {
                lead.setLeadName(client.getClientName());
            }
        }

        leadService.saveLead(lead);
        ra.addFlashAttribute("success", "Lead created successfully!");
        return "redirect:view_filter_leads";
    }

    // ─── FILTER / LIST LEADS ─────────────────────────────────────────────────
    @GetMapping("view_filter_leads")
    public ModelAndView viewFilterLeads(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String leadStatus,
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

        mv.addObject("LEADS_LIST", dtoList);
        mv.addObject("currentPage", page);
        mv.addObject("totalPages", pagedLeads.getTotalPages());
        mv.addObject("totalLeads", pagedLeads.getTotalElements());
        mv.addObject("pageSize", pageSize);
        mv.addObject("ACTIVE_USERS_MAP", getActiveUsersMap());
        mv.addObject("LEAD_STATUSES", LEAD_STATUSES);
        mv.addObject("LEAD_SOURCES", LEAD_SOURCES);
        mv.addObject("PRIORITIES", PRIORITIES);
        mv.addObject("f_leadStatus", leadStatus);
        mv.addObject("f_leadSource", leadSource);
        mv.addObject("f_clientName", clientName);
        mv.addObject("f_assignedTo", assignedTo);
        mv.addObject("f_priority", priority);
        return mv;
    }

    // ─── VIEW LEAD DETAILS ───────────────────────────────────────────────────
    @GetMapping("view_lead_details")
    public ModelAndView viewLeadDetails(@RequestParam Long leadId) {
        ModelAndView mv = new ModelAndView("leads/viewLeadDetails");
        Lead lead = leadService.findById(leadId);
        mv.addObject("LEAD_OBJ", buildLeadDTO(lead));
        return mv;
    }

    // ─── EDIT LEAD FORM ──────────────────────────────────────────────────────
    @GetMapping("view_edit_lead_form")
    public ModelAndView viewEditLeadForm(@RequestParam Long leadId) {
        ModelAndView mv = new ModelAndView("leads/editLead");
        Lead lead = leadService.findById(leadId);
        mv.addObject("LEAD_OBJ", buildLeadDTO(lead));
        mv.addObject("ACTIVE_USERS_MAP", getActiveUsersMap());
        mv.addObject("LEAD_STATUSES", LEAD_STATUSES);
        mv.addObject("LEAD_SOURCES", LEAD_SOURCES);
        mv.addObject("PRIORITIES", PRIORITIES);
        return mv;
    }

    // ─── UPDATE LEAD ─────────────────────────────────────────────────────────
    @PostMapping("edit_lead")
    public String editLead(@ModelAttribute("LEAD_OBJ") LeadDTO dto,
                           RedirectAttributes ra) {
        User loggedIn = getLoggedInUser();
        Lead lead = leadService.findById(dto.getLeadId());
        populateLeadFromDTO(lead, dto, loggedIn);

        if (dto.getClientId() != null && dto.getClientId() > 0) {
            ClientEntity client = clientService.findById(dto.getClientId());
            lead.setClient(client);
        }

        leadService.saveLead(lead);
        ra.addFlashAttribute("success", "Lead updated successfully!");
        return "redirect:view_filter_leads";
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
    @PostMapping("create_lead_followup")
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

    // ─── JSON: client typeahead ───────────────────────────────────────────────
    @GetMapping("/getClientList")
    @ResponseBody
    public List<Map<String, Object>> getClientList(@RequestParam String clientName) {
        List<Map<String, Object>> result = new ArrayList<>();
        for (ClientEntity c : clientService.searchByName(clientName)) {
            Map<String, Object> m = new HashMap<>();
            m.put("clientId", c.getClientId());
            m.put("clientName", c.getClientName());
            m.put("mobile", c.getMobile());
            m.put("city", c.getCity());
            result.add(m);
        }
        return result;
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────
    private void populateLeadFromDTO(Lead lead, LeadDTO dto, User loggedIn) {
        lead.setLeadName(dto.getLeadName());
        lead.setEmail(dto.getEmail());
        lead.setMobileNumber(dto.getMobileNumber());
        lead.setCity(dto.getCity());
        lead.setCountry(dto.getCountry());
        lead.setLeadStatus(dto.getLeadStatus() != null ? dto.getLeadStatus() : "NEW");
        lead.setLeadSource(dto.getLeadSource());
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
