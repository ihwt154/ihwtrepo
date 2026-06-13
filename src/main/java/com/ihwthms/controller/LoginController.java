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
        
        // Fetch dynamic counts from the database
        long totalLeads = leadRepository.count();
        long qualifiedLeads = leadRepository.countByLeadStatus("QUALIFIED");
        long flaggedLeads = leadRepository.countByLeadStatus("CONTACTED");
        long totalClients = clientRepository.count();
        long totalUsers = userRepository.count();
        
        long newLeads = leadRepository.countByLeadStatus("NEW"); // Open
        long contactedLeads = leadRepository.countByLeadStatus("CONTACTED"); // WIP
        long lostLeads = leadRepository.countByLeadStatus("LOST"); // Failed-Closed
        
        // Calculate SVG chart coordinates dynamically
        long sumForDonut = newLeads + contactedLeads + lostLeads;
        double newPercent = sumForDonut > 0 ? (double) newLeads / sumForDonut * 100 : 0;
        double contactedPercent = sumForDonut > 0 ? (double) contactedLeads / sumForDonut * 100 : 0;
        double lostPercent = sumForDonut > 0 ? (double) lostLeads / sumForDonut * 100 : 0;
        
        model.addAttribute("totalLeads", totalLeads);
        model.addAttribute("qualifiedLeads", qualifiedLeads);
        model.addAttribute("flaggedLeads", flaggedLeads);
        model.addAttribute("totalClients", totalClients);
        model.addAttribute("totalUsers", totalUsers);
        
        model.addAttribute("newLeads", newLeads);
        model.addAttribute("contactedLeads", contactedLeads);
        model.addAttribute("lostLeads", lostLeads);
        
        model.addAttribute("newPercent", Math.round(newPercent));
        model.addAttribute("contactedPercent", Math.round(contactedPercent));
        model.addAttribute("lostPercent", Math.round(lostPercent));
        
        return "dashboard";
    }
}
