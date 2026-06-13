package com.ihwthms.entity;

import javax.persistence.*;

@Entity
@Table(name = "company_central_config")
public class CentralConfigEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    // Organisation info
    @Column(name = "company_name")
    private String companyName;

    @Column(name = "company_address")
    private String companyAddress;

    @Column(name = "company_central_number")
    private String centralNumber;

    @Column(name = "centralized_email")
    private String centralizedEmail;

    @Column(name = "company_gst_number")
    private String gstNumber;

    @Column(name = "website")
    private String website;

    @Column(name = "baseUrl")
    private String baseUrl;

    @Column(name = "escalationEmail")
    private String escalationEmail;

    @Column(name = "escalationPhone")
    private String escalationPhone;

    // Bank Details
    @Column(name = "accountName")
    private String accountName;

    @Column(name = "bank_name")
    private String bankName;

    @Column(name = "account_number")
    private String accountNumber;

    @Column(name = "ifsc_code")
    private String ifscCode;

    @Column(name = "branch")
    private String branch;

    // Watcher Settings
    @Column(name = "global_watcher_emails")
    private String globalWatcherEmails;

    @Column(name = "global_watcher_enabled")
    private boolean globalWatcherEnabled;

    // Social Media Links
    @Column(name = "facebook_link")
    private String facebookLink;

    @Column(name = "instagram_link")
    private String instagramLink;

    @Column(name = "linkedin_link")
    private String linkedinLink;

    @Column(name = "youtube_link")
    private String youtubeLink;

    @Column(name = "x_link")
    private String xLink;

    // Logo / Asset
    @Column(name = "logo_path")
    private String logoPath;

    // Quotation Config
    @Column(name = "quotationTopCover", columnDefinition = "TEXT")
    private String quotationTopCover;

    @Column(name = "inclusions", columnDefinition = "TEXT")
    private String inclusions;

    @Column(name = "tnc", columnDefinition = "TEXT")
    private String tnc;

    @Column(name = "usp", columnDefinition = "TEXT")
    private String usp;

    @Column(name = "companyInfo", columnDefinition = "TEXT")
    private String companyInfo;

    // WhatsApp Settings
    @Column(name = "whats_app_api_url")
    private String whatsAppApiUrl;

    @Column(name = "whats_app_api_key")
    private String whatsAppApiKey;

    @Column(name = "whats_app_registration_template_id")
    private String whatsAppRegistrationTemplateId;

    @Column(name = "whats_app_stay_quotation_template_id")
    private String whatsAppStayQuotationTemplateId;

    @Column(name = "whats_app_guest_quotation_template_id")
    private String whatsAppGuestQuotationTemplateId;

    // Email / SMTP Settings
    @Column(name = "email_smtp_host")
    private String emailSmtpHost;

    @Column(name = "email_smtp_port")
    private String emailSmtpPort;

    @Column(name = "email_smtp_username")
    private String emailSmtpUsername;

    @Column(name = "email_smtp_password")
    private String emailSmtpPassword;

    @Column(name = "email_from_address")
    private String emailFromAddress;

    @Column(name = "email_reply_to")
    private String emailReplyTo;

    @Column(name = "email_default_cc")
    private String emailDefaultCc;

    @Column(name = "email_notify_to")
    private String emailNotifyTo;

    @Column(name = "email_client_active")
    private String emailClientActive;

    @Column(name = "email_internal_active")
    private String emailInternalActive;

    // ===== Getters & Setters =====

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

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
    public void setWhatsAppRegistrationTemplateId(String whatsAppRegistrationTemplateId) { this.whatsAppRegistrationTemplateId = whatsAppRegistrationTemplateId; }

    public String getWhatsAppStayQuotationTemplateId() { return whatsAppStayQuotationTemplateId; }
    public void setWhatsAppStayQuotationTemplateId(String whatsAppStayQuotationTemplateId) { this.whatsAppStayQuotationTemplateId = whatsAppStayQuotationTemplateId; }

    public String getWhatsAppGuestQuotationTemplateId() { return whatsAppGuestQuotationTemplateId; }
    public void setWhatsAppGuestQuotationTemplateId(String whatsAppGuestQuotationTemplateId) { this.whatsAppGuestQuotationTemplateId = whatsAppGuestQuotationTemplateId; }

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
