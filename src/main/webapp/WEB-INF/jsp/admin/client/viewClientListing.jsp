<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Manage Clients</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .client-table { width:100%; border-collapse:collapse; }
        .client-table th { background:var(--accent-primary); color:#fff; padding:12px 16px; text-align:left; font-size:0.8rem; text-transform:uppercase; letter-spacing:.05em; }
        .client-table td { padding:12px 16px; border-bottom:1px solid #f1f5f9; font-size:0.9rem; }
        .client-table tr:hover td { background:#f8fafc; }
        .badge-active { background:#d1fae5; color:#065f46; padding:3px 10px; border-radius:20px; font-size:0.75rem; font-weight:600; }
        .badge-inactive { background:#fee2e2; color:#991b1b; padding:3px 10px; border-radius:20px; font-size:0.75rem; font-weight:600; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding:30px;">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
        <h2 style="font-size:1.5rem;font-weight:700;color:var(--text-primary);">Manage Clients</h2>
        <a href="${pageContext.request.contextPath}/view_add_client_form" style="padding:10px 20px;background:var(--accent-primary);color:#fff;border-radius:8px;text-decoration:none;font-weight:600;">+ Add Client</a>
    </div>

    <c:if test="${not empty success}"><div style="background:#d1fae5;color:#065f46;padding:12px;border-radius:8px;margin-bottom:16px;">${success}</div></c:if>
    <c:if test="${not empty error}"><div style="background:#fee2e2;color:#991b1b;padding:12px;border-radius:8px;margin-bottom:16px;">${error}</div></c:if>

    <%-- Filter Form --%>
    <div style="background:rgba(255,255,255,0.85);border-radius:14px;padding:20px 24px;box-shadow:0 2px 12px rgba(0,0,0,0.06);margin-bottom:20px;">
        <form method="get" action="${pageContext.request.contextPath}/view_clients_list" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:12px;align-items:end;">
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Client Name</label>
                <input type="text" name="clientName" value="${f_clientName}" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
            </div>
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">City</label>
                <input type="text" name="city" value="${f_city}" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
            </div>
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Status</label>
                <select name="active" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
                    <option value="">All</option>
                    <option value="true" ${f_active == true ? 'selected' : ''}>Active</option>
                    <option value="false" ${f_active == false ? 'selected' : ''}>Inactive</option>
                </select>
            </div>
            <div style="display:flex;gap:8px;">
                <button type="submit" style="padding:8px 16px;background:var(--accent-primary);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;flex:1;">Filter</button>
                <a href="${pageContext.request.contextPath}/view_clients_list" style="padding:8px 14px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;display:flex;align-items:center;">Reset</a>
            </div>
        </form>
    </div>

    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
        <p style="font-size:0.85rem;color:#64748b;margin:0;">Showing <strong>${CLIENT_LIST.size()}</strong> of <strong>${totalClients}</strong> clients</p>
        <div style="display:flex; gap:8px;">
            <a href="${pageContext.request.contextPath}/clients/export/excel?clientName=${f_clientName}&city=${f_city}&active=${f_active}"
               style="padding:6px 12px;background:#10b981;color:#fff;border-radius:6px;text-decoration:none;font-size:0.8rem;font-weight:600;display:inline-flex;align-items:center;">Export Excel</a>
            <a href="${pageContext.request.contextPath}/clients/export/pdf?clientName=${f_clientName}&city=${f_city}&active=${f_active}"
               style="padding:6px 12px;background:#ef4444;color:#fff;border-radius:6px;text-decoration:none;font-size:0.8rem;font-weight:600;display:inline-flex;align-items:center;">Export PDF</a>
        </div>
    </div>

    <div style="background:rgba(255,255,255,0.85);border-radius:14px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.06);">
        <table class="client-table">
            <thead>
                <tr>
                    <th>#</th><th>Client Name</th><th>Mobile</th><th>Email</th><th>City</th><th>Country</th><th>Status</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty CLIENT_LIST}">
                    <tr><td colspan="8" style="text-align:center;padding:40px;color:#94a3b8;">No clients found. <a href="${pageContext.request.contextPath}/view_add_client_form">Add your first client</a></td></tr>
                </c:if>
                <c:forEach var="client" items="${CLIENT_LIST}" varStatus="st">
                    <tr>
                        <td style="color:#94a3b8;font-size:0.8rem;">${st.index + 1}</td>
                        <td><strong>${client.clientName}</strong></td>
                        <td>${client.mobile}</td>
                        <td>${client.emailId}</td>
                        <td>${client.city}</td>
                        <td>${client.country}</td>
                        <td>
                            <c:choose>
                                <c:when test="${client.active}"><span class="badge-active">Active</span></c:when>
                                <c:otherwise><span class="badge-inactive">Inactive</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div style="display:flex;gap:6px;">
                                <a href="${pageContext.request.contextPath}/view_client_details?clientId=${client.clientId}"
                                   style="padding:5px 12px;background:#f1f5f9;color:#475569;border-radius:6px;text-decoration:none;font-size:0.78rem;font-weight:600;border:1px solid #e2e8f0;">View</a>
                                <a href="${pageContext.request.contextPath}/view_edit_client_form?clientId=${client.clientId}"
                                   style="padding:5px 12px;background:#dbeafe;color:#1d4ed8;border-radius:6px;text-decoration:none;font-size:0.78rem;font-weight:600;border:1px solid #bfdbfe;">Edit</a>
                                <form method="post" action="${pageContext.request.contextPath}/toggle_client" style="display:inline;" onsubmit="return confirm('Toggle client status?');">
                                    <input type="hidden" name="clientId" value="${client.clientId}">
                                    <button type="submit"
                                            style="padding:5px 12px;background:${client.active ? '#fee2e2' : '#d1fae5'};color:${client.active ? '#b91c1c' : '#065f46'};border:1px solid ${client.active ? '#fca5a5' : '#a7f3d0'};border-radius:6px;cursor:pointer;font-size:0.78rem;font-weight:600;">
                                        ${client.active ? 'Deactivate' : 'Activate'}
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <div style="display:flex;gap:8px;margin-top:20px;justify-content:center;">
            <c:if test="${currentPage > 0}"><a href="?page=${currentPage-1}&pageSize=${pageSize}&clientName=${f_clientName}&city=${f_city}&active=${f_active}" style="padding:8px 14px;background:#f1f5f9;border-radius:8px;text-decoration:none;color:#475569;">Prev</a></c:if>
            <c:forEach begin="0" end="${totalPages-1}" var="p">
                <c:choose>
                    <c:when test="${p==currentPage}"><span style="padding:8px 14px;background:var(--accent-primary);color:#fff;border-radius:8px;">${p+1}</span></c:when>
                    <c:otherwise><a href="?page=${p}&pageSize=${pageSize}&clientName=${f_clientName}&city=${f_city}&active=${f_active}" style="padding:8px 14px;background:#f1f5f9;border-radius:8px;text-decoration:none;color:#475569;">${p+1}</a></c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages-1}"><a href="?page=${currentPage+1}&pageSize=${pageSize}&clientName=${f_clientName}&city=${f_city}&active=${f_active}" style="padding:8px 14px;background:#f1f5f9;border-radius:8px;text-decoration:none;color:#475569;">Next</a></c:if>
        </div>
    </c:if>
</div>
</body>
</html>

