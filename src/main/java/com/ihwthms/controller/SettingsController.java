package com.ihwthms.controller;

import com.ihwthms.entity.User;
import com.ihwthms.entity.Role;
import com.ihwthms.model.CentralConfigEntityDTO;
import com.ihwthms.repository.UserRepository;
import com.ihwthms.repository.RoleRepository;
import com.ihwthms.service.CentralConfigService;
import java.util.Set;
import java.util.HashSet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Controller
public class SettingsController {

    @Autowired
    private CentralConfigService centralConfigService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    // ===== CENTRAL CONFIG: VIEW =====
    @GetMapping("view_form_manage_central_config")
    public ModelAndView viewCentralConfig() {
        ModelAndView mav = new ModelAndView("admin/settings/view_centralConfig");
        CentralConfigEntityDTO dto = centralConfigService.getCentralConfig();
        mav.addObject("CENTRAL_CONFIG_OBJ", dto);
        return mav;
    }

    // ===== CENTRAL CONFIG: SAVE =====
    @PostMapping("create_edit_central_config")
    public String saveCentralConfig(
            @ModelAttribute("CENTRAL_CONFIG_OBJ") CentralConfigEntityDTO dto,
            @RequestParam(value = "logoFile", required = false) MultipartFile logoFile,
            HttpServletRequest request,
            final RedirectAttributes redirectAttrib) {

        try {
            if (logoFile != null && !logoFile.isEmpty()) {
                dto.setLogoFile(logoFile);
                dto.setLogoPath("/logo.png");
            }
            centralConfigService.saveOrUpdateCentralConfig(dto);
            redirectAttrib.addFlashAttribute("success", "Configuration saved successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrib.addFlashAttribute("error", "Failed to save configuration. Please try again.");
        }
        return "redirect:/settings/profile?tab=config";
    }

    // ===== SERVE LOGO FROM DATABASE =====
    @GetMapping("/logo.png")
    @ResponseBody
    public org.springframework.http.ResponseEntity<byte[]> showLogo() {
        com.ihwthms.entity.CentralConfigEntity entity = centralConfigService.getRawCentralConfig();
        if (entity != null && entity.getLogoData() != null) {
            org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
            String contentType = entity.getLogoContentType();
            if (contentType == null || contentType.isEmpty()) {
                contentType = "image/png";
            }
            headers.setContentType(org.springframework.http.MediaType.parseMediaType(contentType));
            headers.setCacheControl("no-cache, no-store, must-revalidate");
            headers.setPragma("no-cache");
            headers.setExpires(0);
            return new org.springframework.http.ResponseEntity<>(entity.getLogoData(), headers, org.springframework.http.HttpStatus.OK);
        }
        return new org.springframework.http.ResponseEntity<>(org.springframework.http.HttpStatus.NOT_FOUND);
    }

    // ===== SETTINGS HUB: My Profile / Change Password / Permissions =====
    @GetMapping({"/settings", "/settings/profile"})
    public ModelAndView viewSettingsProfile(Principal principal, RedirectAttributes ra) {
        if (principal == null) return new ModelAndView("redirect:/login");
        User currentUser = userRepository.findByUsername(principal.getName()).orElse(null);
        if (currentUser == null) { ra.addFlashAttribute("error", "User not found."); return new ModelAndView("redirect:/dashboard"); }

        List<User> allUsers = userRepository.findAll();
        CentralConfigEntityDTO centralConfig = centralConfigService.getCentralConfig();
        ModelAndView mav = new ModelAndView("admin/settings/profile");
        mav.addObject("CURRENT_USER", currentUser);
        mav.addObject("ALL_USERS", allUsers);
        mav.addObject("CENTRAL_CONFIG_OBJ", centralConfig);
        return mav;
    }

    // ===== CHANGE PASSWORD =====
    @PostMapping("/settings/change-password")
    public String changePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            Principal principal,
            RedirectAttributes ra) {
        if (principal == null) return "redirect:/login";

        User user = userRepository.findByUsername(principal.getName()).orElse(null);
        if (user == null) { ra.addFlashAttribute("pwdError", "User not found."); return "redirect:/settings/profile"; }

        if (!user.getPassword().equals(currentPassword)) {
            ra.addFlashAttribute("pwdError", "Current password is incorrect.");
            return "redirect:/settings/profile";
        }
        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("pwdError", "New passwords do not match.");
            return "redirect:/settings/profile";
        }
        if (newPassword.trim().length() < 6) {
            ra.addFlashAttribute("pwdError", "New password must be at least 6 characters.");
            return "redirect:/settings/profile";
        }
        user.setPassword(newPassword);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
        ra.addFlashAttribute("pwdSuccess", "Password changed successfully!");
        return "redirect:/settings/profile";
    }

    // ===== UPDATE PROFILE =====
    @PostMapping("/settings/update-profile")
    public String updateProfile(
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String email,
            @RequestParam(required = false) String designation,
            @RequestParam(required = false) String companyEmail,
            @RequestParam(required = false) String companyMobile,
            @RequestParam(required = false) String personalEmail,
            @RequestParam(required = false) String mobile,
            @RequestParam(required = false) String dob,
            @RequestParam(required = false) String doj,
            @RequestParam(required = false) String systemUser,
            @RequestParam(required = false) String address,
            Principal principal,
            RedirectAttributes ra) {
        if (principal == null) return "redirect:/login";
        User user = userRepository.findByUsername(principal.getName()).orElse(null);
        if (user == null) { ra.addFlashAttribute("profileError", "User not found."); return "redirect:/settings/profile"; }
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setDesignation(designation);
        user.setCompanyEmail(companyEmail);
        user.setCompanyMobile(companyMobile);
        user.setPersonalEmail(personalEmail);
        user.setMobile(mobile);
        user.setSystemUser(systemUser);
        user.setAddress(address);

        if (dob != null && !dob.trim().isEmpty()) {
            try {
                user.setDob(java.time.LocalDate.parse(dob));
            } catch (Exception e) {
                // ignore
            }
        } else {
            user.setDob(null);
        }

        if (doj != null && !doj.trim().isEmpty()) {
            try {
                user.setDoj(java.time.LocalDate.parse(doj));
            } catch (Exception e) {
                // ignore
            }
        } else {
            user.setDoj(null);
        }

        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
        ra.addFlashAttribute("profileSuccess", "Profile updated successfully!");
        return "redirect:/settings/profile";
    }

    // ===== SAVE PERMISSIONS FOR A USER =====
    @PostMapping("/settings/save-permissions")
    public String savePermissions(
            @RequestParam Long userId,
            @RequestParam(value = "roles", required = false) List<String> roles,
            RedirectAttributes ra) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.hasRole("SUPERADMIN")) {
                ra.addFlashAttribute("permSuccess", "Super Admin permissions are locked and cannot be edited.");
                return "redirect:/settings/profile?tab=permissions";
            }
            java.util.Set<com.ihwthms.entity.Role> userRoles = new java.util.HashSet<>();
            if (roles != null) {
                for (String roleName : roles) {
                    String lookupName = roleName.startsWith("ROLE_") ? roleName.substring(5) : roleName;
                    roleRepository.findByRoleName(lookupName).ifPresent(userRoles::add);
                }
            }
            boolean hasAdmin = userRoles.stream().anyMatch(r -> r.getRoleName().equalsIgnoreCase("ADMIN"));
            boolean hasUser = userRoles.stream().anyMatch(r -> r.getRoleName().equalsIgnoreCase("USER"));
            if (userRoles.isEmpty() || (!hasAdmin && !hasUser)) {
                roleRepository.findByRoleName("USER").ifPresent(userRoles::add);
            }
            user.setRoles(userRoles);
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
            ra.addFlashAttribute("permSuccess", "Permissions saved for " + user.getUsername() + ".");
        }
        return "redirect:/settings/profile";
    }
}
