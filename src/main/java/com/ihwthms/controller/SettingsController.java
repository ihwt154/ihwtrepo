package com.ihwthms.controller;

import com.ihwthms.model.CentralConfigEntityDTO;
import com.ihwthms.service.CentralConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class SettingsController {

    @Autowired
    private CentralConfigService centralConfigService;

    // ===== VIEW =====
    @GetMapping("view_form_manage_central_config")
    public ModelAndView viewCentralConfig() {
        ModelAndView mav = new ModelAndView("admin/settings/view_centralConfig");
        CentralConfigEntityDTO dto = centralConfigService.getCentralConfig();
        mav.addObject("CENTRAL_CONFIG_OBJ", dto);
        return mav;
    }

    // ===== SAVE =====
    @PostMapping("create_edit_central_config")
    public String saveCentralConfig(
            @ModelAttribute("CENTRAL_CONFIG_OBJ") CentralConfigEntityDTO dto,
            @RequestParam(value = "logoFile", required = false) MultipartFile logoFile,
            HttpServletRequest request,
            final RedirectAttributes redirectAttrib) {

        try {
            if (logoFile != null && !logoFile.isEmpty()) {
                String uploadDir = request.getServletContext().getRealPath("/resources/images/");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();
                Path filePath = Paths.get(uploadDir, "logo.png");
                logoFile.transferTo(filePath.toFile());
                dto.setLogoPath("/resources/images/logo.png");
            }
            centralConfigService.saveOrUpdateCentralConfig(dto);
            redirectAttrib.addFlashAttribute("success", "Configuration saved successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrib.addFlashAttribute("error", "Failed to save configuration. Please try again.");
        }
        return "redirect:view_form_manage_central_config";
    }
}
