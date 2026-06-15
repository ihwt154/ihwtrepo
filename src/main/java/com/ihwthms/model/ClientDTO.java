package com.ihwthms.model;

import com.ihwthms.entity.ClientEntity;

public class ClientDTO {

    private Long clientId;
    private String clientCode;
    private String clientName;
    private String mobile;
    private String emailId;
    private String city;
    private String country;
    private String clientStatus;
    private Long assignedTo;
    private String clientSource;
    private String clientType;
    private String organizationName;
    private String organizationType;
    private String registrationNumber;
    private String website;
    private String address;
    private String postalCode;
    private String designation;
    private String remarks;
    private Boolean active;

    public ClientDTO() {}

    public ClientDTO(ClientEntity e) {
        this.clientId = e.getClientId();
        this.clientCode = e.getClientCode();
        this.clientName = e.getClientName();
        this.mobile = e.getMobile();
        this.emailId = e.getEmailId();
        this.city = e.getCity();
        this.country = e.getCountry();
        this.clientStatus = e.getClientStatus();
        this.assignedTo = e.getAssignedTo();
        this.clientSource = e.getClientSource();
        this.clientType = e.getClientType();
        this.organizationName = e.getOrganizationName();
        this.organizationType = e.getOrganizationType();
        this.registrationNumber = e.getRegistrationNumber();
        this.website = e.getWebsite();
        this.address = e.getAddress();
        this.postalCode = e.getPostalCode();
        this.designation = e.getDesignation();
        this.remarks = e.getRemarks();
        this.active = e.getActive();
    }

    // Getters & Setters
    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }

    public String getClientCode() { return clientCode; }
    public void setClientCode(String clientCode) { this.clientCode = clientCode; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getEmailId() { return emailId; }
    public void setEmailId(String emailId) { this.emailId = emailId; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public String getClientStatus() { return clientStatus; }
    public void setClientStatus(String clientStatus) { this.clientStatus = clientStatus; }

    public Long getAssignedTo() { return assignedTo; }
    public void setAssignedTo(Long assignedTo) { this.assignedTo = assignedTo; }

    public String getClientSource() { return clientSource; }
    public void setClientSource(String clientSource) { this.clientSource = clientSource; }

    public String getClientType() { return clientType; }
    public void setClientType(String clientType) { this.clientType = clientType; }

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

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }
}
