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
        <a href="${pageContext.request.contextPath}/view_clients_list" style="padding:9px 18px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;">Back</a>
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
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Client Source</label>
                    <select name="clientSource" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                        <option value="">-- Select Source --</option>
                        <c:forEach var="src" items="${CLIENT_SOURCES}">
                            <option value="${src.sourceName}" ${CLIENT_OBJ.clientSource == src.sourceName ? 'selected' : ''}>${src.sourceName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Client Type</label>
                    <select name="clientType" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                        <option value="">-- Select Type --</option>
                        <c:forEach var="tp" items="${CLIENT_TYPES}">
                            <option value="${tp.typeName}" ${CLIENT_OBJ.clientType == tp.typeName ? 'selected' : ''}>${tp.typeName}</option>
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
            <div style="font-weight:600;color:var(--accent-primary);margin-top:24px;margin-bottom:16px;border-bottom:2px solid var(--accent-primary);padding-bottom:8px;">Organization & Additional Details</div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:20px;">
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Organization Name</label>
                    <input type="text" name="organizationName" value="${CLIENT_OBJ.organizationName}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Organization Type</label>
                    <input type="text" name="organizationType" value="${CLIENT_OBJ.organizationType}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Registration Number</label>
                    <input type="text" name="registrationNumber" value="${CLIENT_OBJ.registrationNumber}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Designation</label>
                    <input type="text" name="designation" value="${CLIENT_OBJ.designation}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Website</label>
                    <input type="text" name="website" value="${CLIENT_OBJ.website}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Postal Code</label>
                    <input type="text" name="postalCode" value="${CLIENT_OBJ.postalCode}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div style="grid-column: span 2;">
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Address</label>
                    <textarea name="address" rows="2" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;resize:vertical;">${CLIENT_OBJ.address}</textarea>
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
