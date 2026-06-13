<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Lead Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding:30px; max-width:900px; margin:0 auto;">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
        <h2 style="font-size:1.5rem; font-weight:700; color:var(--text-primary);">Lead Details</h2>
        <div style="display:flex; gap:10px;">
            <a href="${pageContext.request.contextPath}/view_edit_lead_form?leadId=${LEAD_OBJ.leadId}" style="padding:9px 18px; background:var(--accent-primary); color:#fff; border-radius:8px; text-decoration:none; font-weight:600;">✏️ Edit</a>
            <a href="${pageContext.request.contextPath}/view_lead_followup_details?leadId=${LEAD_OBJ.leadId}" style="padding:9px 18px; background:#d1fae5; color:#065f46; border-radius:8px; text-decoration:none; font-weight:600;">📋 Followups</a>
            <a href="${pageContext.request.contextPath}/view_filter_leads" style="padding:9px 18px; background:#f1f5f9; color:#475569; border-radius:8px; text-decoration:none;">← Back</a>
        </div>
    </div>

    <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
        <%-- Lead Info --%>
        <div style="background:rgba(255,255,255,0.85); border-radius:14px; padding:24px; box-shadow:0 2px 12px rgba(0,0,0,0.06);">
            <h3 style="font-size:1rem; font-weight:700; color:var(--accent-primary); margin-bottom:16px; border-bottom:2px solid var(--accent-primary); padding-bottom:8px;">Lead Information</h3>
            <table style="width:100%; font-size:0.9rem; border-collapse:collapse;">
                <tr><td style="padding:8px 0; color:#64748b; width:45%;">Lead Name</td><td style="font-weight:600;">${LEAD_OBJ.leadName}</td></tr>
                <tr><td style="padding:8px 0; color:#64748b;">Client</td><td><strong>${LEAD_OBJ.clientName}</strong></td></tr>
                <tr><td style="padding:8px 0; color:#64748b;">Email</td><td>${LEAD_OBJ.email}</td></tr>
                <tr><td style="padding:8px 0; color:#64748b;">Mobile</td><td>${LEAD_OBJ.mobileNumber}</td></tr>
                <tr><td style="padding:8px 0; color:#64748b;">City</td><td>${LEAD_OBJ.city}</td></tr>
                <tr><td style="padding:8px 0; color:#64748b;">Country</td><td>${LEAD_OBJ.country}</td></tr>
            </table>
        </div>
        <%-- Classification --%>
        <div style="background:rgba(255,255,255,0.85); border-radius:14px; padding:24px; box-shadow:0 2px 12px rgba(0,0,0,0.06);">
            <h3 style="font-size:1rem; font-weight:700; color:var(--accent-primary); margin-bottom:16px; border-bottom:2px solid var(--accent-primary); padding-bottom:8px;">Classification</h3>
            <table style="width:100%; font-size:0.9rem; border-collapse:collapse;">
                <tr><td style="padding:8px 0; color:#64748b; width:45%;">Status</td><td><span style="background:#dbeafe; color:#1d4ed8; padding:3px 12px; border-radius:20px; font-size:0.8rem; font-weight:600;">${LEAD_OBJ.leadStatus}</span></td></tr>
                <tr><td style="padding:8px 0; color:#64748b;">Source</td><td>${LEAD_OBJ.leadSource}</td></tr>
                <tr><td style="padding:8px 0; color:#64748b;">Priority</td><td>${LEAD_OBJ.priority}</td></tr>
                <tr><td style="padding:8px 0; color:#64748b;">Assigned To</td><td>${LEAD_OBJ.assignedToName}</td></tr>
            </table>
        </div>
        <%-- Remarks --%>
        <div style="grid-column:1/-1; background:rgba(255,255,255,0.85); border-radius:14px; padding:24px; box-shadow:0 2px 12px rgba(0,0,0,0.06);">
            <h3 style="font-size:1rem; font-weight:700; color:var(--accent-primary); margin-bottom:12px; border-bottom:2px solid var(--accent-primary); padding-bottom:8px;">Remarks</h3>
            <p style="color:#475569; line-height:1.6;">${empty LEAD_OBJ.remarks ? 'No remarks added.' : LEAD_OBJ.remarks}</p>
        </div>
    </div>
</div>
</body>
</html>
