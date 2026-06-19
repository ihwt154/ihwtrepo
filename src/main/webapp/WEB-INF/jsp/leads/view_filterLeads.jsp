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

        /* Custom Multiselect Dropdown Styles */
        .multiselect-dropdown {
            position: relative;
            width: 100%;
        }
        .multiselect-select-box {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            background: #ffffff;
            cursor: pointer;
            font-size: 0.9rem;
            user-select: none;
            height: 38px;
        }
        .multiselect-select-box span.arrow {
            font-size: 0.7rem;
            color: #64748b;
            transition: transform 0.2s;
        }
        .multiselect-dropdown.open .multiselect-select-box span.arrow {
            transform: rotate(180deg);
        }
        .multiselect-options-container {
            display: none;
            position: absolute;
            top: 105%;
            left: 0;
            right: 0;
            background: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            max-height: 250px;
            overflow-y: auto;
            z-index: 1000;
            padding: 10px 0;
        }
        .multiselect-group-title {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--accent-primary);
            padding: 6px 14px 4px;
            background: #f8fafc;
        }
        .multiselect-option {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            font-size: 0.85rem;
            color: #334155;
            cursor: pointer;
            transition: background 0.15s;
        }
        .multiselect-option:hover {
            background: #f1f5f9;
        }
        .multiselect-option.indent {
            padding-left: 28px;
        }
        .multiselect-option input[type="checkbox"] {
            cursor: pointer;
            accent-color: var(--accent-primary);
            width: 15px;
            height: 15px;
        }
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
                <div class="multiselect-dropdown" id="status-dropdown-wrapper">
                    <div class="multiselect-select-box" onclick="toggleStatusDropdown(event)">
                        <span id="multiselect-text">All Statuses</span>
                        <span class="arrow">&#9662;</span>
                    </div>
                    <div class="multiselect-options-container" id="status-options">
                        <div class="multiselect-group-title">Open Statuses</div>
                        <label class="multiselect-option">
                            <input type="checkbox" id="cb-status-open-group" name="leadStatus" value="OpenGroup" onchange="toggleGroupCheckboxes('Open', this.checked)" ${f_leadStatus.contains('OpenGroup') ? 'checked' : ''}> Open (Group)
                        </label>
                        <label class="multiselect-option indent">
                            <input type="checkbox" class="status-child-checkbox" id="cb-status-open-ind" name="leadStatus" value="Open" data-label="Open" onchange="updateStatusUI()" ${f_leadStatus.contains('Open') ? 'checked' : ''}> Open
                        </label>
                        <label class="multiselect-option indent">
                            <input type="checkbox" class="status-child-checkbox" id="cb-status-wip" name="leadStatus" value="Work In Progress" data-label="Work In Progress" onchange="updateStatusUI()" ${f_leadStatus.contains('Work In Progress') ? 'checked' : ''}> Work In Progress
                        </label>

                        <div class="multiselect-group-title">Closed Statuses</div>
                        <label class="multiselect-option">
                            <input type="checkbox" id="cb-status-closed-group" name="leadStatus" value="ClosedGroup" onchange="toggleGroupCheckboxes('Closed', this.checked)" ${f_leadStatus.contains('ClosedGroup') ? 'checked' : ''}> Closed (Group)
                        </label>
                        <label class="multiselect-option indent">
                            <input type="checkbox" class="status-child-checkbox" id="cb-status-won" name="leadStatus" value="Won-Converted" data-label="Won-Converted" onchange="updateStatusUI()" ${f_leadStatus.contains('Won-Converted') ? 'checked' : ''}> Won-Converted
                        </label>
                        <label class="multiselect-option indent">
                            <input type="checkbox" class="status-child-checkbox" id="cb-status-lost" name="leadStatus" value="Failed-Closed" data-label="Failed-Closed" onchange="updateStatusUI()" ${f_leadStatus.contains('Failed-Closed') ? 'checked' : ''}> Failed-Closed
                        </label>
                        <label class="multiselect-option indent">
                            <input type="checkbox" class="status-child-checkbox" id="cb-status-dup" name="leadStatus" value="Duplicate" data-label="Duplicate" onchange="updateStatusUI()" ${f_leadStatus.contains('Duplicate') ? 'checked' : ''}> Duplicate
                        </label>
                    </div>
                </div>
            </div>
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Source</label>
                <select name="leadSource" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
                    <option value="">All Sources</option>
                    <c:forEach var="src" items="${CLIENT_SOURCES}">
                        <option value="${src.sourceName}" ${f_leadSource == src.sourceName ? 'selected' : ''}>${src.sourceName}</option>
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
            <c:if test="${CURRENT_USER.hasRole('ADMIN') || CURRENT_USER.hasRole('SUPERADMIN')}">
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Assigned To</label>
                <select name="assignedTo" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
                    <option value="">All Users</option>
                    <c:forEach var="entry" items="${ACTIVE_USERS_MAP}">
                        <option value="${entry.key}" ${f_assignedTo == entry.key ? 'selected' : ''}>${entry.value}</option>
                    </c:forEach>
                </select>
            </div>
            </c:if>
            <div style="display:flex;gap:8px;">
                <button type="submit" style="padding:8px 16px;background:var(--accent-primary);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;flex:1;">Filter</button>
                <a href="${pageContext.request.contextPath}/view_filter_leads" style="padding:8px 14px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;display:flex;align-items:center;">Reset</a>
            </div>
        </form>
    </div>

    <%-- Results Summary --%>
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
        <p style="font-size:0.85rem;color:#64748b;margin:0;">Showing <strong>${LEADS_LIST.size()}</strong> of <strong>${totalLeads}</strong> leads</p>
        <div style="display:flex; gap:8px;">
            <a href="${pageContext.request.contextPath}/leads/export/excel?leadStatus=${f_leadStatusString}&leadSource=${f_leadSource}&clientName=${f_clientName}&assignedTo=${f_assignedTo}&priority=${f_priority}"
               style="padding:6px 12px;background:#10b981;color:#fff;border-radius:6px;text-decoration:none;font-size:0.8rem;font-weight:600;display:inline-flex;align-items:center;">Export Excel</a>
            <a href="${pageContext.request.contextPath}/leads/export/pdf?leadStatus=${f_leadStatusString}&leadSource=${f_leadSource}&clientName=${f_clientName}&assignedTo=${f_assignedTo}&priority=${f_priority}"
               style="padding:6px 12px;background:#ef4444;color:#fff;border-radius:6px;text-decoration:none;font-size:0.8rem;font-weight:600;display:inline-flex;align-items:center;">Export PDF</a>
        </div>
    </div>

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
                    <tr><td colspan="9" style="text-align:center;padding:40px;color:#94a3b8;">No leads found. <a href="${pageContext.request.contextPath}/view_add_lead_form">Create your first lead &rarr;</a></td></tr>
                </c:if>
                <c:forEach var="lead" items="${LEADS_LIST}" varStatus="st">
                    <tr>
                        <td style="color:#94a3b8;font-size:0.8rem;">${st.index + 1}</td>
                        <td>
                            <div style="font-weight:600; color:#1e293b;">${lead.leadName}</div>
                            <c:if test="${not empty lead.leadTitle}">
                                <div style="font-size:0.78rem; color:#64748b; margin-top:2px;">${lead.leadTitle}</div>
                            </c:if>
                        </td>
                        <td>
                            <div>${lead.clientName}</div>
                            <c:if test="${not empty lead.leadSource}">
                                <div style="font-size:0.75rem; color:#8c7ae6; margin-top:2px;">Source: ${lead.leadSource}</div>
                            </c:if>
                            <c:if test="${not empty lead.eventName}">
                                <div style="font-size:0.75rem; color:#0d9488; margin-top:2px;">Event: ${lead.eventName}</div>
                            </c:if>
                        </td>
                        <td>${lead.mobileNumber}</td>
                        <td>${lead.city}</td>
                        <td>
                            <c:choose>
                                <c:when test="${lead.leadStatus == 'Open'}"><span class="badge badge-new">${lead.leadStatus}</span></c:when>
                                <c:when test="${lead.leadStatus == 'Work In Progress'}"><span class="badge badge-contacted">${lead.leadStatus}</span></c:when>
                                <c:when test="${lead.leadStatus == 'Won-Converted'}"><span class="badge badge-won">${lead.leadStatus}</span></c:when>
                                <c:when test="${lead.leadStatus == 'Failed-Closed'}"><span class="badge badge-lost">${lead.leadStatus}</span></c:when>
                                <c:otherwise><span class="badge badge-default">${lead.leadStatus}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${lead.priority}</td>
                        <td>${lead.assignedToName}</td>
                        <td>
                            <div style="display:flex;gap:6px;">
                                <a href="${pageContext.request.contextPath}/view_lead_details?leadId=${lead.leadId}"
                                   style="padding:5px 12px;background:#f1f5f9;color:#475569;border-radius:6px;text-decoration:none;font-size:0.78rem;font-weight:600;border:1px solid #e2e8f0;">View</a>
                                <a href="${pageContext.request.contextPath}/view_edit_lead_form?leadId=${lead.leadId}"
                                   style="padding:5px 12px;background:#dbeafe;color:#1d4ed8;border-radius:6px;text-decoration:none;font-size:0.78rem;font-weight:600;border:1px solid #bfdbfe;">Edit</a>
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
                <a href="?page=${currentPage - 1}&pageSize=${pageSize}&leadStatus=${f_leadStatusString}&leadSource=${f_leadSource}&clientName=${f_clientName}&priority=${f_priority}&assignedTo=${f_assignedTo}">← Prev</a>
            </c:if>
            <c:forEach begin="0" end="${totalPages - 1}" var="p">
                <c:choose>
                    <c:when test="${p == currentPage}"><span class="active">${p + 1}</span></c:when>
                    <c:otherwise><a href="?page=${p}&pageSize=${pageSize}&leadStatus=${f_leadStatusString}&leadSource=${f_leadSource}&clientName=${f_clientName}&priority=${f_priority}&assignedTo=${f_assignedTo}">${p + 1}</a></c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages - 1}">
                <a href="?page=${currentPage + 1}&pageSize=${pageSize}&leadStatus=${f_leadStatusString}&leadSource=${f_leadSource}&clientName=${f_clientName}&priority=${f_priority}&assignedTo=${f_assignedTo}">Next →</a>
            </c:if>
        </div>
    </c:if>
