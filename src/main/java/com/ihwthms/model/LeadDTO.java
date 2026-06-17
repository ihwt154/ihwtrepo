package com.ihwthms.model;

import com.ihwthms.entity.Lead;

public class LeadDTO {

    private Long leadId;
    private String leadTitle;
    private String leadName;
    private String email;
    private String mobileNumber;
    private String city;
    private String country;
    private String leadStatus;
    private String leadSource;
    private String eventName;
    private String priority;
    private Long assignedTo;
    private String assignedToName;
    private String remarks;
    private Boolean isActive;

    // Client link
    private Long clientId;
    private String clientName;

    // Organisation fields (auto-populated from linked client, stored in DB)
    private String organizationName;
    private String organizationType;
    private String registrationNumber;
    private String website;
    private String address;
    private String postalCode;
    private String designation;

    public LeadDTO() {}

    public LeadDTO(Lead e) {
        this.leadId          = e.getId();
        this.leadTitle       = e.getLeadTitle();
        this.leadName        = e.getLeadName();
        this.email           = e.getEmail();
        this.mobileNumber    = e.getMobileNumber();
        this.city            = e.getCity();
        this.country         = e.getCountry();
        this.leadStatus      = e.getLeadStatus();
        this.leadSource      = e.getLeadSource();
        this.eventName       = e.getEventName();
        this.priority        = e.getPriority();
        this.assignedTo      = e.getAssignedTo();
        this.remarks         = e.getRemarks();
        this.isActive        = e.getIsActive();
        this.organizationName     = e.getOrganizationName();
        this.organizationType     = e.getOrganizationType();
        this.registrationNumber   = e.getRegistrationNumber();
        this.website              = e.getWebsite();
        this.address              = e.getAddress();
        this.postalCode           = e.getPostalCode();
        this.designation          = e.getDesignation();
        if (e.getClient() != null) {
            this.clientId   = e.getClient().getClientId();
            this.clientName = e.getClient().getClientName();
        }
    }

    // Getters & Setters
    public Long getLeadId() { return leadId; }
    public void setLeadId(Long leadId) { this.leadId = leadId; }

    public String getLeadTitle() { return leadTitle; }
    public void setLeadTitle(String leadTitle) { this.leadTitle = leadTitle; }

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

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

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

    public String getOrganizationName() { return organizationName; }
    public void setOrganizationName(String organizationName) { this.organizationName = organizationName; }

    public String getOrganizationType() { return organizationType; }
    public void setOrganizationType(String organizationType) { this.organizationType = organizationType; }

    public String getRegistrationNumber() { return registrationNumber; }
    public void setRegistrationNumber(String registrationNumber) { this.registrationNumber = registrationNumber; }

    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
}
