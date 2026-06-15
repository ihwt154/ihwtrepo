<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Add New Lead</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding: 30px; max-width: 900px; margin: 0 auto;">
    <div class="page-header" style="margin-bottom: 24px;">
        <h2 style="color: var(--text-primary); font-size: 1.5rem; font-weight: 700;">Add New Lead</h2>
        <a href="${pageContext.request.contextPath}/view_filter_leads" class="btn-secondary">Back to Leads</a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert-error" style="background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px;">${error}</div>
    </c:if>

    <div class="card" style="background: rgba(255,255,255,0.85); border-radius: 16px; padding: 32px; box-shadow: 0 4px 24px rgba(0,0,0,0.08);">
        <form id="leadForm" action="${pageContext.request.contextPath}/create_lead" method="post">

            <%-- Client Search --%>
            <div class="form-section-title" style="font-weight:600; color: var(--accent-primary); margin-bottom:16px; border-bottom: 2px solid var(--accent-primary); padding-bottom:8px;">Client Information</div>
            <div class="form-row" style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
                <div class="form-group">
                    <label for="clientSearch">Search Client <span style="color:red">*</span></label>
                    <input type="text" id="clientSearch" autocomplete="off" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;">
                    <input type="hidden" id="clientId" name="clientId">
                    <div id="clientDropdown" style="position:absolute; z-index:999; background:#fff; border:1px solid #e2e8f0; border-radius:8px; width:300px; display:none; max-height:200px; overflow-y:auto;"></div>
                </div>
                <div class="form-group">
                    <label for="leadName">Lead Name</label>
                    <input type="text" id="leadName" name="leadName" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;">
                </div>
            </div>
            <div class="form-row" style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
                <div class="form-group">
                    <label for="leadTitle">Lead Title</label>
                    <input type="text" id="leadTitle" name="leadTitle" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;">
                </div>
                <div class="form-group">
                    <label for="eventName">Event Name</label>
                    <input type="text" id="eventName" name="eventName" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;">
                </div>
            </div>

            <%-- Lead Classification --%>
            <div class="form-section-title" style="font-weight:600; color: var(--accent-primary); margin-bottom:16px; border-bottom: 2px solid var(--accent-primary); padding-bottom:8px; margin-top:24px;">Lead Classification</div>
            <div class="form-row" style="display:grid; grid-template-columns:1fr 1fr 1fr 1fr; gap:16px; margin-bottom:16px;">
                <div class="form-group">
                    <label for="leadStatus">Status <span style="color:red">*</span></label>
                    <select id="leadStatus" name="leadStatus" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;" required>
                        <option value="">-- Select Status --</option>
                        <c:forEach var="s" items="${LEAD_STATUSES}">
                            <option value="${s}">${s}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="priority">Priority</label>
                    <select id="priority" name="priority" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;">
                        <option value="">-- Select Priority --</option>
                        <c:forEach var="p" items="${PRIORITIES}">
                            <option value="${p}">${p}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="leadSource">Lead Source</label>
                    <select id="leadSource" name="leadSource" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;">
                        <option value="">-- Select Source --</option>
                        <c:forEach var="src" items="${CLIENT_SOURCES}">
                            <option value="${src.sourceName}">${src.sourceName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="assignedTo">Assigned To</label>
                    <select id="assignedTo" name="assignedTo" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;">
                        <option value="">-- Select User --</option>
                        <c:forEach var="entry" items="${ACTIVE_USERS_MAP}">
                            <option value="${entry.key}">${entry.value}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <%-- Remarks --%>
            <div class="form-group" style="margin-bottom:24px;">
                <label for="remarks">Remarks</label>
                <textarea id="remarks" name="remarks" rows="3" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px; resize:vertical;"></textarea>
            </div>

            <div style="display:flex; gap:12px; justify-content:flex-end;">
                <a href="${pageContext.request.contextPath}/view_filter_leads" class="btn-secondary" style="padding:10px 24px; border-radius:8px; text-decoration:none; background:#f1f5f9; color:#475569;">Cancel</a>
                <button type="submit" style="padding:10px 28px; background: var(--accent-primary); color:#fff; border:none; border-radius:8px; cursor:pointer; font-weight:600;">Create Lead</button>
            </div>
        </form>
    </div>
</div>

<script>
(function() {
    const searchInput = document.getElementById('clientSearch');
    const clientIdInput = document.getElementById('clientId');
    const leadNameInput = document.getElementById('leadName');
    const dropdown = document.getElementById('clientDropdown');
    const ctx = '${pageContext.request.contextPath}';

    searchInput.addEventListener('input', function() {
        const val = this.value.trim();
        if (val.length < 2) { dropdown.style.display='none'; return; }
        fetch(ctx + '/getClientList?clientName=' + encodeURIComponent(val))
            .then(r => r.json())
            .then(data => {
                dropdown.innerHTML = '';
                if (data.length === 0) { dropdown.style.display='none'; return; }
                data.forEach(c => {
                    const div = document.createElement('div');
                    div.textContent = c.clientName + (c.city ? ' (' + c.city + ')' : '');
                    div.style.cssText = 'padding:10px 14px; cursor:pointer; border-bottom:1px solid #f1f5f9;';
                    div.addEventListener('mouseenter', () => div.style.background='#f8fafc');
                    div.addEventListener('mouseleave', () => div.style.background='#fff');
                    div.addEventListener('click', () => {
                        searchInput.value = c.clientName;
                        clientIdInput.value = c.clientId;
                        if (!leadNameInput.value) leadNameInput.value = c.clientName;
                        dropdown.style.display = 'none';
                    });
                    dropdown.appendChild(div);
                });
                dropdown.style.display = 'block';
            });
    });
    searchInput.addEventListener('blur', function() {
        setTimeout(() => {
            if (!clientIdInput.value) {
                searchInput.value = '';
            }
        }, 200);
    });
    
    document.getElementById('leadForm').addEventListener('submit', function(e) {
        if (!clientIdInput.value) {
            e.preventDefault();
            alert('Please select a valid Client from the dropdown before creating a lead.');
            searchInput.focus();
        }
    });

    document.addEventListener('click', e => { if (!e.target.closest('#clientSearch')) dropdown.style.display='none'; });
})();
</script>
</body>
</html>

