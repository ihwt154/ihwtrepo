package com.ihwthms.controller;

import com.ihwthms.repository.ClientRepository;
import com.ihwthms.repository.LeadRepository;
import com.ihwthms.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;

@Controller
public class LoginController {

    @Autowired
    private LeadRepository leadRepository;

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping({"/", "/login"})
    public String showLogin(
            @RequestParam(value = "error", required = false) String error,
            Principal principal,
            Model model) {
        if (principal != null) {
            return "redirect:/dashboard";
        }
        if (error != null) {
            model.addAttribute("error", "Invalid username or password.");
        }
        return "login";
    }

    @GetMapping("/dashboard")
    public String showDashboard(Principal principal, Model model) {
        if (principal == null) {
            return "redirect:/login";
        }

        // Determine if the logged-in user is an admin/superadmin
        com.ihwthms.entity.User loggedInUser = userRepository.findByUsername(principal.getName()).orElse(null);
        boolean isAdmin = loggedInUser != null &&
                (loggedInUser.hasRole("ADMIN") || loggedInUser.hasRole("SUPERADMIN"));

        long totalLeads, openLeads, wipLeads, wonLeads, failedLeads;

        if (isAdmin || loggedInUser == null) {
            // Admin sees ALL leads
            totalLeads   = leadRepository.count();
            openLeads    = leadRepository.countByLeadStatus("Open");
            wipLeads     = leadRepository.countByLeadStatus("Work In Progress");
            wonLeads     = leadRepository.countByLeadStatus("Won-Converted");
            failedLeads  = leadRepository.countByLeadStatus("Failed-Closed");
        } else {
            // Regular user sees ONLY their own assigned leads
            Long userId = loggedInUser.getId();
            totalLeads   = leadRepository.countByAssignedTo(userId);
            openLeads    = leadRepository.countByLeadStatusAndAssignedTo("Open", userId);
            wipLeads     = leadRepository.countByLeadStatusAndAssignedTo("Work In Progress", userId);
            wonLeads     = leadRepository.countByLeadStatusAndAssignedTo("Won-Converted", userId);
            failedLeads  = leadRepository.countByLeadStatusAndAssignedTo("Failed-Closed", userId);
        }

        long totalClients = clientRepository.count();
        long totalUsers   = userRepository.count();

        long sumForDonut = openLeads + wipLeads + wonLeads + failedLeads;
        long openPercent   = sumForDonut > 0 ? Math.round((double) openLeads   / sumForDonut * 100) : 0;
        long wipPercent    = sumForDonut > 0 ? Math.round((double) wipLeads    / sumForDonut * 100) : 0;
        long wonPercent    = sumForDonut > 0 ? Math.round((double) wonLeads    / sumForDonut * 100) : 0;
        long failedPercent = sumForDonut > 0 ? Math.round((double) failedLeads / sumForDonut * 100) : 0;

        model.addAttribute("totalLeads",    totalLeads);
        model.addAttribute("totalClients",  totalClients);
        model.addAttribute("totalUsers",    totalUsers);
        model.addAttribute("isAdmin",       isAdmin);

        model.addAttribute("openLeads",    openLeads);
        model.addAttribute("wipLeads",     wipLeads);
        model.addAttribute("wonLeads",     wonLeads);
        model.addAttribute("failedLeads",  failedLeads);

        model.addAttribute("openPercent",   openPercent);
        model.addAttribute("wipPercent",    wipPercent);
        model.addAttribute("wonPercent",    wonPercent);
        model.addAttribute("failedPercent", failedPercent);

        // Legacy aliases used by old dashboard template
        model.addAttribute("qualifiedLeads", wonLeads);
        model.addAttribute("flaggedLeads",   wipLeads);
        model.addAttribute("newLeads",       openLeads);
        model.addAttribute("contactedLeads", wipLeads);
        model.addAttribute("lostLeads",      failedLeads);
        model.addAttribute("newPercent",     openPercent);
        model.addAttribute("contactedPercent", wipPercent);
        model.addAttribute("lostPercent",    failedPercent);

        return "dashboard";
    }
}
