package com.ihwthms.entity;

import javax.persistence.*;

@Entity
@Table(name = "client_type")
public class ClientTypeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "type_name", nullable = false, length = 100)
    private String typeName;

    @Column(name = "active")
    private Boolean active = true;

    public ClientTypeEntity() {}

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }
}
