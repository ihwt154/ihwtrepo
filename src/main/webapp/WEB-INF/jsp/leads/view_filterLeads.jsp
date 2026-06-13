<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Manage Leads</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .filter-card { background: rgba(255,255,255,0.85); border-radius: 14px; padding: 20px 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-bottom: 20px; }
        .leads-table { width: 100%; border-collapse: collapse; }
        .leads-table th { background: var(--accent-primary); color: #fff; padding: 12px 16px; text-align: left; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.05em; }
        .leads-table td { padding: 12px 16px; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }
        .leads-table tr:hover td { background: #f8fafc; }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-new { background: #dbeafe; color: #1d4ed8; }
        .badge-contacted { background: #fef3c7; color: #d97706; }
        .badge-qualified { background: #d1fae5; color: #065f46; }
        .badge-lost { background: #fee2e2; color: #991b1b; }
        .badge-won { background: #d1fae5; color: #065f46; }
        .badge-proposal { background: #ede9fe; color: #5b21b6; }
        .badge-default { background: #f1f5f9; color: #475569; }
        .pagination { display: flex; gap: 8px; align-items: center; margin-top: 20px; justify-content: center; }
        .pagination a, .pagination span { padding: 8px 14px; border-radius: 8px; text-decoration: none; font-size: 0.85rem; }
        .pagination a { background: #f1f5f9; color: #475569; }
        .pagination .active { background: var(--accent-primary); color: #fff; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding: 30px;">

    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
        <h2 style="color: var(--text-primary); font-size:1.5rem; font-weight:700;">Manage Leads</h2>
        <a href="${pageContext.request.contextPath}/view_add_lead_form" style="padding:10px 20px; background: var(--accent-primary); color:#fff; border-radius:8px; text-decoration:none; font-weight:600;">+ Add New Lead</a>
    </div>

    <c:if test="${not empty success}"><div style="background:#d1fae5;color:#065f46;padding:12px 16px;border-radius:8px;margin-bottom:16px;">${success}</div></c:if>
    <c:if test="${not empty error}"><div style="background:#fee2e2;color:#991b1b;padding:12px 16px;border-radius:8px;margin-bottom:16px;">${error}</div></c:if>

    <%-- Filter Form --%>
    <div class="filter-card">
        <form method="get" action="${pageContext.request.contextPath}/view_filter_leads" style="display:grid; grid-template-columns:repeat(auto-fit, minmax(160px,1fr)); gap:12px; align-items:end;">
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Client Name</label>
                <input type="text" name="clientName" value="${f_clientName}" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
            </div>
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Status</label>
                <select name="leadStatus" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
                    <option value="">All Statuses</option>
                    <c:forEach var="s" items="${LEAD_STATUSES}">
                        <option value="${s}" ${f_leadStatus == s ? 'selected' : ''}>${s}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Source</label>
                <select name="leadSource" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
                    <option value="">All Sources</option>
                    <c:forEach var="src" items="${LEAD_SOURCES}">
                        <option value="${src}" ${f_leadSource == src ? 'selected' : ''}>${src}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Priority</label>
                <select name="priority" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
                    <option value="">All Priorities</option>
                    <c:forEach var="p" items="${PRIORITIES}">
                        <option value="${p}" ${f_priority == p ? 'selected' : ''}>${p}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Assigned To</label>
                <select name="assignedTo" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
                    <option value="">All Users</option>
                    <c:forEach var="entry" items="${ACTIVE_USERS_MAP}">
                        <option value="${entry.key}" ${f_assignedTo == entry.key ? 'selected' : ''}>${entry.value}</option>
                    </c:forEach>
                </select>
            </div>
            <div style="display:flex;gap:8px;">
                <button type="submit" style="padding:8px 16px;background:var(--accent-primary);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;flex:1;">Filter</button>
                <a href="${pageContext.request.contextPath}/view_filter_leads" style="padding:8px 14px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;display:flex;align-items:center;">Reset</a>
            </div>
        </form>
    </div>

    <%-- Results Summary --%>
    <p style="font-size:0.85rem;color:#64748b;margin-bottom:12px;">Showing <strong>${LEADS_LIST.size()}</strong> of <strong>${totalLeads}</strong> leads</p>

    <%-- Table --%>
    <div style="background:rgba(255,255,255,0.85);border-radius:14px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.06);">
        <table class="leads-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Lead Name</th>
                    <th>Client</th>
                    <th>Mobile</th>
                    <th>City</th>
                    <th>Status</th>
                    <th>Priority</th>
                    <th>Assigned To</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty LEADS_LIST}">
                    <tr><td colspan="9" style="text-align:center;padding:40px;color:#94a3b8;">No leads found. <a href="${pageContext.request.contextPath}/view_add_lead_form">Create your first lead â†’</a></td></tr>
                </c:if>
                <c:forEach var="lead" items="${LEADS_LIST}" varStatus="st">
                    <tr>
                        <td style="color:#94a3b8;font-size:0.8rem;">${st.index + 1}</td>
                        <td><strong>${lead.leadName}</strong></td>
                        <td>${lead.clientName}</td>
                        <td>${lead.mobileNumber}</td>
                        <td>${lead.city}</td>
                        <td>
                            <c:choose>
                                <c:when test="${lead.leadStatus == 'NEW'}"><span class="badge badge-new">${lead.leadStatus}</span></c:when>
                                <c:when test="${lead.leadStatus == 'CONTACTED'}"><span class="badge badge-contacted">${lead.leadStatus}</span></c:when>
                                <c:when test="${lead.leadStatus == 'QUALIFIED'}"><span class="badge badge-qualified">${lead.leadStatus}</span></c:when>
                                <c:when test="${lead.leadStatus == 'LOST'}"><span class="badge badge-lost">${lead.leadStatus}</span></c:when>
                                <c:when test="${lead.leadStatus == 'WON'}"><span class="badge badge-won">${lead.leadStatus}</span></c:when>
                                <c:otherwise><span class="badge badge-default">${lead.leadStatus}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${lead.priority}</td>
                        <td>${lead.assignedToName}</td>
                        <td>
                            <div style="display:flex;gap:6px;">
                                <a href="${pageContext.request.contextPath}/view_lead_details?leadId=${lead.leadId}" title="View" style="padding:5px 10px;background:#f1f5f9;border-radius:6px;text-decoration:none;font-size:0.8rem;">ðŸ‘</a>
                                <a href="${pageContext.request.contextPath}/view_edit_lead_form?leadId=${lead.leadId}" title="Edit" style="padding:5px 10px;background:#dbeafe;border-radius:6px;text-decoration:none;font-size:0.8rem;">âœï¸</a>
                                <a href="${pageContext.request.contextPath}/view_lead_followup_details?leadId=${lead.leadId}" title="Followups" style="padding:5px 10px;background:#d1fae5;border-radius:6px;text-decoration:none;font-size:0.8rem;">ðŸ“‹</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <%-- Pagination --%>
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:if test="${currentPage > 0}">
                <a href="?page=${currentPage - 1}&pageSize=${pageSize}&leadStatus=${f_leadStatus}&leadSource=${f_leadSource}&clientName=${f_clientName}&priority=${f_priority}">â† Prev</a>
            </c:if>
            <c:forEach begin="0" end="${totalPages - 1}" var="p">
                <c:choose>
                    <c:when test="${p == currentPage}"><span class="active">${p + 1}</span></c:when>
                    <c:otherwise><a href="?page=${p}&pageSize=${pageSize}&leadStatus=${f_leadStatus}&leadSource=${f_leadSource}&clientName=${f_clientName}&priority=${f_priority}">${p + 1}</a></c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages - 1}">
                <a href="?page=${currentPage + 1}&pageSize=${pageSize}&leadStatus=${f_leadStatus}&leadSource=${f_leadSource}&clientName=${f_clientName}&priority=${f_priority}">Next â†’</a>
            </c:if>
        </div>
    </c:if>
</div>
</body>
</html>

