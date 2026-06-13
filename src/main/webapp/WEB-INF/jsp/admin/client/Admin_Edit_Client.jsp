<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Edit Client</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding:30px; max-width:800px; margin:0 auto;">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;">
        <h2 style="font-size:1.5rem;font-weight:700;color:var(--text-primary);">Edit Client</h2>
        <a href="${pageContext.request.contextPath}/view_clients_list" style="padding:9px 18px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;">← Back</a>
    </div>
    <c:if test="${not empty error}"><div style="background:#fee2e2;color:#991b1b;padding:12px;border-radius:8px;margin-bottom:16px;">${error}</div></c:if>

    <div style="background:rgba(255,255,255,0.88);border-radius:16px;padding:32px;box-shadow:0 4px 24px rgba(0,0,0,0.08);">
        <form action="${pageContext.request.contextPath}/edit_client" method="post">
            <input type="hidden" name="clientId" value="${CLIENT_OBJ.clientId}">

            <div style="font-weight:600;color:var(--accent-primary);margin-bottom:16px;border-bottom:2px solid var(--accent-primary);padding-bottom:8px;">Client Details</div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:20px;">
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Client Name <span style="color:red">*</span></label>
                    <input type="text" name="clientName" value="${CLIENT_OBJ.clientName}" required style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Mobile</label>
                    <input type="text" name="mobile" value="${CLIENT_OBJ.mobile}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Email</label>
                    <input type="email" name="emailId" value="${CLIENT_OBJ.emailId}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Status</label>
                    <select name="clientStatus" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                        <c:forEach var="s" items="${CLIENT_STATUSES}">
                            <option value="${s}" ${CLIENT_OBJ.clientStatus == s ? 'selected' : ''}>${s}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">City</label>
                    <input type="text" name="city" value="${CLIENT_OBJ.city}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Country</label>
                    <input type="text" name="country" value="${CLIENT_OBJ.country}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
            </div>
            <div style="margin-bottom:24px;">
                <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Remarks</label>
                <textarea name="remarks" rows="3" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;resize:vertical;">${CLIENT_OBJ.remarks}</textarea>
            </div>
            <div style="display:flex;gap:12px;justify-content:flex-end;">
                <a href="${pageContext.request.contextPath}/view_clients_list" style="padding:10px 24px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;">Cancel</a>
                <button type="submit" style="padding:10px 28px;background:var(--accent-primary);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;">Update Client</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
