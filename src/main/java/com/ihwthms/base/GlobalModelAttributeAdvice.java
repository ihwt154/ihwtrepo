package com.ihwthms.base;

import com.ihwthms.model.CentralConfigEntityDTO;
import com.ihwthms.service.CentralConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAttributeAdvice {

    @Autowired
    private CentralConfigService centralConfigService;

    @ModelAttribute("centralConfig")
    public CentralConfigEntityDTO globalCentralConfig() {
        return centralConfigService.getCentralConfig();
    }
}
