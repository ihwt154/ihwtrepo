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

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }
}
