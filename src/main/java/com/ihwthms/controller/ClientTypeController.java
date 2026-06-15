package com.ihwthms.controller;

import com.ihwthms.entity.ClientTypeEntity;
import com.ihwthms.service.ClientTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/client")
public class ClientTypeController {

    @Autowired
    private ClientTypeService clientTypeService;

    @GetMapping("/types")
    public ModelAndView viewTypes() {
        ModelAndView mv = new ModelAndView("admin/client/viewClientTypes");
        mv.addObject("TYPE_LIST", clientTypeService.findAll());
        mv.addObject("TYPE_OBJ", new ClientTypeEntity());
        return mv;
    }

    @PostMapping("/types/save")
    public String saveType(@RequestParam(required = false) Long id,
                           @RequestParam String typeName,
                           RedirectAttributes ra) {
        ClientTypeEntity entity;
        if (id != null && id > 0) {
            entity = clientTypeService.findById(id);
        } else {
            entity = new ClientTypeEntity();
        }
        entity.setTypeName(typeName);
        clientTypeService.save(entity);
        ra.addFlashAttribute("success", id != null && id > 0 ? "Client type updated." : "Client type added.");
        return "redirect:/admin/client/types";
    }

    @PostMapping("/types/toggle")
    public String toggleType(@RequestParam Long id, RedirectAttributes ra) {
        clientTypeService.toggleActive(id);
        ra.addFlashAttribute("success", "Status updated.");
        return "redirect:/admin/client/types";
    }
}
