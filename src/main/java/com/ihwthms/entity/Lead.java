package com.ihwthms.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "leads_master")
public class Lead {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "leadId")
    private Long id;

    @Column(name = "leadCode", length = 50)
    private String leadCode;

    @Column(name = "leadName", length = 100)
    private String leadName;

    @Column(length = 100)
    private String email;

    @Column(name = "mobileNumber", length = 20)
    private String mobileNumber;

    @Column(length = 100)
    private String city;

    @Column(length = 100)
    private String country;

    @Column(name = "leadStatus", length = 50)
    private String leadStatus;

    @Column(name = "leadSource", length = 50)
    private String leadSource;

    @Column(name = "priority", length = 50)
    private String priority;

    @Column(name = "assignedTo")
    private Long assignedTo;

    @Column(columnDefinition = "TEXT")
    private String remarks;

    @Column(name = "createdBy")
    private Long createdBy;

    @Column(name = "updatedBy")
    private Long updatedBy;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    @Column(name = "isActive")
    private Boolean isActive = true;

    /**
     * Link to the client this lead belongs to.
     * Hibernate will add clientId FK column to leads_master via ddl-auto=update.
     */
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "clientId")
    private ClientEntity client;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "leadEntity")
    @OrderBy("nextfollowuptime DESC")
    @JsonBackReference
    private Set<LeadsFollowupEntity> followupList = new HashSet<>();

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

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

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }

    public Long getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Long updatedBy) { this.updatedBy = updatedBy; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public ClientEntity getClient() { return client; }
    public void setClient(ClientEntity client) { this.client = client; }

    public Set<LeadsFollowupEntity> getFollowupList() { return followupList; }
    public void setFollowupList(Set<LeadsFollowupEntity> followupList) { this.followupList = followupList; }
}
