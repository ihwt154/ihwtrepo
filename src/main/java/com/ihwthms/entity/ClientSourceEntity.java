package com.ihwthms.entity;

import javax.persistence.*;

@Entity
@Table(name = "client_source")
public class ClientSourceEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "source_name", nullable = false, length = 100)
    private String sourceName;

    @Column(name = "active")
    private Boolean active = true;

    public ClientSourceEntity() {}

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getSourceName() { return sourceName; }
    public void setSourceName(String sourceName) { this.sourceName = sourceName; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }
}
