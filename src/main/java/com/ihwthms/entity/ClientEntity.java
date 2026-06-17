package com.ihwthms.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "client")
public class ClientEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "clientId")
    private Long clientId;

    @Column(name = "clientName", nullable = false)
    private String clientName;

    @Column(name = "mobile", length = 50)
    private String mobile;

    @Column(name = "emailId")
    private String emailId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "city_id")
    private City city;

    @Column(name = "country", length = 100)
    private String country;

    @Column(name = "clientStatus", length = 50)
    private String clientStatus = "Active";

    @Column(name = "assignedTo")
    private Long assignedTo;

    @Column(name = "clientSource", length = 100)
    private String clientSource;

    @Column(name = "clientType", length = 100)
    private String clientType;

    // ===== New Fields =====
    @Column(name = "organization_name", length = 200)
    private String organizationName;

    @Column(name = "organization_type", length = 100)
    private String organizationType;

    @Column(name = "registration_number", length = 100)
    private String registrationNumber;

    @Column(name = "website", length = 200)
    private String website;

    @Column(name = "address", columnDefinition = "TEXT")
    private String address;

    @Column(name = "postal_code", length = 20)
    private String postalCode;

    @Column(name = "designation", length = 100)
    private String designation;
    // ===== End New Fields =====

    @Column(columnDefinition = "TEXT")
    private String remarks;

    @Column(name = "createdBy")
    private Long createdBy;

    @Column(name = "updatedBy")
    private Long updatedBy;

    @Column(name = "active")
    private Boolean active = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    public ClientEntity() {}

    // Getters & Setters
    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getEmailId() { return emailId; }
    public void setEmailId(String emailId) { this.emailId = emailId; }

    public City getCity() { return city; }
    public void setCity(City city) { this.city = city; }

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

    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }

    public Long getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Long updatedBy) { this.updatedBy = updatedBy; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
