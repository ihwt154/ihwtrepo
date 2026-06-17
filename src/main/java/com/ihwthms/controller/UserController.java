package com.ihwthms.controller;

import com.ihwthms.entity.User;
import com.ihwthms.entity.Role;
import com.ihwthms.repository.UserRepository;
import com.ihwthms.repository.RoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @GetMapping
    public String listUsers(Principal principal, Model model) {
        if (principal == null) {
            return "redirect:/login";
        }
        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "admin/users";
    }

    @PostMapping("/save")
    public String saveUser(
            @ModelAttribute User user,
            @RequestParam("fullName") String fullName,
            @RequestParam(value = "userType", required = false) String userType,
            Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }

        // Split Full Name into First Name and Last Name
        if (fullName != null && !fullName.trim().isEmpty()) {
            String[] parts = fullName.trim().split("\\s+", 2);
            user.setFirstName(parts[0]);
            if (parts.length > 1) {
                user.setLastName(parts[1]);
            } else {
                user.setLastName("");
            }
        } else {
            user.setFirstName("");
            user.setLastName("");
        }

        // Synchronize personalEmail with email (login email)
        user.setPersonalEmail(user.getEmail());

        if (user.getId() == null) {
            user.setCreatedAt(LocalDateTime.now());
            assignRoleByType(user, userType);
        } else {
            Optional<User> existing = userRepository.findById(user.getId());
            if (existing.isPresent()) {
                User ext = existing.get();
                user.setCreatedAt(ext.getCreatedAt());
                // Keep password if left blank in UI edit
                if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                    user.setPassword(ext.getPassword());
                }
                // Do not allow changing the SUPERADMIN role
                if (ext.hasRole("SUPERADMIN")) {
                    user.setRoles(ext.getRoles());
                } else {
                    assignRoleByType(user, userType);
                }
            } else {
                assignRoleByType(user, userType);
            }
        }
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
        return "redirect:/admin/users";
    }

    @PostMapping("/toggle")
    public String toggleUserStatus(
            @RequestParam Long id,
            Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Prevent self-deactivation
            if (!user.getUsername().equals(principal.getName())) {
                user.setActive(!user.isActive());
                user.setUpdatedAt(LocalDateTime.now());
                userRepository.save(user);
            }
        }
        return "redirect:/admin/users";
    }

    private void assignRoleByType(User user, String userType) {
        java.util.Set<Role> roles = new java.util.HashSet<>();
        if ("ADMIN".equalsIgnoreCase(userType)) {
            roleRepository.findByRoleName("ADMIN").ifPresent(roles::add);
        } else {
            roleRepository.findByRoleName("USER").ifPresent(roles::add);
        }
        user.setRoles(roles);
    }
}
