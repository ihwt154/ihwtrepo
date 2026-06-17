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
        
        // Fetch dynamic counts from the database using real status values
        long totalLeads = leadRepository.count();
        long totalClients = clientRepository.count();
        long totalUsers = userRepository.count();

        // Real status strings from WorkloadStatusService fallback
        long openLeads       = leadRepository.countByLeadStatus("Open");
        long wipLeads        = leadRepository.countByLeadStatus("Work In Progress");
        long wonLeads        = leadRepository.countByLeadStatus("Won-Converted");
        long failedLeads     = leadRepository.countByLeadStatus("Failed-Closed");

        long sumForDonut = openLeads + wipLeads + wonLeads + failedLeads;
        long openPercent   = sumForDonut > 0 ? Math.round((double) openLeads   / sumForDonut * 100) : 0;
        long wipPercent    = sumForDonut > 0 ? Math.round((double) wipLeads    / sumForDonut * 100) : 0;
        long wonPercent    = sumForDonut > 0 ? Math.round((double) wonLeads    / sumForDonut * 100) : 0;
        long failedPercent = sumForDonut > 0 ? Math.round((double) failedLeads / sumForDonut * 100) : 0;

        model.addAttribute("totalLeads",    totalLeads);
        model.addAttribute("totalClients",  totalClients);
        model.addAttribute("totalUsers",    totalUsers);

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