</div>

<script>
    // Toggle dropdown visibility
    function toggleStatusDropdown(event) {
        if (event) event.stopPropagation();
        const dropdown = document.getElementById('status-dropdown-wrapper');
        const container = document.getElementById('status-options');
        dropdown.classList.toggle('open');
        if (dropdown.classList.contains('open')) {
            container.style.display = 'block';
        } else {
            container.style.display = 'none';
        }
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        const wrapper = document.getElementById('status-dropdown-wrapper');
        const container = document.getElementById('status-options');
        if (wrapper && !wrapper.contains(e.target)) {
            wrapper.classList.remove('open');
            if (container) container.style.display = 'none';
        }
    });

    // Update display text and sync checkboxes
    function updateStatusUI() {
        const openGroup = document.getElementById('cb-status-open-group');
        const closedGroup = document.getElementById('cb-status-closed-group');
        
        const openChildren = [
            document.getElementById('cb-status-open-ind'),
            document.getElementById('cb-status-wip')
        ];
        
        const closedChildren = [
            document.getElementById('cb-status-won'),
            document.getElementById('cb-status-lost'),
            document.getElementById('cb-status-dup')
        ];
        
        // Sync open group check state based on children
        const allOpenChecked = openChildren.every(cb => cb.checked);
        const anyOpenChecked = openChildren.some(cb => cb.checked);
        openGroup.checked = allOpenChecked;
        openGroup.indeterminate = anyOpenChecked && !allOpenChecked;
        
        // Sync closed group check state based on children
        const allClosedChecked = closedChildren.every(cb => cb.checked);
        const anyClosedChecked = closedChildren.some(cb => cb.checked);
        closedGroup.checked = allClosedChecked;
        closedGroup.indeterminate = anyClosedChecked && !allClosedChecked;

        // Collect all checked values
        const checkedBoxes = document.querySelectorAll('.status-child-checkbox:checked');
        const textSpan = document.getElementById('multiselect-text');
        
        if (checkedBoxes.length === 0) {
            textSpan.textContent = 'All Statuses';
        } else if (checkedBoxes.length === openChildren.length + closedChildren.length) {
            textSpan.textContent = 'All Statuses';
        } else {
            const labels = Array.from(checkedBoxes).map(cb => cb.getAttribute('data-label'));
            textSpan.textContent = labels.join(', ');
            if (textSpan.textContent.length > 20) {
                textSpan.textContent = checkedBoxes.length + ' Selected';
            }
        }
    }

    // Handle Group Toggle click
    function toggleGroupCheckboxes(groupType, checked) {
        let targets = [];
        if (groupType === 'Open') {
            targets = [
                document.getElementById('cb-status-open-ind'),
                document.getElementById('cb-status-wip')
            ];
        } else if (groupType === 'Closed') {
            targets = [
                document.getElementById('cb-status-won'),
                document.getElementById('cb-status-lost'),
                document.getElementById('cb-status-dup')
            ];
        }
        targets.forEach(cb => {
            if (cb) cb.checked = checked;
        });
        updateStatusUI();
    }

    // Initialize UI on DOM load
    document.addEventListener('DOMContentLoaded', function() {
        updateStatusUI();
    });
</script>
</body>
</html>
