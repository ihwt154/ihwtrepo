package com.ihwthms.controller;

import com.ihwthms.entity.User;
import com.ihwthms.repository.UserRepository;
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
            Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }
        if (user.getId() == null) {
            user.setCreatedAt(LocalDateTime.now());
            user.setActive(true);
        } else {
            Optional<User> existing = userRepository.findById(user.getId());
            if (existing.isPresent()) {
                user.setCreatedAt(existing.get().getCreatedAt());
                user.setActive(existing.get().isActive());
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
}
