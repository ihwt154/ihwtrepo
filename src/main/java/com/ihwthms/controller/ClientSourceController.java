package com.ihwthms.controller;

import com.ihwthms.entity.ClientSourceEntity;
import com.ihwthms.service.ClientSourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/client")
public class ClientSourceController {

    @Autowired
    private ClientSourceService clientSourceService;

    @GetMapping("/sources")
    public ModelAndView viewSources() {
        ModelAndView mv = new ModelAndView("admin/client/viewClientSources");
        mv.addObject("SOURCE_LIST", clientSourceService.findAll());
        mv.addObject("SOURCE_OBJ", new ClientSourceEntity());
        return mv;
    }

    @PostMapping("/sources/save")
    public String saveSource(@RequestParam(required = false) Long id,
                             @RequestParam String sourceName,
                             RedirectAttributes ra) {
        ClientSourceEntity entity;
        if (id != null && id > 0) {
            entity = clientSourceService.findById(id);
        } else {
            entity = new ClientSourceEntity();
        }
        entity.setSourceName(sourceName);
        clientSourceService.save(entity);
        ra.addFlashAttribute("success", id != null && id > 0 ? "Client source updated." : "Client source added.");
        return "redirect:/admin/client/sources";
    }

    @PostMapping("/sources/toggle")
    public String toggleSource(@RequestParam Long id, RedirectAttributes ra) {
        clientSourceService.toggleActive(id);
        ra.addFlashAttribute("success", "Status updated.");
        return "redirect:/admin/client/sources";
    }
}
