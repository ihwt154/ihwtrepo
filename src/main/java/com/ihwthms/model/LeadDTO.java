package com.ihwthms.model;

import com.ihwthms.entity.Lead;

public class LeadDTO {

    private Long leadId;
    private String leadCode;
    private String leadName;
    private String email;
    private String mobileNumber;
    private String city;
    private String country;
    private String leadStatus;
    private String leadSource;
    private String priority;
    private Long assignedTo;
    private String assignedToName;
    private String remarks;
    private Boolean isActive;

    // Client link
    private Long clientId;
    private String clientName;

    public LeadDTO() {}

    public LeadDTO(Lead e) {
        this.leadId = e.getId();
        this.leadCode = e.getLeadCode();
        this.leadName = e.getLeadName();
        this.email = e.getEmail();
        this.mobileNumber = e.getMobileNumber();
        this.city = e.getCity();
        this.country = e.getCountry();
        this.leadStatus = e.getLeadStatus();
        this.leadSource = e.getLeadSource();
        this.priority = e.getPriority();
        this.assignedTo = e.getAssignedTo();
        this.remarks = e.getRemarks();
        this.isActive = e.getIsActive();
        if (e.getClient() != null) {
            this.clientId = e.getClient().getClientId();
            this.clientName = e.getClient().getClientName();
        }
    }

    // Getters & Setters
    public Long getLeadId() { return leadId; }
    public void setLeadId(Long leadId) { this.leadId = leadId; }

    public String getLeadCode() { return leadCode; }
    public void setLeadCode(String leadCode) { this.leadCode = leadCode; }

    public String getLeadName() { return leadName; }
    public void setLeadName(String leadName) { this.leadName = leadName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public String getLeadStatus() { return leadStatus; }
    public void setLeadStatus(String leadStatus) { this.leadStatus = leadStatus; }

    public String getLeadSource() { return leadSource; }
    public void setLeadSource(String leadSource) { this.leadSource = leadSource; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public Long getAssignedTo() { return assignedTo; }
    public void setAssignedTo(Long assignedTo) { this.assignedTo = assignedTo; }

    public String getAssignedToName() { return assignedToName; }
    public void setAssignedToName(String assignedToName) { this.assignedToName = assignedToName; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }
}
