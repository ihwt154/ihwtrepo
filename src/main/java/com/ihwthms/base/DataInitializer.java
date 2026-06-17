package com.ihwthms.base;

import com.ihwthms.entity.User;
import com.ihwthms.entity.Role;
import com.ihwthms.repository.UserRepository;
import com.ihwthms.repository.RoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Override
    public void run(String... args) throws Exception {
        // Seed default users and roles if missing. Do not seed any leads.
        try {
            // 1. Delete the superadmin user from previous iteration if it exists
            userRepository.findByUsername("superadmin").ifPresent(u -> {
                userRepository.delete(u);
                System.out.println(">>> Database Seeded: Cleaned up hardcoded superadmin user.");
            });

            // 2. Seed SUPERADMIN role if not present
            Role superadminRole = roleRepository.findByRoleName("SUPERADMIN").orElseGet(() -> {
                Role r = new Role();
                r.setRoleName("SUPERADMIN");
                r.setRoleTarget("PRIV");
                Role saved = roleRepository.save(r);
                System.out.println(">>> Database Seeded: SUPERADMIN role created successfully!");
                return saved;
            });

            // Seed ADMIN role if not present
            Role adminRole = roleRepository.findByRoleName("ADMIN").orElseGet(() -> {
                Role r = new Role();
                r.setRoleName("ADMIN");
                r.setRoleTarget("PRIV");
                Role saved = roleRepository.save(r);
                System.out.println(">>> Database Seeded: ADMIN role created successfully!");
                return saved;
            });

            // Seed USER role if not present
            Role userRole = roleRepository.findByRoleName("USER").orElseGet(() -> {
                Role r = new Role();
                r.setRoleName("USER");
                r.setRoleTarget("PRIV");
                Role saved = roleRepository.save(r);
                System.out.println(">>> Database Seeded: USER role created successfully!");
                return saved;
            });

            // 3. Seed/Reset default admin user to have the SUPERADMIN role
            java.util.Optional<User> adminOpt = userRepository.findByUsername("admin");
            if (!adminOpt.isPresent()) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setPassword("admin123");
                admin.setEmail("admin@ihwthms.com");
                admin.setFirstName("Super");
                admin.setLastName("Admin");
                admin.setActive(true);
                
                java.util.Set<Role> roles = new java.util.HashSet<>();
                roles.add(superadminRole);
                admin.setRoles(roles);
                
                admin.setCreatedAt(LocalDateTime.now());
                admin.setUpdatedAt(LocalDateTime.now());
                
                admin.setDesignation("Super Admin");
                admin.setCompanyEmail("Super Admin");
                admin.setCompanyMobile("9999999999");
                admin.setPersonalEmail("dummy123@gmail.com");
                admin.setMobile("9999999999");
                admin.setDob(java.time.LocalDate.of(2000, 1, 1));
                admin.setDoj(java.time.LocalDate.of(2026, 1, 13));
                admin.setSystemUser("Admin");
                admin.setAddress("Hotel Address");
                
                userRepository.save(admin);
                System.out.println(">>> Database Seeded: Admin user created as SUPERADMIN!");
            } else {
                User admin = adminOpt.get();
                boolean updated = false;
                
                // Ensure first name is Super and last name is Admin
                if (!"Super".equals(admin.getFirstName()) || !"Admin".equals(admin.getLastName())) {
                    admin.setFirstName("Super");
                    admin.setLastName("Admin");
                    updated = true;
                }
                
                // Ensure default admin has Super Admin details
                if (!"Super Admin".equals(admin.getDesignation())) {
                    admin.setDesignation("Super Admin");
                    admin.setCompanyEmail("Super Admin");
                    admin.setCompanyMobile("9999999999");
                    admin.setPersonalEmail("dummy123@gmail.com");
                    admin.setMobile("9999999999");
                    admin.setDob(java.time.LocalDate.of(2000, 1, 1));
                    admin.setDoj(java.time.LocalDate.of(2026, 1, 13));
                    admin.setSystemUser("Admin");
                    admin.setAddress("Hotel Address");
                    updated = true;
                }

                // Ensure default admin has SUPERADMIN role mapped
                boolean hasSuperAdmin = admin.getRoles().stream()
                        .anyMatch(r -> r.getRoleName().equalsIgnoreCase("SUPERADMIN"));
                if (!hasSuperAdmin) {
                    admin.getRoles().add(superadminRole);
                    updated = true;
                }
                
                if (updated) {
                    userRepository.save(admin);
                    System.out.println(">>> Database Seeded: Reset admin user details to SUPERADMIN.");
                }
            }
        } catch (Exception e) {
            System.err.println(">>> Error during database user seeding: " + e.getMessage());
        }
    }
}
