package com.ihwthms.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Column(name = "first_name", nullable = false, length = 50)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 50)
    private String lastName;

    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "user_role_mapping",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private java.util.Set<Role> roles = new java.util.HashSet<>();

    @Column(name = "designation", length = 100)
    private String designation;

    @Column(name = "company_email", length = 100)
    private String companyEmail;

    @Column(name = "company_mobile", length = 20)
    private String companyMobile;

    @Column(name = "personal_email", length = 100)
    private String personalEmail;

    @Column(name = "mobile", length = 20)
    private String mobile;

    @Column(name = "dob")
    @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE)
    private java.time.LocalDate dob;

    @Column(name = "doj")
    @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE)
    private java.time.LocalDate doj;

    @Column(name = "last_working_day")
    @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE)
    private java.time.LocalDate lastWorkingDay;

    @Column(name = "account_lock", nullable = false)
    private boolean accountLock = false;

    @Column(name = "remarks", length = 1000)
    private String remarks;

    @Column(name = "system_user", length = 50)
    private String systemUser;

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public java.util.Set<Role> getRoles() { return roles; }
    public void setRoles(java.util.Set<Role> roles) { this.roles = roles; }

    public boolean hasRole(String roleName) {
        if (roles != null) {
            boolean isSuperAdmin = roles.stream()
                    .map(Role::getRoleName)
                    .anyMatch(r -> r.equalsIgnoreCase("SUPERADMIN") || r.equalsIgnoreCase("ROLE_SUPERADMIN"));
            if (isSuperAdmin) {
                return true;
            }
        }
        if (roles == null) return false;
        String cleanRole = roleName.trim();
        String normalizedRole = cleanRole.startsWith("ROLE_") ? cleanRole.substring(5) : cleanRole;
        return roles.stream()
                .map(Role::getRoleName)
                .map(r -> r.startsWith("ROLE_") ? r.substring(5) : r)
                .anyMatch(r -> r.equalsIgnoreCase(normalizedRole));
    }

    public String getRolesListString() {
        if (roles == null) return "";
        return roles.stream()
                .map(Role::getRoleName)
                .collect(java.util.stream.Collectors.joining(","));
    }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public String getCompanyEmail() { return companyEmail; }
    public void setCompanyEmail(String companyEmail) { this.companyEmail = companyEmail; }

    public String getCompanyMobile() { return companyMobile; }
    public void setCompanyMobile(String companyMobile) { this.companyMobile = companyMobile; }

    public String getPersonalEmail() { return personalEmail; }
    public void setPersonalEmail(String personalEmail) { this.personalEmail = personalEmail; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public java.time.LocalDate getDob() { return dob; }
    public void setDob(java.time.LocalDate dob) { this.dob = dob; }

    public java.time.LocalDate getDoj() { return doj; }
    public void setDoj(java.time.LocalDate doj) { this.doj = doj; }

    public String getSystemUser() { return systemUser; }
    public void setSystemUser(String systemUser) { this.systemUser = systemUser; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getFormattedDob() {
        if (dob == null) return "";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd-MMM-yyyy", java.util.Locale.ENGLISH);
        return dob.format(formatter);
    }

    public String getFormattedDoj() {
        if (doj == null) return "";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd-MMM-yyyy", java.util.Locale.ENGLISH);
        return doj.format(formatter);
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy", java.util.Locale.ENGLISH);
        return createdAt.format(formatter);
    }

    public String getHtmlDob() {
        if (dob == null) return "";
        return dob.toString();
    }

    public String getHtmlDoj() {
        if (doj == null) return "";
        return doj.toString();
    }

    public java.time.LocalDate getLastWorkingDay() { return lastWorkingDay; }
    public void setLastWorkingDay(java.time.LocalDate lastWorkingDay) { this.lastWorkingDay = lastWorkingDay; }

    public boolean isAccountLock() { return accountLock; }
    public void setAccountLock(boolean accountLock) { this.accountLock = accountLock; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public String getHtmlLastWorkingDay() {
        if (lastWorkingDay == null) return "";
        return lastWorkingDay.toString();
    }

    public String getFormattedLastWorkingDay() {
        if (lastWorkingDay == null) return "";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd-MMM-yyyy", java.util.Locale.ENGLISH);
        return lastWorkingDay.format(formatter);
    }
}
