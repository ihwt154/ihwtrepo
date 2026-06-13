<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Central Configuration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .settings-container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 32px 40px;
        }
        .settings-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
        }
        .settings-header h2 {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
        }
        .settings-section {
            background: rgba(255,255,255,0.85);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-glow);
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 24px;
            box-shadow: 0 4px 20px rgba(15,23,42,0.04);
            transition: border-color 0.3s;
        }
        .settings-section:hover {
            border-color: var(--border-glow-hover);
        }
        .section-title {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--accent-primary);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--accent-primary);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 16px;
        }
        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .form-grid-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 16px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .form-group label {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 13px;
            border: 1px solid rgba(15,23,42,0.12);
            border-radius: 8px;
            font-size: 0.9rem;
            font-family: 'Outfit', sans-serif;
            background: rgba(255,255,255,0.8);
            color: var(--text-primary);
            transition: all 0.25s;
            outline: none;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: var(--accent-primary);
            background: #fff;
            box-shadow: 0 0 0 3px rgba(217,119,6,0.1);
        }
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-group-full {
            grid-column: 1 / -1;
        }
        .radio-group {
            display: flex;
            gap: 20px;
            align-items: center;
            padding: 10px 0;
        }
        .radio-group label {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--text-primary);
            cursor: pointer;
            text-transform: none;
            letter-spacing: 0;
        }
        .radio-group input[type="radio"] {
            width: auto;
            accent-color: var(--accent-primary);
        }
        .logo-preview {
            margin-top: 10px;
            max-height: 60px;
            border-radius: 8px;
            display: none;
            border: 1px solid var(--border-glow);
        }
        .alert-success {
            background: #d1fae5;
            color: #065f46;
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            border: 1px solid rgba(16,185,129,0.25);
        }
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            border: 1px solid rgba(239,68,68,0.2);
        }
        .btn-save {
            background: linear-gradient(135deg, var(--accent-primary) 0%, #B45309 100%);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 13px 36px;
            font-size: 0.95rem;
            font-weight: 700;
            font-family: 'Outfit', sans-serif;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(217,119,6,0.25);
            transition: all 0.25s;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(217,119,6,0.35);
        }
        .save-bar {
            display: flex;
            justify-content: flex-end;
            padding-top: 16px;
        }
        @media (max-width: 768px) {
            .form-grid-2, .form-grid-3 { grid-template-columns: 1fr; }
            .settings-container { padding: 20px; }
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>

<div class="settings-container">

    <div class="settings-header">
        <h2>⚙️ Central Configuration</h2>
    </div>

    <c:if test="${not empty success}">
        <div class="alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert-error">❌ ${error}</div>
    </c:if>

    <form:form modelAttribute="CENTRAL_CONFIG_OBJ" method="post" enctype="multipart/form-data"
               action="${pageContext.request.contextPath}/create_edit_central_config">

        <%-- ===== ORGANISATION INFO ===== --%>
        <div class="settings-section">
            <div class="section-title">🏢 Organisation Information</div>
            <div class="form-grid">
                <div class="form-group">
                    <label>Company Name</label>
                    <form:input path="companyName" />
                </div>
                <div class="form-group">
                    <label>Address</label>
                    <form:input path="companyAddress" />
                </div>
                <div class="form-group">
                    <label>Central Phone Number</label>
                    <form:input path="centralNumber" />
                </div>
                <div class="form-group">
                    <label>Centralized Email</label>
                    <form:input path="centralizedEmail" />
                </div>
                <div class="form-group">
                    <label>GST Number</label>
                    <form:input path="gstNumber" />
                </div>
                <div class="form-group">
                    <label>Website</label>
                    <form:input path="website" />
                </div>
                <div class="form-group">
                    <label>Base URL</label>
                    <form:input path="baseUrl" />
                </div>
            </div>
        </div>

        <%-- ===== ESCALATION & LOGO ===== --%>
        <div class="settings-section">
            <div class="section-title">🚨 Escalation & Branding</div>
            <div class="form-grid-2">
                <div class="form-group">
                    <label>Escalation Email</label>
                    <form:input path="escalationEmail" />
                </div>
                <div class="form-group">
                    <label>Escalation Phone</label>
                    <form:input path="escalationPhone" />
                </div>
                <div class="form-group">
                    <label>Logo Upload (replaces current logo)</label>
                    <input type="file" id="logoFile" name="logoFile" accept="image/*" style="border:none;padding:4px 0;background:transparent;" />
                    <img id="logoPreview" class="logo-preview" alt="Logo Preview" />
                </div>
                <div class="form-group">
                    <label>Current Logo Path</label>
                    <form:input path="logoPath" />
                </div>
            </div>
        </div>

        <%-- ===== BANK DETAILS ===== --%>
        <div class="settings-section">
            <div class="section-title">🏦 Bank Details</div>
            <div class="form-grid-3">
                <div class="form-group">
                    <label>Account Name</label>
                    <form:input path="accountName" />
                </div>
                <div class="form-group">
                    <label>Bank Name</label>
                    <form:input path="bankName" />
                </div>
                <div class="form-group">
                    <label>Account Number</label>
                    <form:input path="accountNumber" />
                </div>
                <div class="form-group">
                    <label>IFSC Code</label>
                    <form:input path="ifscCode" />
                </div>
                <div class="form-group">
                    <label>Branch</label>
                    <form:input path="branch" />
                </div>
            </div>
        </div>

        <%-- ===== GLOBAL WATCHER ===== --%>
        <div class="settings-section">
            <div class="section-title">👁 Global Watcher Settings</div>
            <div class="form-grid-2">
                <div class="form-group">
                    <label>Watcher Emails (comma-separated)</label>
                    <form:textarea path="globalWatcherEmails" rows="2" />
                </div>
                <div class="form-group">
                    <label>Watcher Enabled</label>
                    <div class="radio-group">
                        <label><form:radiobutton path="globalWatcherEnabled" value="true" /> Yes — Send all notifications</label>
                        <label><form:radiobutton path="globalWatcherEnabled" value="false" /> No — Disabled</label>
                    </div>
                </div>
            </div>
        </div>

        <%-- ===== SOCIAL MEDIA ===== --%>
        <div class="settings-section">
            <div class="section-title">📱 Social Media Links</div>
            <div class="form-grid">
                <div class="form-group">
                    <label>Facebook</label>
                    <form:input path="facebookLink" />
                </div>
                <div class="form-group">
                    <label>Instagram</label>
                    <form:input path="instagramLink" />
                </div>
                <div class="form-group">
                    <label>LinkedIn</label>
                    <form:input path="linkedinLink" />
                </div>
                <div class="form-group">
                    <label>YouTube</label>
                    <form:input path="youtubeLink" />
                </div>
                <div class="form-group">
                    <label>X / Twitter</label>
                    <form:input path="xLink" />
                </div>
            </div>
        </div>

        <%-- ===== WHATSAPP SETTINGS ===== --%>
        <div class="settings-section">
            <div class="section-title">💬 WhatsApp API Settings</div>
            <div class="form-grid-2">
                <div class="form-group">
                    <label>API URL</label>
                    <form:input path="whatsAppApiUrl" />
                </div>
                <div class="form-group">
                    <label>API Key</label>
                    <form:input path="whatsAppApiKey" />
                </div>
                <div class="form-group">
                    <label>Registration Template ID</label>
                    <form:input path="whatsAppRegistrationTemplateId" />
                </div>
                <div class="form-group">
                    <label>Stay Quotation Template ID</label>
                    <form:input path="whatsAppStayQuotationTemplateId" />
                </div>
                <div class="form-group">
                    <label>Guest Quotation Template ID</label>
                    <form:input path="whatsAppGuestQuotationTemplateId" />
                </div>
            </div>
        </div>

        <%-- ===== EMAIL / SMTP SETTINGS ===== --%>
        <div class="settings-section">
            <div class="section-title">📧 Email / SMTP Settings</div>
            <div class="form-grid-2">
                <div class="form-group">
                    <label>SMTP Host</label>
                    <form:input path="emailSmtpHost" />
                </div>
                <div class="form-group">
                    <label>SMTP Port</label>
                    <form:input path="emailSmtpPort" />
                </div>
                <div class="form-group">
                    <label>SMTP Username</label>
                    <form:input path="emailSmtpUsername" />
                </div>
                <div class="form-group">
                    <label>SMTP Password</label>
                    <form:input path="emailSmtpPassword" />
                </div>
                <div class="form-group">
                    <label>From Address</label>
                    <form:input path="emailFromAddress" />
                </div>
                <div class="form-group">
                    <label>Reply-To</label>
                    <form:input path="emailReplyTo" />
                </div>
                <div class="form-group">
                    <label>Default CC</label>
                    <form:input path="emailDefaultCc" />
                </div>
                <div class="form-group">
                    <label>Notify To</label>
                    <form:input path="emailNotifyTo" />
                </div>
                <div class="form-group">
                    <label>Client Email Notifications Active</label>
                    <form:select path="emailClientActive">
                        <form:option value="true">Yes — Enabled</form:option>
                        <form:option value="false">No — Disabled</form:option>
                    </form:select>
                </div>
                <div class="form-group">
                    <label>Internal Email Notifications Active</label>
                    <form:select path="emailInternalActive">
                        <form:option value="true">Yes — Enabled</form:option>
                        <form:option value="false">No — Disabled</form:option>
                    </form:select>
                </div>
            </div>
        </div>

        <%-- ===== QUOTATION CONFIG ===== --%>
        <div class="settings-section">
            <div class="section-title">📄 Quotation Configuration</div>
            <div class="form-grid-2">
                <div class="form-group form-group-full">
                    <label>Quotation Top Cover Text</label>
                    <form:textarea path="quotationTopCover" rows="5" />
                </div>
                <div class="form-group">
                    <label>Inclusions</label>
                    <form:textarea path="inclusions" rows="6" />
                </div>
                <div class="form-group">
                    <label>Terms &amp; Conditions</label>
                    <form:textarea path="tnc" rows="6" />
                </div>
                <div class="form-group">
                    <label>USP (Unique Selling Points)</label>
                    <form:textarea path="usp" rows="6" />
                </div>
                <div class="form-group">
                    <label>Company Info</label>
                    <form:textarea path="companyInfo" rows="6" />
                </div>
            </div>
        </div>

        <%-- ===== SAVE BUTTON ===== --%>
        <div class="save-bar">
            <button type="submit" class="btn-save">💾 Save Configuration</button>
        </div>

    </form:form>
</div>

<script>
    // Live logo preview
    document.getElementById('logoFile').addEventListener('change', function(e) {
        const preview = document.getElementById('logoPreview');
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(ev) {
                preview.src = ev.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            preview.style.display = 'none';
        }
    });
</script>

</body>
</html>
