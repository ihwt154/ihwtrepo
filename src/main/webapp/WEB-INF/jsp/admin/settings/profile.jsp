<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
                    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>IHWT CRM - Settings</title>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
                        <link
                            href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap"
                            rel="stylesheet">
                        <style>
                            .settings-layout {
                                display: grid;
                                grid-template-columns: 220px 1fr;
                                gap: 24px;
                                max-width: 1100px;
                                margin: 0 auto;
                                padding: 30px;
                            }

                            /* ── Sidebar ──────────────────────────────────────────── */
                            .settings-sidebar {
                                display: flex;
                                flex-direction: column;
                                gap: 4px;
                            }

                            .sidebar-section-label {
                                font-size: 10px;
                                font-weight: 700;
                                letter-spacing: 0.1em;
                                text-transform: uppercase;
                                color: #94a3b8;
                                padding: 14px 12px 6px;
                            }

                            .sidebar-item {
                                display: flex;
                                align-items: center;
                                gap: 10px;
                                padding: 10px 14px;
                                border-radius: 10px;
                                cursor: pointer;
                                font-size: 14px;
                                font-weight: 500;
                                color: #475569;
                                text-decoration: none;
                                transition: all 0.18s ease;
                                border: none;
                                background: none;
                                width: 100%;
                                text-align: left;
                            }

                            .sidebar-item:hover {
                                background: #f1f5f9;
                                color: #1e293b;
                            }

                            .sidebar-item.active {
                                background: #ede9fe;
                                color: #6366f1;
                                font-weight: 700;
                            }

                            .sidebar-item .si-icon {
                                font-size: 16px;
                                width: 20px;
                                text-align: center;
                            }

                            /* ── Tab Panels ───────────────────────────────────────── */
                            .tab-panel {
                                display: none;
                            }

                            .tab-panel.active {
                                display: block;
                            }

                            /* ── Section Card ─────────────────────────────────────── */
                            .s-card {
                                background: rgba(255, 255, 255, 0.95);
                                border-radius: 16px;
                                padding: 28px 30px;
                                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.07);
                                margin-bottom: 22px;
                            }

                            .s-card-title {
                                font-size: 1rem;
                                font-weight: 700;
                                color: #1e293b;
                                margin-bottom: 4px;
                            }

                            .s-card-sub {
                                font-size: 13px;
                                color: #94a3b8;
                                margin-bottom: 22px;
                            }

                            .s-divider {
                                border: none;
                                border-top: 1px solid #f1f5f9;
                                margin: 20px 0;
                            }

                            /* ── Avatar ───────────────────────────────────────────── */
                            .profile-avatar-lg {
                                width: 80px;
                                height: 80px;
                                border-radius: 50%;
                                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 32px;
                                font-weight: 700;
                                color: #fff;
                                margin-bottom: 16px;
                                box-shadow: 0 6px 20px rgba(99, 102, 241, 0.3);
                            }

                            /* ── Form fields ──────────────────────────────────────── */
                            .sf-label {
                                font-size: 12px;
                                font-weight: 700;
                                color: #64748b;
                                text-transform: uppercase;
                                letter-spacing: 0.06em;
                                margin-bottom: 6px;
                                display: block;
                            }

                            .sf-input {
                                width: 100%;
                                padding: 10px 13px;
                                border: 1px solid #e2e8f0;
                                border-radius: 9px;
                                font-size: 14px;
                                color: #1e293b;
                                background: #f8fafc;
                                box-sizing: border-box;
                                transition: border-color 0.2s, box-shadow 0.2s;
                            }

                            .sf-input:focus {
                                outline: none;
                                border-color: #6366f1;
                                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.12);
                                background: #fff;
                            }

                            .sf-input[readonly] {
                                background: #f1f5f9;
                                color: #94a3b8;
                                cursor: not-allowed;
                            }

                            .sf-row {
                                display: grid;
                                grid-template-columns: 1fr 1fr;
                                gap: 16px;
                                margin-bottom: 16px;
                            }

                            .sf-full {
                                margin-bottom: 16px;
                            }

                            /* ── Buttons ──────────────────────────────────────────── */
                            .btn-primary-s {
                                padding: 10px 26px;
                                background: linear-gradient(135deg, #6366f1, #4f46e5);
                                color: #fff;
                                border: none;
                                border-radius: 9px;
                                font-weight: 700;
                                font-size: 14px;
                                cursor: pointer;
                                box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
                                transition: opacity 0.2s;
                            }

                            .btn-primary-s:hover {
                                opacity: 0.88;
                            }

                            .btn-cancel-s {
                                padding: 10px 22px;
                                background: #f1f5f9;
                                color: #475569;
                                border: 1px solid #e2e8f0;
                                border-radius: 9px;
                                font-weight: 600;
                                font-size: 14px;
                                cursor: pointer;
                                text-decoration: none;
                                display: inline-block;
                            }

                            /* ── Info row (read-only profile view) ────────────────── */
                            .info-grid {
                                display: grid;
                                grid-template-columns: 1fr 1fr;
                                gap: 14px 24px;
                            }

                            .profile-table {
                                width: 100%;
                                border-collapse: collapse;
                                margin-top: 16px;
                                border: 1px solid #e2e8f0;
                                border-radius: 12px;
                                overflow: hidden;
                                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                            }

                            .profile-table tr {
                                border-bottom: 1px solid #e2e8f0;
                            }

                            .profile-table tr:last-child {
                                border-bottom: none;
                            }

                            .profile-table td {
                                padding: 12px 18px;
                                font-size: 14px;
                                vertical-align: middle;
                            }

                            .profile-table td.label-col {
                                width: 30%;
                                background-color: #f8fafc;
                                font-weight: 600;
                                color: #475569;
                                border-right: 1px solid #e2e8f0;
                            }

                            .profile-table td.val-col {
                                color: #1e293b;
                                background-color: #fff;
                            }

                            .info-item label {
                                font-size: 11px;
                                font-weight: 700;
                                letter-spacing: 0.06em;
                                text-transform: uppercase;
                                color: #94a3b8;
                                display: block;
                                margin-bottom: 3px;
                            }

                            .info-item span {
                                font-size: 14px;
                                color: #1e293b;
                                font-weight: 500;
                            }

                            /* ── Alert banners ────────────────────────────────────── */
                            .alert-success {
                                background: #d1fae5;
                                color: #065f46;
                                padding: 11px 16px;
                                border-radius: 9px;
                                margin-bottom: 18px;
                                font-size: 14px;
                                font-weight: 500;
                            }

                            .alert-error {
                                background: #fee2e2;
                                color: #991b1b;
                                padding: 11px 16px;
                                border-radius: 9px;
                                margin-bottom: 18px;
                                font-size: 14px;
                                font-weight: 500;
                            }

                            /* ── Permissions table ────────────────────────────────── */
                            .perm-table {
                                width: 100%;
                                border-collapse: collapse;
                            }

                            .perm-table th {
                                background: #6366f1;
                                color: #fff;
                                padding: 11px 16px;
                                text-align: left;
                                font-size: 12px;
                                text-transform: uppercase;
                                letter-spacing: 0.05em;
                            }

                            .perm-table td {
                                padding: 12px 16px;
                                border-bottom: 1px solid #f1f5f9;
                                font-size: 14px;
                                vertical-align: middle;
                            }

                            .perm-table tr:last-child td {
                                border-bottom: none;
                            }

                            .perm-table tr:hover td {
                                background: #f8fafc;
                            }

                            .perm-section-head {
                                font-size: 11px;
                                font-weight: 700;
                                text-transform: uppercase;
                                letter-spacing: 0.08em;
                                color: #6366f1;
                                background: #ede9fe !important;
                                padding: 8px 16px !important;
                            }

                            /* ── Toggle switch ────────────────────────────────────── */
                            .switch {
                                position: relative;
                                display: inline-block;
                                width: 42px;
                                height: 24px;
                            }

                            .switch input {
                                opacity: 0;
                                width: 0;
                                height: 0;
                            }

                            .switch .slider {
                                position: absolute;
                                cursor: pointer;
                                inset: 0;
                                background: #cbd5e1;
                                border-radius: 24px;
                                transition: .3s;
                            }

                            .switch .slider:before {
                                content: "";
                                position: absolute;
                                height: 18px;
                                width: 18px;
                                left: 3px;
                                bottom: 3px;
                                background: white;
                                border-radius: 50%;
                                transition: .3s;
                            }

                            .switch input:checked+.slider {
                                background: #6366f1;
                            }

                            .switch input:checked+.slider:before {
                                transform: translateX(18px);
                            }

                            /* ── Central Config Styles ────────────────────────────── */
                            .settings-section {
                                background: rgba(255, 255, 255, 0.85);
                                border: 1px solid #e2e8f0;
                                border-radius: 12px;
                                padding: 24px;
                                margin-bottom: 24px;
                            }

                            .section-title {
                                font-size: 0.9rem;
                                font-weight: 700;
                                color: #6366f1;
                                text-transform: uppercase;
                                letter-spacing: 0.06em;
                                margin-bottom: 20px;
                                padding-bottom: 8px;
                                border-bottom: 2px solid #ede9fe;
                                display: flex;
                                align-items: center;
                                gap: 8px;
                            }

                            .form-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
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
                                font-size: 11px;
                                font-weight: 700;
                                color: #64748b;
                                text-transform: uppercase;
                                letter-spacing: 0.04em;
                                display: block;
                                margin-bottom: 3px;
                            }

                            .form-group input,
                            .form-group select,
                            .form-group textarea {
                                width: 100%;
                                padding: 9px 12px;
                                border: 1px solid #e2e8f0;
                                border-radius: 8px;
                                font-size: 14px;
                                background: #f8fafc;
                                color: #1e293b;
                                transition: all 0.2s;
                                outline: none;
                                box-sizing: border-box;
                            }

                            .form-group input:focus,
                            .form-group select:focus,
                            .form-group textarea:focus {
                                border-color: #6366f1;
                                background: #fff;
                                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
                            }

                            .form-group textarea {
                                resize: vertical;
                                min-height: 80px;
                            }

                            .form-group-full {
                                grid-column: 1 / -1;
                            }

                            .radio-group {
                                display: flex;
                                gap: 20px;
                                align-items: center;
                                padding: 8px 0;
                            }

                            .radio-group label {
                                display: flex;
                                align-items: center;
                                gap: 6px;
                                font-size: 13px;
                                font-weight: 500;
                                color: #1e293b;
                                cursor: pointer;
                                text-transform: none;
                                letter-spacing: 0;
                            }

                            .radio-group input[type="radio"] {
                                width: auto;
                                accent-color: #6366f1;
                            }

                            .logo-preview {
                                margin-top: 10px;
                                max-height: 50px;
                                border-radius: 6px;
                                border: 1px solid #e2e8f0;
                            }

                            /* ── Permission modal ─────────────────────────────────── */
                            .perm-overlay {
                                display: none;
                                position: fixed;
                                inset: 0;
                                background: rgba(15, 23, 42, 0.55);
                                backdrop-filter: blur(4px);
                                z-index: 2000;
                                justify-content: center;
                                align-items: center;
                            }

                            .perm-overlay.open {
                                display: flex;
                            }

                            .perm-box {
                                background: #fff;
                                border-radius: 18px;
                                padding: 32px;
                                width: 480px;
                                max-width: 94%;
                                max-height: 88vh;
                                overflow-y: auto;
                                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
                                animation: popIn .2s ease;
                            }

                            @keyframes popIn {
                                from {
                                    transform: scale(.93);
                                    opacity: 0
                                }

                                to {
                                    transform: scale(1);
                                    opacity: 1
                                }
                            }

                            .perm-box h3 {
                                font-size: 1.1rem;
                                font-weight: 700;
                                color: #1e293b;
                                margin-bottom: 4px;
                            }

                            .perm-box .perm-user-label {
                                font-size: 13px;
                                color: #6366f1;
                                font-weight: 600;
                                margin-bottom: 20px;
                            }

                            .perm-group-title {
                                font-size: 11px;
                                font-weight: 700;
                                text-transform: uppercase;
                                letter-spacing: 0.07em;
                                color: #6366f1;
                                margin: 18px 0 10px;
                            }

                            .perm-check-row {
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                                padding: 9px 0;
                                border-bottom: 1px solid #f1f5f9;
                            }

                            .perm-check-row:last-child {
                                border-bottom: none;
                            }

                            .perm-check-label {
                                font-size: 14px;
                                color: #1e293b;
                                font-weight: 500;
                            }

                            .perm-check-desc {
                                font-size: 12px;
                                color: #94a3b8;
                                margin-top: 2px;
                            }
                        </style>
                    </head>

                    <body>
                        <jsp:include page="/WEB-INF/jsp/header.jsp" />

                        <div class="settings-layout">
                            <!-- ── Sidebar ─────────────────────────────────────────────── -->
                            <aside class="settings-sidebar">
                                <div class="sidebar-section-label">Account</div>
                                <button class="sidebar-item active" id="tab-profile-btn" onclick="showTab('profile')">
                                    <span class="si-icon">👤</span> My Profile
                                </button>
                                <c:if test="${CURRENT_USER.hasRole('ADMIN') || CURRENT_USER.hasRole('SUPERADMIN')}">
                                    <button class="sidebar-item" id="tab-config-btn" onclick="showTab('config')">
                                        <span class="si-icon">⚙️</span> Central Config
                                    </button>
                                </c:if>
                                <button class="sidebar-item" id="tab-password-btn" onclick="showTab('password')">
                                    <span class="si-icon">🔑</span> Change Password
                                </button>

                                <c:if test="${CURRENT_USER.hasRole('ADMIN') || CURRENT_USER.hasRole('SUPERADMIN')}">
                                    <div class="sidebar-section-label" style="margin-top:12px;">Administration</div>
                                    <button class="sidebar-item" id="tab-permissions-btn" onclick="showTab('permissions')">
                                        <span class="si-icon">🛡️</span> Permissions
                                    </button>
                                </c:if>
                            </aside>

                            <!-- ── Content Panels ──────────────────────────────────────── -->
                            <div class="settings-content">

                                <%-- ── PROFILE PANEL ────────────────────────────────── --%>
                                    <div id="tab-profile" class="tab-panel active">

                                        <c:if test="${not empty profileSuccess}">
                                            <div class="alert-success">✅ ${profileSuccess}</div>
                                        </c:if>
                                        <c:if test="${not empty profileError}">
                                            <div class="alert-error">⚠️ ${profileError}</div>
                                        </c:if>

                                        <%-- Profile Info Card --%>
                                            <div class="s-card">
                                                <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 24px;">
                                                    <div class="profile-avatar-lg" style="margin-bottom: 0;">
                                                        ${fn:toUpperCase(fn:substring(CURRENT_USER.username, 0, 1))}
                                                    </div>
                                                    <div>
                                                        <div class="s-card-title" style="font-size: 1.25rem; margin-bottom: 2px;">${CURRENT_USER.firstName} ${CURRENT_USER.lastName}</div>
                                                        <div class="s-card-sub" style="margin-bottom: 0;">@${CURRENT_USER.username} &nbsp;·&nbsp; ${CURRENT_USER.email}</div>
                                                    </div>
                                                </div>

                                                <div style="font-size: 1.1rem; font-weight: 700; color: #1e293b; border-bottom: 2px solid #ede9fe; padding-bottom: 8px; margin-bottom: 16px;">
                                                    My Profile
                                                </div>

                                                <table class="profile-table">
                                                    <tr>
                                                        <td class="label-col">User Name</td>
                                                        <td class="val-col">${CURRENT_USER.username}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Name</td>
                                                        <td class="val-col">${CURRENT_USER.firstName} ${CURRENT_USER.lastName}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Designation</td>
                                                        <td class="val-col">${CURRENT_USER.designation}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Company Email</td>
                                                        <td class="val-col">${CURRENT_USER.companyEmail}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Company Mobile</td>
                                                        <td class="val-col">${CURRENT_USER.companyMobile}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Personal Email</td>
                                                        <td class="val-col">${CURRENT_USER.personalEmail}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Mobile</td>
                                                        <td class="val-col">${CURRENT_USER.mobile}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Date of Birth</td>
                                                        <td class="val-col">${CURRENT_USER.formattedDob}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Date of Joining</td>
                                                        <td class="val-col">${CURRENT_USER.formattedDoj}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Last Working Day</td>
                                                        <td class="val-col">${CURRENT_USER.formattedLastWorkingDay}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Account Lock</td>
                                                        <td class="val-col">${CURRENT_USER.accountLock ? 'Yes' : 'No'}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">System User</td>
                                                        <td class="val-col">${CURRENT_USER.systemUser}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Address</td>
                                                        <td class="val-col">${CURRENT_USER.address}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label-col">Remarks</td>
                                                        <td class="val-col"><c:out value="${CURRENT_USER.remarks}"/></td>
                                                    </tr>
                                                </table>
                                            </div>

                                            <%-- Edit Profile Form --%>
                                                <div class="s-card">
                                                    <div class="s-card-title">Edit Profile</div>
                                                    <c:set var="isSystemOwner" value="false" />
                                                    <c:choose>
                                                        <c:when test="${CURRENT_USER.hasRole('SUPERADMIN')}">
                                                            <div class="s-card-sub" style="color: #64748b;">✏️ You are editing your Super Admin profile details (roles are locked).</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="s-card-sub">Update your profile details and contact information.</div>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <form
                                                        action="${pageContext.request.contextPath}/settings/update-profile"
                                                        method="post">
                                                        <div class="sf-row">
                                                            <div>
                                                                <label class="sf-label">First Name</label>
                                                                <input type="text" name="firstName" class="sf-input"
                                                                    value="${CURRENT_USER.firstName}" required ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                            <div>
                                                                <label class="sf-label">Last Name</label>
                                                                <input type="text" name="lastName" class="sf-input"
                                                                    value="${CURRENT_USER.lastName}" required ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                        </div>
                                                        <div class="sf-row">
                                                            <div>
                                                                <label class="sf-label">Username</label>
                                                                <input type="text" class="sf-input"
                                                                    value="${CURRENT_USER.username}" readonly>
                                                            </div>
                                                            <div>
                                                                <label class="sf-label">Designation</label>
                                                                <input type="text" name="designation" class="sf-input"
                                                                    value="${CURRENT_USER.designation}" ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                        </div>
                                                        <div class="sf-row">
                                                            <div>
                                                                <label class="sf-label">Company Email</label>
                                                                <input type="text" name="companyEmail" class="sf-input"
                                                                    value="${CURRENT_USER.companyEmail}" ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                            <div>
                                                                <label class="sf-label">Company Mobile</label>
                                                                <input type="text" name="companyMobile" class="sf-input"
                                                                    value="${CURRENT_USER.companyMobile}" ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                        </div>
                                                        <div class="sf-row">
                                                            <div>
                                                                <label class="sf-label">Personal Email (Login Email)</label>
                                                                <input type="email" name="email" class="sf-input"
                                                                    value="${CURRENT_USER.email}" required ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                            <div>
                                                                <label class="sf-label">Alternative Personal Email</label>
                                                                <input type="email" name="personalEmail" class="sf-input"
                                                                    value="${CURRENT_USER.personalEmail}" ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                        </div>
                                                        <div class="sf-row">
                                                            <div>
                                                                <label class="sf-label">Mobile</label>
                                                                <input type="text" name="mobile" class="sf-input"
                                                                    value="${CURRENT_USER.mobile}" ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                            <div>
                                                                <label class="sf-label">System User Status</label>
                                                                <input type="text" name="systemUser" class="sf-input"
                                                                    value="${CURRENT_USER.systemUser}" ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                        </div>
                                                        <div class="sf-row">
                                                            <div>
                                                                <label class="sf-label">Date of Birth</label>
                                                                <input type="date" name="dob" class="sf-input"
                                                                    value="${CURRENT_USER.htmlDob}" ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                            <div>
                                                                <label class="sf-label">Date of Joining</label>
                                                                <input type="date" name="doj" class="sf-input"
                                                                    value="${CURRENT_USER.htmlDoj}" ${isSystemOwner ? 'disabled' : ''}>
                                                            </div>
                                                        </div>
                                                        <div class="sf-full">
                                                            <label class="sf-label">Address</label>
                                                            <textarea name="address" class="sf-input" rows="2" ${isSystemOwner ? 'disabled' : ''}>${CURRENT_USER.address}</textarea>
                                                        </div>
                                                        <c:if test="${!isSystemOwner}">
                                                            <div style="display:flex; gap:10px; margin-top:8px;">
                                                                <button type="submit" class="btn-primary-s">Save Changes</button>
                                                            </div>
                                                        </c:if>
                                                    </form>
                                                </div>
                                    </div>

                                    <c:if test="${CURRENT_USER.hasRole('ADMIN') || CURRENT_USER.hasRole('SUPERADMIN')}">
                                    <%-- ── CENTRAL CONFIG PANEL ───────────────────────── --%>
                                        <div id="tab-config" class="tab-panel">

                                            <c:if test="${not empty success}">
                                                <div class="alert-success">✅ ${success}</div>
                                                <script>
                                                    if (window.parent && typeof window.parent.updateLogo === 'function') {
                                                        window.parent.updateLogo();
                                                    }
                                                </script>
                                            </c:if>
                                            <c:if test="${not empty error}">
                                                <div class="alert-error">❌ ${error}</div>
                                            </c:if>

                                            <form:form modelAttribute="CENTRAL_CONFIG_OBJ" method="post"
                                                enctype="multipart/form-data"
                                                action="${pageContext.request.contextPath}/create_edit_central_config">

                                                <%--=====ORGANISATION INFO=====--%>
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

                                                    <%--=====ESCALATION & LOGO=====--%>
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
                                                                    <input type="file" id="logoFile" name="logoFile"
                                                                        accept="image/*"
                                                                        style="border:none;padding:4px 0;background:transparent;" />
                                                                    <img id="logoPreview" class="logo-preview"
                                                                        alt="Logo Preview"
                                                                        src="${not empty CENTRAL_CONFIG_OBJ.logoPath ? pageContext.request.contextPath.concat(CENTRAL_CONFIG_OBJ.logoPath) : ''}"
                                                                        style="${not empty CENTRAL_CONFIG_OBJ.logoPath ? 'display:block;' : 'display:none;'}" />
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <%--=====BANK DETAILS=====--%>
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

                                                            <%--=====GLOBAL WATCHER=====--%>
                                                                <div class="settings-section">
                                                                    <div class="section-title">👁 Global Watcher
                                                                        Settings</div>
                                                                    <div class="form-grid-2">
                                                                        <div class="form-group">
                                                                            <label>Watcher Emails
                                                                                (comma-separated)</label>
                                                                            <form:textarea path="globalWatcherEmails"
                                                                                rows="2" />
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label>Watcher Enabled</label>
                                                                            <div class="radio-group">
                                                                                <label>
                                                                                    <form:radiobutton
                                                                                        path="globalWatcherEnabled"
                                                                                        value="true" /> Yes — Send all
                                                                                    notifications
                                                                                </label>
                                                                                <label>
                                                                                    <form:radiobutton
                                                                                        path="globalWatcherEnabled"
                                                                                        value="false" /> No — Disabled
                                                                                </label>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <%--=====SOCIAL MEDIA=====--%>
                                                                    <div class="settings-section">
                                                                        <div class="section-title">📱 Social Media Links
                                                                        </div>
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

                                                                    <%--=====WHATSAPP SETTINGS=====--%>
                                                                        <div class="settings-section">
                                                                            <div class="section-title">💬 WhatsApp API
                                                                                Settings</div>
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
                                                                                    <label>Registration Template
                                                                                        ID</label>
                                                                                    <form:input
                                                                                        path="whatsAppRegistrationTemplateId" />
                                                                                </div>
                                                                                <div class="form-group">
                                                                                    <label>Stay Quotation Template
                                                                                        ID</label>
                                                                                    <form:input
                                                                                        path="whatsAppStayQuotationTemplateId" />
                                                                                </div>
                                                                                <div class="form-group">
                                                                                    <label>Guest Quotation Template
                                                                                        ID</label>
                                                                                    <form:input
                                                                                        path="whatsAppGuestQuotationTemplateId" />
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <%--=====EMAIL / SMTP SETTINGS=====--%>
                                                                            <div class="settings-section">
                                                                                <div class="section-title">📧 Email /
                                                                                    SMTP Settings</div>
                                                                                <div class="form-grid-2">
                                                                                    <div class="form-group">
                                                                                        <label>SMTP Host</label>
                                                                                        <form:input
                                                                                            path="emailSmtpHost" />
                                                                                    </div>
                                                                                    <div class="form-group">
                                                                                        <label>SMTP Port</label>
                                                                                        <form:input
                                                                                            path="emailSmtpPort" />
                                                                                    </div>
                                                                                    <div class="form-group">
                                                                                        <label>SMTP Username</label>
                                                                                        <form:input
                                                                                            path="emailSmtpUsername" />
                                                                                    </div>
                                                                                    <div class="form-group">
                                                                                        <label>SMTP Password</label>
                                                                                        <form:input
                                                                                            path="emailSmtpPassword" />
                                                                                    </div>
                                                                                    <div class="form-group">
                                                                                        <label>From Address</label>
                                                                                        <form:input
                                                                                            path="emailFromAddress" />
                                                                                    </div>
                                                                                    <div class="form-group">
                                                                                        <label>Reply-To</label>
                                                                                        <form:input
                                                                                            path="emailReplyTo" />
                                                                                    </div>
                                                                                    <div class="form-group">
                                                                                        <label>Default CC</label>
                                                                                        <form:input
                                                                                            path="emailDefaultCc" />
                                                                                    </div>
                                                                                    <div class="form-group">
                                                                                        <label>Notify To</label>
                                                                                        <form:input
                                                                                            path="emailNotifyTo" />
                                                                                    </div>
                                                                                    <div class="form-group">
                                                                                        <label>Client Email
                                                                                            Notifications Active</label>
                                                                                        <form:select
                                                                                            path="emailClientActive">
                                                                                            <form:option value="true">
                                                                                                Yes — Enabled
                                                                                            </form:option>
                                                                                            <form:option value="false">
                                                                                                No — Disabled
                                                                                            </form:option>
                                                                                        </form:select>
                                                                                    </div>
                                                                                    <div class="form-group">
                                                                                        <label>Internal Email
                                                                                            Notifications Active</label>
                                                                                        <form:select
                                                                                            path="emailInternalActive">
                                                                                            <form:option value="true">
                                                                                                Yes — Enabled
                                                                                            </form:option>
                                                                                            <form:option value="false">
                                                                                                No — Disabled
                                                                                            </form:option>
                                                                                        </form:select>
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <div
                                                                                style="display:flex; justify-content:flex-end; padding-top:8px;">
                                                                                <button type="submit"
                                                                                    class="btn-primary-s">💾 Save
                                                                                    Configuration</button>
                                                                            </div>
                                            </form:form>
                                        </div>
                                    </c:if>

                                        <%-- ── CHANGE PASSWORD PANEL ─────────────────────── --%>
                                            <div id="tab-password" class="tab-panel">

                                                <c:if test="${not empty pwdSuccess}">
                                                    <div class="alert-success">✅ ${pwdSuccess}</div>
                                                </c:if>
                                                <c:if test="${not empty pwdError}">
                                                    <div class="alert-error">⚠️ ${pwdError}</div>
                                                </c:if>

                                                <div class="s-card">
                                                    <div class="s-card-title">Change Password</div>
                                                    <div class="s-card-sub">Enter your current password, then set a new
                                                        one (minimum 6 characters).</div>

                                                    <form
                                                        action="${pageContext.request.contextPath}/settings/change-password"
                                                        method="post" id="pwdForm">
                                                        <div class="sf-full">
                                                            <label class="sf-label">Current Password</label>
                                                            <input type="password" name="currentPassword"
                                                                id="currentPassword" class="sf-input" required
                                                                autocomplete="current-password">
                                                        </div>
                                                        <hr class="s-divider">
                                                        <div class="sf-row">
                                                            <div>
                                                                <label class="sf-label">New Password</label>
                                                                <input type="password" name="newPassword"
                                                                    id="newPassword" class="sf-input" required
                                                                    autocomplete="new-password" minlength="6">
                                                            </div>
                                                            <div>
                                                                <label class="sf-label">Confirm New Password</label>
                                                                <input type="password" name="confirmPassword"
                                                                    id="confirmPassword" class="sf-input" required
                                                                    autocomplete="new-password" minlength="6">
                                                            </div>
                                                        </div>
                                                        <div id="pwdMatchMsg"
                                                            style="font-size:12px; margin-bottom:12px; color:#ef4444; display:none;">
                                                            Passwords do not match.</div>
                                                        <div style="display:flex; gap:10px; margin-top:8px;">
                                                            <button type="submit" class="btn-primary-s">Update
                                                                Password</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>

                                            <c:if test="${CURRENT_USER.hasRole('ADMIN') || CURRENT_USER.hasRole('SUPERADMIN')}">
                                            <%-- ── PERMISSIONS PANEL ─────────────────────────── --%>
                                                <div id="tab-permissions" class="tab-panel">

                                                    <c:if test="${not empty permSuccess}">
                                                        <div class="alert-success">✅ ${permSuccess}</div>
                                                    </c:if>

                                                    <div class="s-card">
                                                        <div class="s-card-title">User Permissions</div>
                                                        <div class="s-card-sub">Assign module access permissions per
                                                            user. Click the shield icon to edit.</div>

                                                        <div
                                                            style="overflow:hidden; border-radius:12px; border:1px solid #f1f5f9;">
                                                            <table class="perm-table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>User</th>
                                                                        <th>Email</th>
                                                                        <th>Lead Access</th>
                                                                        <th>Client Access</th>
                                                                        <th>User Mgmt</th>
                                                                        <th>Actions</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="u" items="${ALL_USERS}">
                                                                        <tr>
                                                                            <td>
                                                                                <div
                                                                                    style="font-weight:600; color:#1e293b;">
                                                                                    ${u.firstName} ${u.lastName}</div>
                                                                                <div
                                                                                    style="font-size:12px; color:#94a3b8;">
                                                                                    @${u.username}</div>
                                                                            </td>
                                                                            <td style="font-size:13px;">${u.email}</td>

                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${u.hasRole('LEADS_MANAGE') || u.hasRole('LEADS_CREATE') || u.hasRole('ROLE_ADMIN')}">
                                                                                        <span
                                                                                            style="color:#6366f1;font-weight:700;font-size:13px;">✓</span>
                                                                                        <span
                                                                                            style="font-size:11px;color:#64748b;display:block;">
                                                                                            (<c:if
                                                                                                test="${u.hasRole('LEADS_CREATE') || u.hasRole('ROLE_ADMIN')}">
                                                                                                Add</c:if>
                                                                                            <c:if
                                                                                                test="${(u.hasRole('LEADS_CREATE') || u.hasRole('ROLE_ADMIN')) && (u.hasRole('LEADS_MANAGE') || u.hasRole('ROLE_ADMIN'))}">
                                                                                                /</c:if>
                                                                                            <c:if
                                                                                                test="${u.hasRole('LEADS_MANAGE') || u.hasRole('ROLE_ADMIN')}">
                                                                                                Manage</c:if>)
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <c:otherwise><span
                                                                                            style="color:#cbd5e1;font-size:13px;">—</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${u.hasRole('CLIENT_MANAGE') || u.hasRole('CLIENT_CREATE') || u.hasRole('ROLE_ADMIN')}">
                                                                                        <span
                                                                                            style="color:#6366f1;font-weight:700;font-size:13px;">✓</span>
                                                                                        <span
                                                                                            style="font-size:11px;color:#64748b;display:block;">
                                                                                            (<c:if
                                                                                                test="${u.hasRole('CLIENT_CREATE') || u.hasRole('ROLE_ADMIN')}">
                                                                                                Add</c:if>
                                                                                            <c:if
                                                                                                test="${(u.hasRole('CLIENT_CREATE') || u.hasRole('ROLE_ADMIN')) && (u.hasRole('CLIENT_MANAGE') || u.hasRole('ROLE_ADMIN'))}">
                                                                                                /</c:if>
                                                                                            <c:if
                                                                                                test="${u.hasRole('CLIENT_MANAGE') || u.hasRole('ROLE_ADMIN')}">
                                                                                                Manage</c:if>)
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <c:otherwise><span
                                                                                            style="color:#cbd5e1;font-size:13px;">—</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${u.hasRole('USER_MANAGE') || u.hasRole('ROLE_ADMIN')}">
                                                                                        <span
                                                                                            style="color:#6366f1;font-weight:700;font-size:13px;">✓</span>
                                                                                    </c:when>
                                                                                    <c:otherwise><span
                                                                                            style="color:#cbd5e1;font-size:13px;">—</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when test="${u.hasRole('SUPERADMIN')}">
                                                                                        <button type="button" disabled
                                                                                            style="padding:5px 12px;background:#cbd5e1;color:#64748b;border:1px solid #cbd5e1;border-radius:7px;cursor:not-allowed;font-size:12px;font-weight:700;">
                                                                                            🔒 Locked
                                                                                        </button>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <button type="button"
                                                                                            onclick="openPermModal(${u.id}, '${u.username}', '${u.firstName} ${u.lastName}', '${u.rolesListString}')"
                                                                                            style="padding:5px 12px;background:#ede9fe;color:#6366f1;border:1px solid #c4b5fd;border-radius:7px;cursor:pointer;font-size:12px;font-weight:700;">
                                                                                            🛡️ Permissions
                                                                                        </button>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>

                            </div><!-- /settings-content -->
                        </div><!-- /settings-layout -->

                        <!-- ── Permissions Modal ────────────────────────────────────────── -->
                        <div id="permOverlay" class="perm-overlay">
                            <div class="perm-box">
                                <h3>Manage Permissions</h3>
                                <div class="perm-user-label" id="permUserLabel">@username</div>

                                <form action="${pageContext.request.contextPath}/settings/save-permissions"
                                    method="post" id="permForm">
                                    <input type="hidden" name="userId" id="permUserId">


                                    <div class="perm-group-title">🗂️ Lead Management</div>
                                    <div class="perm-check-row">
                                        <div>
                                            <div class="perm-check-label">Add Lead</div>
                                            <div class="perm-check-desc">Permission to register/add new leads</div>
                                        </div>
                                        <label class="switch">
                                            <input type="checkbox" name="roles" value="LEADS_CREATE"
                                                id="perm_LEADS_CREATE">
                                            <span class="slider"></span>
                                        </label>
                                    </div>
                                    <div class="perm-check-row">
                                        <div>
                                            <div class="perm-check-label">Manage Leads</div>
                                            <div class="perm-check-desc">View, filter, and edit existing leads</div>
                                        </div>
                                        <label class="switch">
                                            <input type="checkbox" name="roles" value="LEADS_MANAGE"
                                                id="perm_LEADS_MANAGE">
                                            <span class="slider"></span>
                                        </label>
                                    </div>

                                    <div class="perm-group-title">👥 Client Management</div>
                                    <div class="perm-check-row">
                                        <div>
                                            <div class="perm-check-label">Add Client</div>
                                            <div class="perm-check-desc">Create/register new client records</div>
                                        </div>
                                        <label class="switch">
                                            <input type="checkbox" name="roles" value="CLIENT_CREATE"
                                                id="perm_CLIENT_CREATE">
                                            <span class="slider"></span>
                                        </label>
                                    </div>
                                    <div class="perm-check-row">
                                        <div>
                                            <div class="perm-check-label">Manage Clients</div>
                                            <div class="perm-check-desc">View, update, and edit client settings</div>
                                        </div>
                                        <label class="switch">
                                            <input type="checkbox" name="roles" value="CLIENT_MANAGE"
                                                id="perm_CLIENT_MANAGE">
                                            <span class="slider"></span>
                                        </label>
                                    </div>

                                    <div class="perm-group-title">👤 User Management</div>
                                    <div class="perm-check-row">
                                        <div>
                                            <div class="perm-check-label">Manage Users</div>
                                            <div class="perm-check-desc">Create, edit and deactivate user accounts</div>
                                        </div>
                                        <label class="switch">
                                            <input type="checkbox" name="roles" value="USER_MANAGE"
                                                id="perm_USER_MANAGE">
                                            <span class="slider"></span>
                                        </label>
                                    </div>

                                    <hr class="s-divider">
                                    <div style="display:flex; gap:10px; justify-content:flex-end; margin-top:4px;">
                                        <button type="button" class="btn-cancel-s"
                                            onclick="closePermModal()">Cancel</button>
                                        <button type="submit" class="btn-primary-s">Save Permissions</button>
                                    </div>
                                </form>
                            </div>
                        </c:if>
                        </div>

                        <script>
                            /* ── Tab navigation ──────────────────────────────────── */
                            function showTab(name) {
                                ['profile', 'config', 'password', 'permissions'].forEach(function (t) {
                                    var tab = document.getElementById('tab-' + t);
                                    var btn = document.getElementById('tab-' + t + '-btn');
                                    if (tab) tab.classList.remove('active');
                                    if (btn) btn.classList.remove('active');
                                });
                                var targetTab = document.getElementById('tab-' + name);
                                var targetBtn = document.getElementById('tab-' + name + '-btn');
                                if (targetTab) targetTab.classList.add('active');
                                if (targetBtn) targetBtn.classList.add('active');
                            }

                            /* ── Auto-open tab from flash or query parameter ─────── */
                            (function () {
                                var urlParams = new URLSearchParams(window.location.search);
                                var targetTab = urlParams.get('tab');
                                if (targetTab) {
                                    showTab(targetTab);
                                    return;
                                }
                                var hasPwd = ${ not empty pwdError || not empty pwdSuccess };
                                var hasPerm = ${ not empty permSuccess };
                                var hasConfig = ${ not empty success || not empty error };
                                if (hasPwd) showTab('password');
                                else if (hasPerm) showTab('permissions');
                                else if (hasConfig) showTab('config');
                                else showTab('profile');
                            }) ();

                            /* ── Password match validation ───────────────────────── */
                            var np = document.getElementById('newPassword');
                            var cp = document.getElementById('confirmPassword');
                            if (np && cp) {
                                function checkMatch() {
                                    var msg = document.getElementById('pwdMatchMsg');
                                    if (cp.value && np.value !== cp.value) {
                                        msg.style.display = 'block';
                                    } else {
                                        msg.style.display = 'none';
                                    }
                                }
                                np.addEventListener('input', checkMatch);
                                cp.addEventListener('input', checkMatch);
                                document.getElementById('pwdForm').addEventListener('submit', function (e) {
                                    if (np.value !== cp.value) { e.preventDefault(); }
                                });
                            }

                            /* ── Live logo preview for Central Config ────────────── */
                            var lf = document.getElementById('logoFile');
                            if (lf) {
                                lf.addEventListener('change', function (e) {
                                    const preview = document.getElementById('logoPreview');
                                    const file = e.target.files[0];
                                    if (file) {
                                        const reader = new FileReader();
                                        reader.onload = function (ev) {
                                            preview.src = ev.target.result;
                                            preview.style.display = 'block';
                                        };
                                        reader.readAsDataURL(file);
                                    } else {
                                        preview.style.display = 'none';
                                    }
                                });
                            }

                            /* ── Permissions modal ───────────────────────────────── */
                            var ALL_PERM_KEYS = ['LEADS_CREATE', 'LEADS_MANAGE', 'CLIENT_CREATE', 'CLIENT_MANAGE', 'USER_MANAGE'];

                            function openPermModal(userId, username, fullName, rolesStr) {
                                document.getElementById('permUserId').value = userId;
                                document.getElementById('permUserLabel').textContent = fullName + ' (@' + username + ')';
                                var roles = rolesStr ? rolesStr.split(',') : [];
                                ALL_PERM_KEYS.forEach(function (k) {
                                    var cb = document.getElementById('perm_' + k);
                                    if (cb) cb.checked = roles.indexOf(k) >= 0;
                                });
                                document.getElementById('permOverlay').classList.add('open');
                            }
                            function closePermModal() {
                                document.getElementById('permOverlay').classList.remove('open');
                            }
                            document.getElementById('permOverlay').addEventListener('click', function (e) {
                                if (e.target === this) closePermModal();
                            });
                        </script>

                        <%-- Need fn taglib for substring in avatar --%>
                    </body>

                    </html>