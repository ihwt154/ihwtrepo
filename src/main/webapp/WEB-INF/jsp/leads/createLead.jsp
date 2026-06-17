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
    <style>
        .client-info-card {
            display: none;
            background: linear-gradient(135deg, rgba(99,102,241,0.06), rgba(16,185,129,0.04));
            border: 1px solid rgba(99,102,241,0.2);
            border-radius: 12px;
            padding: 18px 22px;
            margin-bottom: 20px;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn { from { opacity:0; transform:translateY(-6px); } to { opacity:1; transform:translateY(0); } }
        .client-info-card.visible { display: block; }
        .client-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 10px 20px;
            margin-top: 10px;
        }
        .client-info-item { display: flex; flex-direction: column; }
        .client-info-item label { font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: #94a3b8; font-weight: 600; margin-bottom: 2px; }
        .client-info-item span { font-size: 14px; color: #1e293b; font-weight: 500; word-break: break-word; }
        .client-info-title { font-size: 13px; font-weight: 700; color: #6366f1; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 10px; }
        .search-wrapper { position: relative; }
        .dropdown-list { position: absolute; z-index: 999; background: #fff; border: 1px solid #e2e8f0;
            border-radius: 10px; width: 100%; display: none; max-height: 240px; overflow-y: auto;
            box-shadow: 0 8px 24px rgba(0,0,0,0.12); top: calc(100% + 4px); }
        .dropdown-item { padding: 10px 14px; cursor: pointer; border-bottom: 1px solid #f8fafc;
            font-size: 14px; display: flex; justify-content: space-between; align-items: center; }
        .dropdown-item:last-child { border-bottom: none; }
        .dropdown-item:hover { background: #f1f5f9; }
        .dropdown-item .city-tag { font-size: 12px; color: #94a3b8; background: #f1f5f9; padding: 2px 8px; border-radius: 20px; }
        .field-required { color: #ef4444; margin-left: 2px; }
        .form-label-text { font-size: 13px; font-weight: 600; color: #475569; margin-bottom: 6px; display: block; }
        .form-input { width: 100%; padding: 10px 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 14px; color: #1e293b; background: #fff; box-sizing: border-box; transition: border-color 0.2s; }
        .form-input:focus { outline: none; border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
        .form-select { width: 100%; padding: 10px 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 14px; color: #1e293b; background: #fff; box-sizing: border-box; }
        .section-title { font-weight: 700; color: #6366f1; margin-bottom: 16px; border-bottom: 2px solid #6366f1; padding-bottom: 8px; font-size: 14px; text-transform: uppercase; letter-spacing: 0.05em; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding: 30px; max-width: 960px; margin: 0 auto;">
    <div class="page-header" style="margin-bottom: 24px; display:flex; justify-content:space-between; align-items:center;">
        <h2 style="color: var(--text-primary); font-size: 1.5rem; font-weight: 700; margin:0;">Add New Lead</h2>
        <a href="${pageContext.request.contextPath}/view_filter_leads" class="btn-secondary">← Back to Leads</a>
    </div>

    <c:if test="${not empty error}">
        <div style="background:#fee2e2; color:#991b1b; padding:12px 16px; border-radius:8px; margin-bottom:16px; font-weight:500;">${error}</div>
    </c:if>

    <div class="card" style="background:rgba(255,255,255,0.95); border-radius:16px; padding:32px; box-shadow:0 4px 24px rgba(0,0,0,0.08);">
        <form id="leadForm" action="${pageContext.request.contextPath}/create_lead" method="post">

            <%-- ── CLIENT SEARCH ──────────────────────────────────────────────── --%>
            <div class="section-title">Client Information</div>

            <div style="margin-bottom:20px;">
                <label class="form-label-text" for="clientSearch">Search Client <span class="field-required">*</span></label>
                <div class="search-wrapper">
                    <input type="text" id="clientSearch" autocomplete="off" placeholder="Search clients…" class="form-input">
                    <div id="clientDropdown" class="dropdown-list"></div>
                </div>
                <%-- Hidden fields that carry ALL client data to server --%>
                <input type="hidden" id="clientId"             name="clientId">
                <input type="hidden" id="hClientName"          name="hClientName">
                <input type="hidden" id="hMobile"              name="hMobile">
                <input type="hidden" id="hEmailId"             name="hEmailId">
                <input type="hidden" id="hCity"                name="hCity">
                <input type="hidden" id="hCountry"             name="hCountry">
                <input type="hidden" id="hOrganizationName"    name="hOrganizationName">
                <input type="hidden" id="hOrganizationType"    name="hOrganizationType">
                <input type="hidden" id="hRegistrationNumber"  name="hRegistrationNumber">
                <input type="hidden" id="hWebsite"             name="hWebsite">
                <input type="hidden" id="hAddress"             name="hAddress">
                <input type="hidden" id="hPostalCode"          name="hPostalCode">
                <input type="hidden" id="hDesignation"         name="hDesignation">
                <input type="hidden" id="hClientType"          name="hClientType">
                <input type="hidden" id="hClientSource"        name="hClientSource">
            </div>

            <%-- Client info preview card (shown after selection) --%>
            <div id="clientInfoCard" class="client-info-card">
                <div class="client-info-title">📋 Selected Client Details</div>
                <div class="client-info-grid">
                    <div class="client-info-item"><label>Name</label><span id="ci_name">—</span></div>
                    <div class="client-info-item"><label>Mobile</label><span id="ci_mobile">—</span></div>
                    <div class="client-info-item"><label>Email</label><span id="ci_email">—</span></div>
                    <div class="client-info-item"><label>City</label><span id="ci_city">—</span></div>
                    <div class="client-info-item"><label>Country</label><span id="ci_country">—</span></div>
                    <div class="client-info-item"><label>Organisation</label><span id="ci_org">—</span></div>
                    <div class="client-info-item"><label>Org. Type</label><span id="ci_orgType">—</span></div>
                    <div class="client-info-item"><label>Reg. Number</label><span id="ci_regNum">—</span></div>
                    <div class="client-info-item"><label>Designation</label><span id="ci_designation">—</span></div>
                    <div class="client-info-item"><label>Client Type</label><span id="ci_clientType">—</span></div>
                    <div class="client-info-item"><label>Client Source</label><span id="ci_clientSource">—</span></div>
                    <div class="client-info-item"><label>Website</label><span id="ci_website">—</span></div>
                    <div class="client-info-item"><label>Address</label><span id="ci_address">—</span></div>
                    <div class="client-info-item"><label>Postal Code</label><span id="ci_postal">—</span></div>
                </div>
                <button type="button" id="clearClientBtn" style="margin-top:12px; font-size:12px; background:none; border:1px solid #cbd5e1; border-radius:6px; padding:4px 12px; cursor:pointer; color:#64748b;">✕ Change Client</button>
            </div>

            <%-- ── LEAD DETAILS ──────────────────────────────────────────────── --%>
            <div class="section-title" style="margin-top:24px;">Lead Details</div>

            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
                <div>
                    <label class="form-label-text" for="leadTitle">Lead Title <span class="field-required">*</span></label>
                    <input type="text" id="leadTitle" name="leadTitle" class="form-input" value="${LEAD_OBJ.leadTitle}">
                </div>
                <div>
                    <label class="form-label-text" for="leadName">Lead Name</label>
                    <input type="text" id="leadName" name="leadName" class="form-input" value="${LEAD_OBJ.leadName}">
                </div>
            </div>

            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
                <div>
                    <label class="form-label-text" for="eventName">Event Name <span class="field-required">*</span></label>
                    <input type="text" id="eventName" name="eventName" class="form-input" value="${LEAD_OBJ.eventName}">
                </div>
                <div>
                    <label class="form-label-text" for="remarks">Remarks</label>
                    <input type="text" id="remarks" name="remarks" class="form-input" value="${LEAD_OBJ.remarks}">
                </div>
            </div>

            <%-- ── LEAD CLASSIFICATION ──────────────────────────────────────── --%>
            <div class="section-title" style="margin-top:24px;">Lead Classification</div>

            <div style="display:grid; grid-template-columns:1fr 1fr 1fr 1fr; gap:16px; margin-bottom:16px;">
                <div>
                    <label class="form-label-text" for="leadStatus">Status <span class="field-required">*</span></label>
                    <select id="leadStatus" name="leadStatus" class="form-select">
                        <option value="">-- Select Status --</option>
                        <c:forEach var="s" items="${LEAD_STATUSES}">
                            <option value="${s}" <c:if test="${LEAD_OBJ.leadStatus == s}">selected</c:if>>${s}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="form-label-text" for="priority">Priority</label>
                    <select id="priority" name="priority" class="form-select">
                        <option value="">-- Select Priority --</option>
                        <c:forEach var="p" items="${PRIORITIES}">
                            <option value="${p}" <c:if test="${LEAD_OBJ.priority == p}">selected</c:if>>${p}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="form-label-text" for="leadSource">Lead Source <span class="field-required">*</span></label>
                    <select id="leadSource" name="leadSource" class="form-select">
                        <option value="">-- Select Source --</option>
                        <c:forEach var="src" items="${CLIENT_SOURCES}">
                            <option value="${src.sourceName}" <c:if test="${LEAD_OBJ.leadSource == src.sourceName}">selected</c:if>>${src.sourceName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="form-label-text" for="assignedTo">Assigned To <span class="field-required">*</span></label>
                    <select id="assignedTo" name="assignedTo" class="form-select">
                        <option value="">-- Select User --</option>
                        <c:forEach var="entry" items="${ACTIVE_USERS_MAP}">
                            <option value="${entry.key}" <c:if test="${LEAD_OBJ.assignedTo == entry.key}">selected</c:if>>${entry.value}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <%-- ── ACTIONS ───────────────────────────────────────────────────── --%>
            <div style="display:flex; gap:12px; justify-content:flex-end; margin-top:8px;">
                <a href="${pageContext.request.contextPath}/view_filter_leads"
                   style="padding:10px 24px; border-radius:8px; text-decoration:none; background:#f1f5f9; color:#475569; font-weight:600; border:1px solid #e2e8f0; display:inline-flex; align-items:center;">Cancel</a>
                <button type="submit"
                   style="padding:10px 28px; background: linear-gradient(135deg,#6366f1,#4f46e5); color:#fff; border:none; border-radius:8px; cursor:pointer; font-weight:700; font-size:15px; box-shadow:0 4px 12px rgba(99,102,241,0.3);">Create Lead</button>
            </div>
        </form>
    </div>
</div>

<script>
(function() {
    const ctx         = '${pageContext.request.contextPath}';
    const searchInput = document.getElementById('clientSearch');
    const dropdown    = document.getElementById('clientDropdown');
    const infoCard    = document.getElementById('clientInfoCard');
    const clientIdHidden = document.getElementById('clientId');

    // Helper: set a hidden field and a display span
    function set(hiddenId, spanId, val) {
        document.getElementById(hiddenId).value = val || '';
        if (spanId) document.getElementById(spanId).textContent = val || '—';
    }

    function populateClient(c) {
        set('clientId',            null,              c.clientId);
        set('hClientName',         'ci_name',         c.clientName);
        set('hMobile',             'ci_mobile',       c.mobile);
        set('hEmailId',            'ci_email',        c.emailId);
        set('hCity',               'ci_city',         c.city);
        set('hCountry',            'ci_country',      c.country);
        set('hOrganizationName',   'ci_org',          c.organizationName);
        set('hOrganizationType',   'ci_orgType',      c.organizationType);
        set('hRegistrationNumber', 'ci_regNum',       c.registrationNumber);
        set('hWebsite',            'ci_website',      c.website);
        set('hAddress',            'ci_address',      c.address);
        set('hPostalCode',         'ci_postal',       c.postalCode);
        set('hDesignation',        'ci_designation',  c.designation);
        set('hClientType',         'ci_clientType',   c.clientType);
        set('hClientSource',       'ci_clientSource', c.clientSource);

        // also set clientId span separately
        document.getElementById('clientId').value = c.clientId;

        // auto-fill lead name if blank
        const leadNameEl = document.getElementById('leadName');
        if (!leadNameEl.value.trim()) leadNameEl.value = c.clientName;

        searchInput.value = c.clientName;
        dropdown.style.display = 'none';
        infoCard.classList.add('visible');
    }

    function clearClient() {
        ['clientId','hClientName','hMobile','hEmailId','hCity','hCountry',
         'hOrganizationName','hOrganizationType','hRegistrationNumber','hWebsite',
         'hAddress','hPostalCode','hDesignation','hClientType','hClientSource']
          .forEach(id => document.getElementById(id).value = '');
        infoCard.classList.remove('visible');
        searchInput.value = '';
        searchInput.focus();
    }

    document.getElementById('clearClientBtn').addEventListener('click', clearClient);

    function fetchClients(q) {
        const url = ctx + '/getClientList' + (q ? '?clientName=' + encodeURIComponent(q) : '');
        fetch(url)
            .then(r => r.json())
            .then(data => {
                dropdown.innerHTML = '';
                if (!data || data.length === 0) {
                    dropdown.style.display = 'none';
                    return;
                }
                data.forEach(c => {
                    const div = document.createElement('div');
                    div.className = 'dropdown-item';
                    div.innerHTML = '<span>' + (c.clientName || '') + '</span>'
                        + (c.city ? '<span class="city-tag">' + c.city + '</span>' : '');
                    div.addEventListener('mousedown', e => {
                        e.preventDefault();
                        populateClient(c);
                    });
                    dropdown.appendChild(div);
                });
                dropdown.style.display = 'block';
            })
            .catch(() => { dropdown.style.display = 'none'; });
    }

    // Trigger on 1+ character
    searchInput.addEventListener('input', function() {
        const val = this.value;
        clientIdHidden.value = ''; // clear selection when typing
        infoCard.classList.remove('visible');
        if (val.length >= 1) {
            fetchClients(val);
        } else {
            dropdown.style.display = 'none';
        }
    });

    // Show all clients on focus if field is empty
    searchInput.addEventListener('focus', function() {
        if (!clientIdHidden.value) fetchClients(this.value);
    });

    searchInput.addEventListener('blur', function() {
        setTimeout(() => {
            dropdown.style.display = 'none';
            if (!clientIdHidden.value) {
                searchInput.value = '';
                infoCard.classList.remove('visible');
            }
        }, 200);
    });

    document.getElementById('leadForm').addEventListener('submit', function(e) {
        const errors = [];
        if (!clientIdHidden.value)                                                  errors.push('Please select a valid Client from the dropdown.');
        if (!document.getElementById('leadTitle').value.trim())                     errors.push('Lead Title is required.');
        if (!document.getElementById('eventName').value.trim())                     errors.push('Event Name is required.');
        if (!document.getElementById('leadSource').value)                           errors.push('Lead Source is required.');
        if (!document.getElementById('assignedTo').value)                           errors.push('Assigned To is required.');

        if (errors.length > 0) {
            e.preventDefault();
            alert(errors.join('\n'));
        }
    });
})();
</script>
</body>
</html>
