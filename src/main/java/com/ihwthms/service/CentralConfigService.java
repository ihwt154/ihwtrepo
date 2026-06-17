package com.ihwthms.service;

import com.ihwthms.entity.CentralConfigEntity;
import com.ihwthms.model.CentralConfigEntityDTO;
import com.ihwthms.repository.CentralConfigEntityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class CentralConfigService {

    @Autowired
    private CentralConfigEntityRepository centralConfigRepository;

    // ===== FETCH =====
    public CentralConfigEntityDTO getCentralConfig() {
        return Optional.ofNullable(centralConfigRepository.findTopByOrderByIdAsc())
                .map(this::convertEntityToDTO)
                .orElse(new CentralConfigEntityDTO());
    }

    public CentralConfigEntity getRawCentralConfig() {
        return centralConfigRepository.findTopByOrderByIdAsc();
    }

    // ===== SAVE / UPDATE =====
    public void saveOrUpdateCentralConfig(CentralConfigEntityDTO dto) {
        CentralConfigEntity entity = Optional.ofNullable(centralConfigRepository.findTopByOrderByIdAsc())
                .orElse(new CentralConfigEntity());

        entity.setCompanyName(dto.getCompanyName());
        entity.setCompanyAddress(dto.getCompanyAddress());
        entity.setCentralNumber(dto.getCentralNumber());
        entity.setCentralizedEmail(dto.getCentralizedEmail());
        entity.setGstNumber(dto.getGstNumber());
        entity.setWebsite(dto.getWebsite());
        entity.setBaseUrl(dto.getBaseUrl());
        entity.setEscalationEmail(dto.getEscalationEmail());
        entity.setEscalationPhone(dto.getEscalationPhone());

        entity.setAccountName(dto.getAccountName());
        entity.setBankName(dto.getBankName());
        entity.setAccountNumber(dto.getAccountNumber());
        entity.setIfscCode(dto.getIfscCode());
        entity.setBranch(dto.getBranch());

        entity.setGlobalWatcherEmails(dto.getGlobalWatcherEmails());
        entity.setGlobalWatcherEnabled(dto.isGlobalWatcherEnabled());

        entity.setFacebookLink(dto.getFacebookLink());
        entity.setInstagramLink(dto.getInstagramLink());
        entity.setLinkedinLink(dto.getLinkedinLink());
        entity.setYoutubeLink(dto.getYoutubeLink());
        entity.setxLink(dto.getxLink());

        if (dto.getLogoFile() != null && !dto.getLogoFile().isEmpty()) {
            try {
                entity.setLogoData(dto.getLogoFile().getBytes());
                entity.setLogoContentType(dto.getLogoFile().getContentType());
                entity.setLogoPath("/logo.png");
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (dto.getLogoPath() != null && !dto.getLogoPath().isEmpty()) {
            entity.setLogoPath(dto.getLogoPath());
        }

        entity.setQuotationTopCover(dto.getQuotationTopCover());
        entity.setInclusions(dto.getInclusions());
        entity.setTnc(dto.getTnc());
        entity.setUsp(dto.getUsp());
        entity.setCompanyInfo(dto.getCompanyInfo());

        entity.setWhatsAppApiUrl(dto.getWhatsAppApiUrl());
        entity.setWhatsAppApiKey(dto.getWhatsAppApiKey());
        entity.setWhatsAppRegistrationTemplateId(dto.getWhatsAppRegistrationTemplateId());
        entity.setWhatsAppStayQuotationTemplateId(dto.getWhatsAppStayQuotationTemplateId());
        entity.setWhatsAppGuestQuotationTemplateId(dto.getWhatsAppGuestQuotationTemplateId());

        entity.setEmailSmtpHost(dto.getEmailSmtpHost());
        entity.setEmailSmtpPort(dto.getEmailSmtpPort());
        entity.setEmailSmtpUsername(dto.getEmailSmtpUsername());
        entity.setEmailSmtpPassword(dto.getEmailSmtpPassword());
        entity.setEmailFromAddress(dto.getEmailFromAddress());
        entity.setEmailReplyTo(dto.getEmailReplyTo());
        entity.setEmailDefaultCc(dto.getEmailDefaultCc());
        entity.setEmailNotifyTo(dto.getEmailNotifyTo());
        entity.setEmailClientActive(dto.getEmailClientActive());
        entity.setEmailInternalActive(dto.getEmailInternalActive());

        centralConfigRepository.save(entity);
    }

    // ===== ENTITY → DTO =====
    private CentralConfigEntityDTO convertEntityToDTO(CentralConfigEntity entity) {
        CentralConfigEntityDTO dto = new CentralConfigEntityDTO();
        dto.setCompanyName(entity.getCompanyName());
        dto.setCompanyAddress(entity.getCompanyAddress());
        dto.setCentralNumber(entity.getCentralNumber());
        dto.setCentralizedEmail(entity.getCentralizedEmail());
        dto.setGstNumber(entity.getGstNumber());
        dto.setWebsite(entity.getWebsite());
        dto.setBaseUrl(entity.getBaseUrl());
        dto.setEscalationEmail(entity.getEscalationEmail());
        dto.setEscalationPhone(entity.getEscalationPhone());

        dto.setAccountName(entity.getAccountName());
        dto.setBankName(entity.getBankName());
        dto.setAccountNumber(entity.getAccountNumber());
        dto.setIfscCode(entity.getIfscCode());
        dto.setBranch(entity.getBranch());

        dto.setGlobalWatcherEmails(entity.getGlobalWatcherEmails());
        dto.setGlobalWatcherEnabled(entity.isGlobalWatcherEnabled());

        dto.setFacebookLink(entity.getFacebookLink());
        dto.setInstagramLink(entity.getInstagramLink());
        dto.setLinkedinLink(entity.getLinkedinLink());
        dto.setYoutubeLink(entity.getYoutubeLink());
        dto.setxLink(entity.getxLink());

        dto.setLogoPath(entity.getLogoPath());

        dto.setQuotationTopCover(entity.getQuotationTopCover());
        dto.setInclusions(entity.getInclusions());
        dto.setTnc(entity.getTnc());
        dto.setUsp(entity.getUsp());
        dto.setCompanyInfo(entity.getCompanyInfo());

        dto.setWhatsAppApiUrl(entity.getWhatsAppApiUrl());
        dto.setWhatsAppApiKey(entity.getWhatsAppApiKey());
        dto.setWhatsAppRegistrationTemplateId(entity.getWhatsAppRegistrationTemplateId());
        dto.setWhatsAppStayQuotationTemplateId(entity.getWhatsAppStayQuotationTemplateId());
        dto.setWhatsAppGuestQuotationTemplateId(entity.getWhatsAppGuestQuotationTemplateId());

        dto.setEmailSmtpHost(entity.getEmailSmtpHost());
        dto.setEmailSmtpPort(entity.getEmailSmtpPort());
        dto.setEmailSmtpUsername(entity.getEmailSmtpUsername());
        dto.setEmailSmtpPassword(entity.getEmailSmtpPassword());
        dto.setEmailFromAddress(entity.getEmailFromAddress());
        dto.setEmailReplyTo(entity.getEmailReplyTo());
        dto.setEmailDefaultCc(entity.getEmailDefaultCc());
        dto.setEmailNotifyTo(entity.getEmailNotifyTo());
        dto.setEmailClientActive(entity.getEmailClientActive());
        dto.setEmailInternalActive(entity.getEmailInternalActive());

        return dto;
    }
}
