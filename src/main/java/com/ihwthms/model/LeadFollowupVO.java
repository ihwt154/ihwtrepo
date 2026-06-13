package com.ihwthms.model;

import java.time.LocalDateTime;

public class LeadFollowupVO {

    private Long leadFollowupId;
    private Long leadId;
    private LocalDateTime followuptime;
    private String response;
    private LocalDateTime nextfollowuptime;
    private String nextactionplan;
    private Long updatedBy;
    private String updatedByName;

    // Formatted display strings
    private String formattedFollowupTime;
    private String formattedNextFollowupTime;

    public LeadFollowupVO() {}

    // Getters & Setters
    public Long getLeadFollowupId() { return leadFollowupId; }
    public void setLeadFollowupId(Long leadFollowupId) { this.leadFollowupId = leadFollowupId; }

    public Long getLeadId() { return leadId; }
    public void setLeadId(Long leadId) { this.leadId = leadId; }

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

    public String getUpdatedByName() { return updatedByName; }
    public void setUpdatedByName(String updatedByName) { this.updatedByName = updatedByName; }

    public String getFormattedFollowupTime() { return formattedFollowupTime; }
    public void setFormattedFollowupTime(String formattedFollowupTime) { this.formattedFollowupTime = formattedFollowupTime; }

    public String getFormattedNextFollowupTime() { return formattedNextFollowupTime; }
    public void setFormattedNextFollowupTime(String formattedNextFollowupTime) { this.formattedNextFollowupTime = formattedNextFollowupTime; }
}
