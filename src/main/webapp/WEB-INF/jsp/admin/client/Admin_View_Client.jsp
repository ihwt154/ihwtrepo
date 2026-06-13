<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Client Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding:30px; max-width:800px; margin:0 auto;">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;">
        <h2 style="font-size:1.5rem;font-weight:700;color:var(--text-primary);">Client Details</h2>
        <div style="display:flex;gap:10px;">
            <a href="${pageContext.request.contextPath}/view_edit_client_form?clientId=${CLIENT_OBJ.clientId}" style="padding:9px 18px;background:var(--accent-primary);color:#fff;border-radius:8px;text-decoration:none;font-weight:600;">✏️ Edit</a>
            <a href="${pageContext.request.contextPath}/view_clients_list" style="padding:9px 18px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;">← Back</a>
        </div>
    </div>

    <div style="background:rgba(255,255,255,0.88);border-radius:14px;padding:28px;box-shadow:0 4px 24px rgba(0,0,0,0.08);">
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">
            <div>
                <div style="font-size:0.75rem;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:.06em;margin-bottom:4px;">Client Name</div>
                <div style="font-size:1.1rem;font-weight:700;color:#1e293b;">${CLIENT_OBJ.clientName}</div>
            </div>
            <div>
                <div style="font-size:0.75rem;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:.06em;margin-bottom:4px;">Status</div>
                <c:choose>
                    <c:when test="${CLIENT_OBJ.active}"><span style="background:#d1fae5;color:#065f46;padding:4px 12px;border-radius:20px;font-size:0.82rem;font-weight:600;">Active</span></c:when>
                    <c:otherwise><span style="background:#fee2e2;color:#991b1b;padding:4px 12px;border-radius:20px;font-size:0.82rem;font-weight:600;">Inactive</span></c:otherwise>
                </c:choose>
            </div>
            <div>
                <div style="font-size:0.75rem;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:.06em;margin-bottom:4px;">Mobile</div>
                <div style="font-size:0.95rem;color:#1e293b;">${CLIENT_OBJ.mobile}</div>
            </div>
            <div>
                <div style="font-size:0.75rem;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:.06em;margin-bottom:4px;">Email</div>
                <div style="font-size:0.95rem;color:#1e293b;">${CLIENT_OBJ.emailId}</div>
            </div>
            <div>
                <div style="font-size:0.75rem;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:.06em;margin-bottom:4px;">City</div>
                <div style="font-size:0.95rem;color:#1e293b;">${CLIENT_OBJ.city}</div>
            </div>
            <div>
                <div style="font-size:0.75rem;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:.06em;margin-bottom:4px;">Country</div>
                <div style="font-size:0.95rem;color:#1e293b;">${CLIENT_OBJ.country}</div>
            </div>
            <div style="grid-column:1/-1;">
                <div style="font-size:0.75rem;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:.06em;margin-bottom:4px;">Remarks</div>
                <div style="font-size:0.9rem;color:#475569;line-height:1.6;">${empty CLIENT_OBJ.remarks ? 'No remarks.' : CLIENT_OBJ.remarks}</div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
