package com.ihwthms.entity;

import javax.persistence.*;

@Entity
@Table(name = "workload_status")
public class WorkloadStatusEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "workloadStatusId")
    private Integer workloadStatusId;

    @Column(name = "workloadStatusObj")
    private String workloadStatusObj;

    @Column(name = "workloadStatusObjType")
    private String workloadStatusObjType;

    @Column(name = "workloadStatusName")
    private String workloadStatusName;

    @Column(name = "workloadCategory")
    private Integer workloadCategory;

    @Column(name = "active")
    private Boolean active;

    // Getters and Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getWorkloadStatusId() {
        return workloadStatusId;
    }

    public void setWorkloadStatusId(Integer workloadStatusId) {
        this.workloadStatusId = workloadStatusId;
    }

    public String getWorkloadStatusObj() {
        return workloadStatusObj;
    }

    public void setWorkloadStatusObj(String workloadStatusObj) {
        this.workloadStatusObj = workloadStatusObj;
    }

    public String getWorkloadStatusObjType() {
        return workloadStatusObjType;
    }

    public void setWorkloadStatusObjType(String workloadStatusObjType) {
        this.workloadStatusObjType = workloadStatusObjType;
    }

    public String getWorkloadStatusName() {
        return workloadStatusName;
    }

    public void setWorkloadStatusName(String workloadStatusName) {
        this.workloadStatusName = workloadStatusName;
    }

    public Integer getWorkloadCategory() {
        return workloadCategory;
    }

    public void setWorkloadCategory(Integer workloadCategory) {
        this.workloadCategory = workloadCategory;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }
}
