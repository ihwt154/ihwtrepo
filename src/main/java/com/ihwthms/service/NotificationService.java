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
import javax.net.ssl.*;
import java.security.cert.X509Certificate;
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
        if (config == null)
            return;

        boolean clientActive = "true".equalsIgnoreCase(config.getEmailClientActive());
        boolean internalActive = "true".equalsIgnoreCase(config.getEmailInternalActive());

        if (!clientActive && !internalActive)
            return;

        String host = config.getEmailSmtpHost();
        String portStr = config.getEmailSmtpPort();
        String username = config.getEmailSmtpUsername();
        String password = config.getEmailSmtpPassword();
        String from = config.getEmailFromAddress();

        if (host == null || host.isEmpty() || username == null || username.isEmpty() || password == null
                || password.isEmpty()) {
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
        props.put("mail.debug", "true");

        String companyName = config.getCompanyName() != null ? config.getCompanyName() : "CRM";
        String phone = config.getCentralNumber() != null ? config.getCentralNumber() : "";
        String contactEmail = (config.getCentralizedEmail() != null && !config.getCentralizedEmail().trim().isEmpty())
                ? config.getCentralizedEmail()
                : (config.getEmailFromAddress() != null ? config.getEmailFromAddress() : "");
        String website = config.getWebsite() != null ? config.getWebsite() : "";
        String senderFrom = from != null && !from.isEmpty() ? from : username;

        // 1. Client Email Notification
        if (notifyEmail && clientActive && lead.getEmail() != null && !lead.getEmail().trim().isEmpty()) {
            try {
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
                helper.setFrom(senderFrom);
                helper.setTo(lead.getEmail());
                helper.setSubject("Thank you for your inquiry – " + companyName);

                String body = buildClientEmailTemplate(
                        lead.getLeadName() != null ? lead.getLeadName() : "Valued Guest",
                        lead.getLeadTitle() != null ? lead.getLeadTitle() : "General Inquiry",
                        companyName, phone, contactEmail, website);

                helper.setText(body, true);
                mailSender.send(message);
                System.out.println("Client lead notification email sent successfully to " + lead.getEmail());
            } catch (Exception e) {
                System.err.println("Error sending client lead notification email: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // 2. Internal Email Notification
        String toEmail = config.getEmailNotifyTo();
        if (toEmail == null || toEmail.trim().isEmpty()) {
            toEmail = config.getCentralizedEmail();
        }
        if (toEmail != null && !toEmail.trim().isEmpty()) {
            try {
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
                helper.setFrom(senderFrom);
                helper.setTo(toEmail);
                helper.setSubject(
                        "🔔 New Lead: " + (lead.getLeadTitle() != null ? lead.getLeadTitle() : lead.getLeadName()));

                String body = buildInternalEmailTemplate(lead, companyName);

                helper.setText(body, true);
                mailSender.send(message);
                System.out.println("Internal lead notification email sent successfully to " + toEmail);
            } catch (Exception e) {
                System.err.println("Error sending internal lead notification email: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    // ─── CLIENT EMAIL TEMPLATE ────────────────────────────────────────────────
    private String buildClientEmailTemplate(String recipientName, String inquiryTitle,
            String companyName, String phone, String email, String website) {
        return "<!DOCTYPE html>" +
                "<html lang='en'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width,initial-scale=1.0'>"
                +
                "<title>Inquiry Confirmation – IHWT Federation</title></head>" +
                "<body style='margin:0;padding:0;background-color:#f4f6f9;font-family:Arial,Helvetica,sans-serif;'>" +
                "<table width='100%' cellpadding='0' cellspacing='0' border='0' style='background-color:#f4f6f9;padding:30px 0;'>"
                +
                "<tr><td align='center'>" +
                "<table width='600' cellpadding='0' cellspacing='0' border='0' style='max-width:600px;width:100%;background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.08);'>"
                +

                // Header
                "<tr><td style='background:#0f172a;padding:32px 40px;text-align:center;'>" +
                "<h1 style='margin:0;color:#ffffff;font-size:22px;font-weight:700;letter-spacing:0.5px;'>IHWT Federation</h1>"
                +
                "<p style='margin:6px 0 0;color:#94a3b8;font-size:13px;letter-spacing:1px;text-transform:uppercase;'>Inquiry Confirmation</p>"
                +
                "</td></tr>" +

                // Divider
                "<tr><td style='background:#3b82f6;height:4px;'></td></tr>" +

                // Body — {{1}} = recipientName (lead name, the only variable)
                "<tr><td style='padding:40px 40px 36px;color:#334155;'>" +
                "<p style='margin:0 0 20px;font-size:15px;line-height:1.8;color:#1e293b;'>Hello <strong>"
                + recipientName + "</strong>,</p>" +
                "<p style='margin:0 0 20px;font-size:15px;line-height:1.8;color:#475569;'>Your inquiry has been successfully received.</p>"
                +
                "<p style='margin:0 0 20px;font-size:15px;line-height:1.8;color:#475569;'>A member of our team will contact you within the next 24 hours regarding your request related to your inquiry.</p>"
                +
                "<p style='margin:0 0 6px;font-size:15px;line-height:1.8;color:#475569;'>For reference, event information is available at:</p>"
                +
                "<p style='margin:0 0 28px;'><a href='https://www.ihwtfederation.org' style='color:#3b82f6;text-decoration:none;font-size:15px;font-weight:600;'>www.ihwtfederation.org</a></p>"
                +
                "<p style='margin:0 0 20px;font-size:15px;color:#475569;'>Thank you.</p>" +
                "<p style='margin:0;font-size:15px;font-weight:700;color:#0f172a;'>IHWT Federation</p>" +
                "</td></tr>" +

                // Footer
                "<tr><td style='background:#f8fafc;border-top:1px solid #e2e8f0;padding:16px 40px;text-align:center;'>"
                +
                "<p style='margin:0;font-size:12px;color:#94a3b8;'>This is an automated message. Please do not reply directly to this email.</p>"
                +
                "</td></tr>" +

                "</table>" +
                "</td></tr></table>" +
                "</body></html>";
    }

    // ─── INTERNAL EMAIL TEMPLATE ──────────────────────────────────────────────
    private String buildInternalEmailTemplate(Lead lead, String companyName) {
        String leadTitle = lead.getLeadTitle() != null ? lead.getLeadTitle() : "—";
        String leadName = lead.getLeadName() != null ? lead.getLeadName() : "—";
        String mobile = lead.getMobileNumber() != null ? lead.getMobileNumber() : "—";
        String email = lead.getEmail() != null ? lead.getEmail() : "—";
        String source = lead.getLeadSource() != null ? lead.getLeadSource() : "—";
        String priority = lead.getPriority() != null ? lead.getPriority() : "—";
        String status = lead.getLeadStatus() != null ? lead.getLeadStatus() : "—";
        String event = lead.getEventName() != null ? lead.getEventName() : "—";
        String clientName = (lead.getClient() != null && lead.getClient().getClientName() != null)
                ? lead.getClient().getClientName()
                : "—";

        return "<!DOCTYPE html>" +
                "<html lang='en'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width,initial-scale=1.0'>"
                +
                "<title>New Lead Alert – " + companyName + "</title></head>" +
                "<body style='margin:0;padding:0;background-color:#f4f6f9;font-family:Arial,Helvetica,sans-serif;'>" +
                "<table width='100%' cellpadding='0' cellspacing='0' border='0' style='background-color:#f4f6f9;padding:30px 0;'>"
                +
                "<tr><td align='center'>" +
                "<table width='600' cellpadding='0' cellspacing='0' border='0' style='max-width:600px;width:100%;background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.08);'>"
                +

                // Header
                "<tr><td style='background:#0f172a;padding:28px 40px;'>" +
                "<h1 style='margin:0;color:#ffffff;font-size:20px;font-weight:700;'>🔔 New Lead Registered</h1>" +
                "<p style='margin:6px 0 0;color:#94a3b8;font-size:13px;'>" + companyName + " · CRM System</p>" +
                "</td></tr>" +

                // Alert bar
                "<tr><td style='background:#3b82f6;padding:10px 40px;'>" +
                "<p style='margin:0;color:#ffffff;font-size:13px;font-weight:600;'>A new lead has been submitted and requires your attention.</p>"
                +
                "</td></tr>" +

                // Body
                "<tr><td style='padding:32px 40px;'>" +
                "<table width='100%' cellpadding='0' cellspacing='0' border='0' style='border-collapse:collapse;'>" +
                buildRow("Lead Title", leadTitle, true) +
                buildRow("Client", clientName, false) +
                buildRow("Contact Name", leadName, true) +
                buildRow("Mobile", mobile, false) +
                buildRow("Email", email, true) +
                buildRow("Source", source, false) +
                buildRow("Event", event, true) +
                buildRow("Priority", priority, false) +
                buildRow("Status", status, true) +
                "</table>" +
                "</td></tr>" +

                // Footer
                "<tr><td style='background:#f8fafc;border-top:1px solid #e2e8f0;padding:20px 40px;text-align:center;'>"
                +
                "<p style='margin:0;font-size:13px;color:#64748b;'>Please log in to the CRM to view and assign this lead.</p>"
                +
                "<p style='margin:8px 0 0;font-size:12px;color:#94a3b8;'>This is an automated internal notification from "
                + companyName + " CRM.</p>" +
                "</td></tr>" +

                "</table>" +
                "</td></tr></table>" +
                "</body></html>";
    }

    private String buildRow(String label, String value, boolean shaded) {
        String bg = shaded ? "background:#f8fafc;" : "background:#ffffff;";
        return "<tr>" +
                "<td style='" + bg
                + "padding:10px 14px;font-size:13px;color:#64748b;font-weight:600;width:38%;border-bottom:1px solid #f1f5f9;'>"
                + label + "</td>" +
                "<td style='" + bg + "padding:10px 14px;font-size:14px;color:#0f172a;border-bottom:1px solid #f1f5f9;'>"
                + value + "</td>" +
                "</tr>";
    }

    private void sendWhatsAppNotification(Lead lead) {
        CentralConfigEntity config = centralConfigRepository.findTopByOrderByIdAsc();
        if (config == null)
            return;

        String apiUrl = config.getWhatsAppApiUrl();
        String apiKey = config.getWhatsAppApiKey();
        String templateId = config.getWhatsAppRegistrationTemplateId();
        String recipientMobile = lead.getMobileNumber();

        if (recipientMobile == null || recipientMobile.trim().isEmpty()) {
            System.out.println("No mobile number provided for lead. Skipping WhatsApp notification.");
            return;
        }

        if (apiUrl == null || apiUrl.trim().isEmpty()) {
            System.out.println(
                    "WhatsApp API URL not configured. Mocking WhatsApp notification send to: " + recipientMobile);
            return;
        }

        try {
            TrustManager[] trustAllCerts = new TrustManager[] {
                    new X509TrustManager() {
                        public X509Certificate[] getAcceptedIssuers() {
                            return null;
                        }

                        public void checkClientTrusted(X509Certificate[] certs, String authType) {
                        }

                        public void checkServerTrusted(X509Certificate[] certs, String authType) {
                        }
                    }
            };

            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());

            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
            HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            if (apiKey != null && !apiKey.trim().isEmpty()) {
                headers.set("Authorization", "Basic " + apiKey);
            }

            Map<String, Object> bodyValues = new HashMap<>();
            bodyValues.put("1", lead.getLeadName());
            bodyValues.put("2", lead.getLeadTitle() != null ? lead.getLeadTitle() : "General Inquiry");
            bodyValues.put("3", config.getCompanyName() != null ? config.getCompanyName() : "IHWT Federation");

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("country_code", "91");
            requestBody.put("mobile", recipientMobile);
            requestBody.put("wid", templateId);
            requestBody.put("type", "text");
            requestBody.put("bodyValues", bodyValues);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            System.out.println("========== WHATSAPP REQUEST ==========");
            System.out.println("API URL: " + apiUrl);
            System.out.println("Template ID: " + templateId);
            System.out.println("Mobile: " + recipientMobile);
            System.out.println("Request Body: " + requestBody);
            System.out.println("=====================================");
            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, entity, String.class);

            System.out.println("WhatsApp notification API response: "
                    + response.getStatusCode() + " - " + response.getBody());
            System.out.println(
                    "WhatsApp notification API response: " + response.getStatusCode() + " - " + response.getBody());
        } catch (Exception e) {
            System.err.println("Error sending WhatsApp notification: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
