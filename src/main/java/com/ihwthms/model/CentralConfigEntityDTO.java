package com.ihwthms.model;

import org.springframework.web.multipart.MultipartFile;

public class CentralConfigEntityDTO {

    // Organisation info
    private String companyName;
    private String companyAddress;
    private String centralNumber;
    private String centralizedEmail;
    private String gstNumber;
    private String website;
    private String baseUrl;
    private String escalationEmail;
    private String escalationPhone;

    // Bank Details
    private String accountName;
    private String bankName;
    private String accountNumber;
    private String ifscCode;
    private String branch;

    // Watcher Settings
    private String globalWatcherEmails;
    private boolean globalWatcherEnabled;

    // Social Media Links
    private String facebookLink;
    private String instagramLink;
    private String linkedinLink;
    private String youtubeLink;
    private String xLink;

    // Logo
    private MultipartFile logoFile;
    private String logoPath;

    // Quotation Config
    private String quotationTopCover;
    private String inclusions;
    private String tnc;
    private String usp;
    private String companyInfo;

    // WhatsApp Settings
    private String whatsAppApiUrl;
    private String whatsAppApiKey;
    private String whatsAppRegistrationTemplateId;


    // Email / SMTP Settings
    private String emailSmtpHost;
    private String emailSmtpPort;
    private String emailSmtpUsername;
    private String emailSmtpPassword;
    private String emailFromAddress;
    private String emailReplyTo;
    private String emailDefaultCc;
    private String emailNotifyTo;
    private String emailClientActive;
    private String emailInternalActive;

    // ===== Getters & Setters =====

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getCompanyAddress() { return companyAddress; }
    public void setCompanyAddress(String companyAddress) { this.companyAddress = companyAddress; }

    public String getCentralNumber() { return centralNumber; }
    public void setCentralNumber(String centralNumber) { this.centralNumber = centralNumber; }

    public String getCentralizedEmail() { return centralizedEmail; }
    public void setCentralizedEmail(String centralizedEmail) { this.centralizedEmail = centralizedEmail; }

    public String getGstNumber() { return gstNumber; }
    public void setGstNumber(String gstNumber) { this.gstNumber = gstNumber; }

    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }

    public String getBaseUrl() { return baseUrl; }
    public void setBaseUrl(String baseUrl) { this.baseUrl = baseUrl; }

    public String getEscalationEmail() { return escalationEmail; }
    public void setEscalationEmail(String escalationEmail) { this.escalationEmail = escalationEmail; }

    public String getEscalationPhone() { return escalationPhone; }
    public void setEscalationPhone(String escalationPhone) { this.escalationPhone = escalationPhone; }

    public String getAccountName() { return accountName; }
    public void setAccountName(String accountName) { this.accountName = accountName; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public String getIfscCode() { return ifscCode; }
    public void setIfscCode(String ifscCode) { this.ifscCode = ifscCode; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public String getGlobalWatcherEmails() { return globalWatcherEmails; }
    public void setGlobalWatcherEmails(String globalWatcherEmails) { this.globalWatcherEmails = globalWatcherEmails; }

    public boolean isGlobalWatcherEnabled() { return globalWatcherEnabled; }
    public void setGlobalWatcherEnabled(boolean globalWatcherEnabled) { this.globalWatcherEnabled = globalWatcherEnabled; }

    public String getFacebookLink() { return facebookLink; }
    public void setFacebookLink(String facebookLink) { this.facebookLink = facebookLink; }

    public String getInstagramLink() { return instagramLink; }
    public void setInstagramLink(String instagramLink) { this.instagramLink = instagramLink; }

    public String getLinkedinLink() { return linkedinLink; }
    public void setLinkedinLink(String linkedinLink) { this.linkedinLink = linkedinLink; }

    public String getYoutubeLink() { return youtubeLink; }
    public void setYoutubeLink(String youtubeLink) { this.youtubeLink = youtubeLink; }

    public String getxLink() { return xLink; }
    public void setxLink(String xLink) { this.xLink = xLink; }

    public MultipartFile getLogoFile() { return logoFile; }
    public void setLogoFile(MultipartFile logoFile) { this.logoFile = logoFile; }

    public String getLogoPath() { return logoPath; }
    public void setLogoPath(String logoPath) { this.logoPath = logoPath; }

    public String getQuotationTopCover() { return quotationTopCover; }
    public void setQuotationTopCover(String quotationTopCover) { this.quotationTopCover = quotationTopCover; }

    public String getInclusions() { return inclusions; }
    public void setInclusions(String inclusions) { this.inclusions = inclusions; }

    public String getTnc() { return tnc; }
    public void setTnc(String tnc) { this.tnc = tnc; }

    public String getUsp() { return usp; }
    public void setUsp(String usp) { this.usp = usp; }

    public String getCompanyInfo() { return companyInfo; }
    public void setCompanyInfo(String companyInfo) { this.companyInfo = companyInfo; }

    public String getWhatsAppApiUrl() { return whatsAppApiUrl; }
    public void setWhatsAppApiUrl(String whatsAppApiUrl) { this.whatsAppApiUrl = whatsAppApiUrl; }

    public String getWhatsAppApiKey() { return whatsAppApiKey; }
    public void setWhatsAppApiKey(String whatsAppApiKey) { this.whatsAppApiKey = whatsAppApiKey; }

    public String getWhatsAppRegistrationTemplateId() { return whatsAppRegistrationTemplateId; }
    public void setWhatsAppRegistrationTemplateId(String id) { this.whatsAppRegistrationTemplateId = id; }



    public String getEmailSmtpHost() { return emailSmtpHost; }
    public void setEmailSmtpHost(String emailSmtpHost) { this.emailSmtpHost = emailSmtpHost; }

    public String getEmailSmtpPort() { return emailSmtpPort; }
    public void setEmailSmtpPort(String emailSmtpPort) { this.emailSmtpPort = emailSmtpPort; }

    public String getEmailSmtpUsername() { return emailSmtpUsername; }
    public void setEmailSmtpUsername(String emailSmtpUsername) { this.emailSmtpUsername = emailSmtpUsername; }

    public String getEmailSmtpPassword() { return emailSmtpPassword; }
    public void setEmailSmtpPassword(String emailSmtpPassword) { this.emailSmtpPassword = emailSmtpPassword; }

    public String getEmailFromAddress() { return emailFromAddress; }
    public void setEmailFromAddress(String emailFromAddress) { this.emailFromAddress = emailFromAddress; }

    public String getEmailReplyTo() { return emailReplyTo; }
    public void setEmailReplyTo(String emailReplyTo) { this.emailReplyTo = emailReplyTo; }

    public String getEmailDefaultCc() { return emailDefaultCc; }
    public void setEmailDefaultCc(String emailDefaultCc) { this.emailDefaultCc = emailDefaultCc; }

    public String getEmailNotifyTo() { return emailNotifyTo; }
    public void setEmailNotifyTo(String emailNotifyTo) { this.emailNotifyTo = emailNotifyTo; }

    public String getEmailClientActive() { return emailClientActive; }
    public void setEmailClientActive(String emailClientActive) { this.emailClientActive = emailClientActive; }

    public String getEmailInternalActive() { return emailInternalActive; }
    public void setEmailInternalActive(String emailInternalActive) { this.emailInternalActive = emailInternalActive; }
}
