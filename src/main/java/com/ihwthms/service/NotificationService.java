package com.ihwthms.service;

import com.ihwthms.entity.CentralConfigEntity;
import com.ihwthms.entity.Lead;
import com.ihwthms.repository.CentralConfigEntityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import javax.mail.internet.MimeMessage;
import java.util.*;

@Service
public class NotificationService {

    @Autowired
    private CentralConfigEntityRepository centralConfigRepository;

    public void sendLeadRegistrationNotifications(Lead lead, boolean notifyEmail, boolean notifyWhatsApp) {
        new Thread(() -> {
            try {
                sendEmailNotifications(lead, notifyEmail);
            } catch (Exception e) {
                System.err.println("Failed to send lead registration email: " + e.getMessage());
                e.printStackTrace();
            }
            try {
                if (notifyWhatsApp) {
                    sendWhatsAppNotification(lead);
                } else {
                    System.out.println("WhatsApp notification not checked. Skipping WhatsApp notification.");
                }
            } catch (Exception e) {
                System.err.println("Failed to send lead registration WhatsApp: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }

    private void sendEmailNotifications(Lead lead, boolean notifyEmail) {
        CentralConfigEntity config = centralConfigRepository.findTopByOrderByIdAsc();
        if (config == null) return;

        boolean clientActive = "true".equalsIgnoreCase(config.getEmailClientActive());
        boolean internalActive = "true".equalsIgnoreCase(config.getEmailInternalActive());

        if (!clientActive && !internalActive) return;

        String host = config.getEmailSmtpHost();
        String portStr = config.getEmailSmtpPort();
        String username = config.getEmailSmtpUsername();
        String password = config.getEmailSmtpPassword();
        String from = config.getEmailFromAddress();

        if (host == null || host.isEmpty() || username == null || username.isEmpty() || password == null || password.isEmpty()) {
            System.out.println("SMTP settings not configured in Central Config. Skipping email notifications.");
            return;
        }

        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost(host);
        if (portStr != null && !portStr.isEmpty()) {
            try {
                mailSender.setPort(Integer.parseInt(portStr));
            } catch (NumberFormatException e) {
                mailSender.setPort(587);
            }
        } else {
            mailSender.setPort(587);
        }
        mailSender.setUsername(username);
        mailSender.setPassword(password);

        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", host);

        // 1. Client Email Notification
        if (notifyEmail && clientActive && lead.getEmail() != null && !lead.getEmail().trim().isEmpty()) {
            try {
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
                helper.setFrom(from != null && !from.isEmpty() ? from : username);
                helper.setTo(lead.getEmail());
                helper.setSubject("We received your inquiry - " + (lead.getLeadTitle() != null ? lead.getLeadTitle() : "Lead Registered"));
                
                String companyName = config.getCompanyName() != null ? config.getCompanyName() : "IHWT CRM";
                String phone = config.getCentralNumber() != null ? config.getCentralNumber() : "+91 XXXXX XXXXX";
                String contactEmail = (config.getCentralizedEmail() != null && !config.getCentralizedEmail().trim().isEmpty())
                        ? config.getCentralizedEmail()
                        : (config.getEmailFromAddress() != null ? config.getEmailFromAddress() : "info@ihwtfederation.com");
                String body = "<h3>Hello " + lead.getLeadName() + ",</h3>"
                        + "<p>Thank you for reaching out to us. Your inquiry regarding \"" + (lead.getLeadTitle() != null ? lead.getLeadTitle() : "") + "\" has been successfully registered.</p>"
                        + "<p>Our team will review your request and contact you shortly.</p>"
                        + "<p>Best regards,<br/><strong>" + companyName + " Team</strong></p>"
                        + "<p>Email: " + contactEmail + "<br/>Contact No.: " + phone + "</p>";

                helper.setText(body, true);
                mailSender.send(message);
                System.out.println("Client lead notification email sent successfully to " + lead.getEmail());
            } catch (Exception e) {
                System.err.println("Error sending client lead notification email: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // 2. Internal Email Notification
        // Send internal email notification if a recipient email is configured
        String toEmail = config.getEmailNotifyTo();
        if (toEmail == null || toEmail.trim().isEmpty()) {
            toEmail = config.getCentralizedEmail();
        }
        // Proceed only if a recipient is defined
        if (toEmail != null && !toEmail.trim().isEmpty()) {
            try {
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
                helper.setFrom(from != null && !from.isEmpty() ? from : username);
                helper.setTo(toEmail);
                helper.setSubject("New Lead Registered: " + (lead.getLeadTitle() != null ? lead.getLeadTitle() : lead.getLeadName()));
                
                String body = "<h3>New Lead Alert</h3>" +
                        "<p>A new lead has been registered with the following details:</p>" +
                        "<ul>" +
                        "<li><strong>Lead Title:</strong> " + (lead.getLeadTitle() != null ? lead.getLeadTitle() : lead.getLeadName()) + "</li>" +
                        "<li><strong>Mobile:</strong> " + (lead.getMobileNumber() != null ? lead.getMobileNumber() : "—") + "</li>" +
                        "<li><strong>Email:</strong> " + (lead.getEmail() != null ? lead.getEmail() : "—") + "</li>" +
                        "</ul>" +
                        "<br/><p>Please log in to the CRM to view/assign the lead.</p>";
                
                helper.setText(body, true);
                mailSender.send(message);
                System.out.println("Internal lead notification email sent successfully to " + toEmail);
            } catch (Exception e) {
                System.err.println("Error sending internal lead notification email: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    private void sendWhatsAppNotification(Lead lead) {
        CentralConfigEntity config = centralConfigRepository.findTopByOrderByIdAsc();
        if (config == null) return;

        String apiUrl = config.getWhatsAppApiUrl();
        String apiKey = config.getWhatsAppApiKey();
        String templateId = config.getWhatsAppRegistrationTemplateId();
        String recipientMobile = lead.getMobileNumber();

        if (recipientMobile == null || recipientMobile.trim().isEmpty()) {
            System.out.println("No mobile number provided for lead. Skipping WhatsApp notification.");
            return;
        }

        if (apiUrl == null || apiUrl.trim().isEmpty()) {
            System.out.println("WhatsApp API URL not configured. Mocking WhatsApp notification send to: " + recipientMobile);
            return;
        }

        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            if (apiKey != null && !apiKey.trim().isEmpty()) {
                headers.set("Authorization", "Bearer " + apiKey);
                headers.set("apikey", apiKey);
            }

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("to", recipientMobile);
            requestBody.put("templateId", templateId != null ? templateId : "lead_registration_template");
            
            List<String> parameters = new ArrayList<>();
            parameters.add(lead.getLeadName());
            parameters.add(lead.getLeadTitle() != null ? lead.getLeadTitle() : "General Inquiry");
            parameters.add(config.getCompanyName() != null ? config.getCompanyName() : "IHWT CRM");
            requestBody.put("parameters", parameters);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, entity, String.class);
            System.out.println("WhatsApp notification API response: " + response.getStatusCode() + " - " + response.getBody());
        } catch (Exception e) {
            System.err.println("Error sending WhatsApp notification: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
