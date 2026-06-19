package com.ihwthms.controller;

import com.ihwthms.entity.City;
import com.ihwthms.entity.User;
import com.ihwthms.repository.UserRepository;
import com.ihwthms.service.CityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class CityController {

    @Autowired
    private CityService cityService;

    @Autowired
    private UserRepository userRepository;

    private User getLoggedInUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username).orElse(null);
    }

    // ─── SHOW ADD CITY FORM ──────────────────────────────────────────────────
    @GetMapping("/city/add")
    public ModelAndView showAddCityForm() {
        User user = getLoggedInUser();
        if (user == null || !user.hasRole("SUPERADMIN")) {
            return new ModelAndView("redirect:/dashboard");
        }
        ModelAndView mv = new ModelAndView("admin/city/Admin_Add_City");
        mv.addObject("CITY_OBJ", new City());
        mv.addObject("ALL_CITIES", cityService.getAllCities());
        return mv;
    }

    // ─── SAVE CITY ───────────────────────────────────────────────────────────
    @PostMapping("/city/save")
    public String saveCity(@RequestParam String name,
                           RedirectAttributes ra) {
        User user = getLoggedInUser();
        if (user == null || !user.hasRole("SUPERADMIN")) {
            return "redirect:/dashboard";
        }
        String trimmed = name != null ? name.trim() : "";
        if (trimmed.isEmpty()) {
            ra.addFlashAttribute("error", "City name cannot be empty.");
            return "redirect:/city/add";
        }
        if (cityService.existsByName(trimmed)) {
            ra.addFlashAttribute("error", "City \"" + trimmed + "\" already exists.");
            return "redirect:/city/add";
        }
        City city = new City(trimmed);
        cityService.saveCity(city);
        ra.addFlashAttribute("success", "City \"" + trimmed + "\" added successfully!");
        return "redirect:/city/add";
    }

    // ─── JSON LIST FOR DROPDOWN ───────────────────────────────────────────────
    @GetMapping("/city/list")
    @ResponseBody
    public List<Map<String, Object>> listCities() {
        return cityService.getAllCities().stream()
                .map(c -> {
                    Map<String, Object> m = new java.util.HashMap<>();
                    m.put("id", c.getId());
                    m.put("name", c.getName());
                    return m;
                })
                .collect(Collectors.toList());
    }
}
