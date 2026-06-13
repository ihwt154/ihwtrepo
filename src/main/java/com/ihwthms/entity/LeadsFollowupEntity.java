package com.ihwthms.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "leads_followup")
public class LeadsFollowupEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "leadFollowupId")
    private Long leadFollowupId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "leadId", nullable = false)
    private Lead leadEntity;

    @Column(name = "followuptime")
    private LocalDateTime followuptime;

    @Column(columnDefinition = "TEXT")
    private String response;

    @Column(name = "nextfollowuptime")
    private LocalDateTime nextfollowuptime;

    @Column(columnDefinition = "TEXT")
    private String nextactionplan;

    @Column(name = "updatedBy")
    private Long updatedBy;

    @Column(name = "createdBy")
    private Long createdBy;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    public LeadsFollowupEntity() {}

    // Getters & Setters
    public Long getLeadFollowupId() { return leadFollowupId; }
    public void setLeadFollowupId(Long leadFollowupId) { this.leadFollowupId = leadFollowupId; }

    public Lead getLeadEntity() { return leadEntity; }
    public void setLeadEntity(Lead leadEntity) { this.leadEntity = leadEntity; }

    public LocalDateTime getFollowuptime() { return followuptime; }
    public void setFollowuptime(LocalDateTime followuptime) { this.followuptime = followuptime; }

    public String getResponse() { return response; }
    public void setResponse(String response) { this.response = response; }

    public LocalDateTime getNextfollowuptime() { return nextfollowuptime; }
    public void setNextfollowuptime(LocalDateTime nextfollowuptime) { this.nextfollowuptime = nextfollowuptime; }

    public String getNextactionplan() { return nextactionplan; }
    public void setNextactionplan(String nextactionplan) { this.nextactionplan = nextactionplan; }

    public Long getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Long updatedBy) { this.updatedBy = updatedBy; }

    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
