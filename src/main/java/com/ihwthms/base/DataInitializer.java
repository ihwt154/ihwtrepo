package com.ihwthms.base;

import com.ihwthms.entity.User;
import com.ihwthms.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void run(String... args) throws Exception {
        // Seed default user if missing. Do not seed any leads.
        try {
            if (!userRepository.findByUsername("admin").isPresent()) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setPassword("admin123"); // plain text for simplicity in v1
                admin.setEmail("admin@ihwthms.com");
                admin.setFirstName("Admin");
                admin.setLastName("User");
                admin.setActive(true);
                admin.setCreatedAt(LocalDateTime.now());
                admin.setUpdatedAt(LocalDateTime.now());
                
                userRepository.save(admin);
                System.out.println(">>> Database Seeded: Admin user created successfully!");
            }
        } catch (Exception e) {
            System.err.println(">>> Error during database user seeding: " + e.getMessage());
        }
    }
}
