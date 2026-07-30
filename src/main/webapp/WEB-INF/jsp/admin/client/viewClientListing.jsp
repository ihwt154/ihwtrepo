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
        .badge-active   { background:#d1fae5; color:#065f46; padding:3px 10px; border-radius:20px; font-size:0.75rem; font-weight:600; }
        .badge-inactive { background:#fee2e2; color:#991b1b; padding:3px 10px; border-radius:20px; font-size:0.75rem; font-weight:600; }

        /* ── Confirmation Modal ─────────────────────────────────── */
        .confirm-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(15,23,42,0.55); backdrop-filter: blur(3px);
            z-index: 2000; justify-content: center; align-items: center;
        }
        .confirm-overlay.open { display: flex; }
        .confirm-box {
            background: #fff; border-radius: 16px; padding: 32px 28px; width: 380px;
            max-width: 92%; box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            animation: popIn .2s ease;
        }
        @keyframes popIn { from { transform:scale(.92); opacity:0; } to { transform:scale(1); opacity:1; } }
        .confirm-icon { font-size: 2.2rem; text-align: center; margin-bottom: 12px; }
        .confirm-title { font-size: 1.1rem; font-weight: 700; color: #1e293b; text-align: center; margin-bottom: 6px; }
        .confirm-msg   { font-size: 0.9rem; color: #64748b; text-align: center; margin-bottom: 24px; line-height: 1.5; }
        .confirm-actions { display: flex; gap: 10px; justify-content: center; }
        .btn-cancel { padding: 9px 22px; background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 0.9rem; font-weight: 600; cursor: pointer; }
        .btn-confirm-ok { padding: 9px 22px; border: none; border-radius: 8px; font-size: 0.9rem; font-weight: 600; cursor: pointer; }
        .btn-danger  { background: #ef4444; color: #fff; }
        .btn-success { background: #10b981; color: #fff; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding:30px;">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
        <h2 style="font-size:1.5rem;font-weight:700;color:var(--text-primary);">
            <c:choose>
                <c:when test="${MY_CLIENTS_ONLY}">My Clients</c:when>
                <c:otherwise>Manage Clients</c:otherwise>
            </c:choose>
        </h2>
        <div style="display:flex;gap:10px;align-items:center;">
            <button onclick="document.getElementById('bulkImportModal').classList.add('open')"
               style="padding:10px 18px;background:linear-gradient(135deg,#7c3aed,#4f46e5);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;font-size:0.9rem;display:flex;align-items:center;gap:6px;"
               id="btnOpenBulkImport">&#8679; Bulk Import</button>
            <a href="${pageContext.request.contextPath}/view_add_client_form"
               style="padding:10px 20px;background:var(--accent-primary);color:#fff;border-radius:8px;text-decoration:none;font-weight:600;">+ Add Client</a>
        </div>
    </div>

    <c:if test="${not empty success}"><div style="background:#d1fae5;color:#065f46;padding:12px;border-radius:8px;margin-bottom:16px;">${success}</div></c:if>
    <c:if test="${not empty error}"><div style="background:#fee2e2;color:#991b1b;padding:12px;border-radius:8px;margin-bottom:16px;">${error}</div></c:if>

    <%-- Filter Form --%>
    <div style="background:rgba(255,255,255,0.85);border-radius:14px;padding:20px 24px;box-shadow:0 2px 12px rgba(0,0,0,0.06);margin-bottom:20px;">
    <form method="get" action="${pageContext.request.contextPath}/${MY_CLIENTS_ONLY ? 'view_my_clients' : 'view_clients_list'}"
              style="display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:12px;align-items:end;">
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Client Name</label>
                <input type="text" name="clientName" value="${f_clientName}" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
            </div>
            <div style="position:relative;" class="searchable-select-container">
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">City</label>
                <div class="searchable-select-trigger" onclick="toggleSelectDropdown(this)" style="display:flex; justify-content:space-between; align-items:center; width:100%; padding:8px; border:1px solid #e2e8f0; border-radius:8px; background:#fff; cursor:pointer; font-size:13px; box-sizing:border-box;">
                    <span class="selected-text" style="color:#1e293b;">
                        <c:choose>
                            <c:when test="${not empty f_city}">
                                <c:forEach var="c" items="${CITIES}"><c:if test="${f_city == c.id || f_city == c.name}">${c.name}</c:if></c:forEach>
                            </c:when>
                            <c:otherwise>All Cities</c:otherwise>
                        </c:choose>
                    </span>
                    <span style="font-size:10px; color:#64748b;">▼</span>
                </div>
                <div class="searchable-select-options-panel" style="display:none; position:absolute; z-index:999; width:100%; background:#fff; border:1px solid #e2e8f0; border-radius:8px; box-shadow:0 10px 25px rgba(0,0,0,0.08); margin-top:4px; box-sizing:border-box; padding:8px;">
                    <input type="text" placeholder="Search city..." onkeyup="filterSelectOptions(this)" style="width:100%; padding:8px 10px; border:1px solid #e2e8f0; border-radius:6px; font-size:13px; outline:none; box-sizing:border-box; margin-bottom:6px;" autocomplete="off">
                    <div class="options-list-container" style="max-height:160px; overflow-y:auto;">
                        <div class="searchable-option-item" data-value="" onclick="selectOption(this, '')" style="padding:8px 10px; font-size:13px; cursor:pointer; border-radius:6px; color:#64748b;">All Cities</div>
                        <c:forEach var="c" items="${CITIES}">
                            <div class="searchable-option-item" data-value="${c.id}" onclick="selectOption(this, '${c.id}')" style="padding:8px 10px; font-size:13px; cursor:pointer; border-radius:6px; color:#1e293b;">${c.name}</div>
                        </c:forEach>
                    </div>
                </div>
                <input type="hidden" name="city" class="hidden-select-value" value="${f_city}">
            </div>
            <div>
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Status</label>
                <select name="active" style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:8px;">
                    <option value="">All</option>
                    <option value="true"  ${f_active == true  ? 'selected' : ''}>Active</option>
                    <option value="false" ${f_active == false ? 'selected' : ''}>Inactive</option>
                </select>
            </div>
            <div style="display:flex;gap:8px;">
                <button type="submit" style="padding:8px 16px;background:var(--accent-primary);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;flex:1;">Filter</button>
                <a href="${pageContext.request.contextPath}/${MY_CLIENTS_ONLY ? 'view_my_clients' : 'view_clients_list'}"
                   style="padding:8px 14px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;display:flex;align-items:center;">Reset</a>
            </div>
        </form>
    </div>

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
        <p style="font-size:0.85rem;color:#64748b;margin:0;">Showing <strong>${CLIENT_LIST.size()}</strong> of <strong>${totalClients}</strong> clients</p>
        <div style="display:flex;gap:8px;">
            <a href="${pageContext.request.contextPath}/clients/export/excel?clientName=${f_clientName}&city=${f_city}&active=${f_active}"
               style="padding:6px 12px;background:#10b981;color:#fff;border-radius:6px;text-decoration:none;font-size:0.8rem;font-weight:600;">Export Excel</a>
            <a href="${pageContext.request.contextPath}/clients/export/pdf?clientName=${f_clientName}&city=${f_city}&active=${f_active}"
               style="padding:6px 12px;background:#ef4444;color:#fff;border-radius:6px;text-decoration:none;font-size:0.8rem;font-weight:600;">Export PDF</a>
            <button onclick="document.getElementById('bulkImportModal').classList.add('open')"
               style="padding:6px 12px;background:linear-gradient(135deg,#7c3aed,#4f46e5);color:#fff;border:none;border-radius:6px;cursor:pointer;font-size:0.8rem;font-weight:600;">&#8679; Bulk Import</button>
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
                                <%-- Toggle button triggers modal, not browser confirm() --%>
                                <form id="toggleForm_${client.clientId}" method="post"
                                      action="${pageContext.request.contextPath}/toggle_client" style="display:none;">
                                    <input type="hidden" name="clientId" value="${client.clientId}">
                                </form>
                                <button type="button"
                                        onclick="openConfirm('${client.clientId}','${client.clientName}',${client.active})"
                                        style="padding:5px 12px;background:${client.active ? '#fee2e2' : '#d1fae5'};color:${client.active ? '#b91c1c' : '#065f46'};border:1px solid ${client.active ? '#fca5a5' : '#a7f3d0'};border-radius:6px;cursor:pointer;font-size:0.78rem;font-weight:600;">
                                    ${client.active ? 'Deactivate' : 'Activate'}
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <c:set var="listBase" value="${MY_CLIENTS_ONLY ? 'view_my_clients' : 'view_clients_list'}"/>
        <div style="display:flex;gap:8px;margin-top:20px;justify-content:center;">
            <c:if test="${currentPage > 0}">
                <a href="?page=${currentPage-1}&pageSize=${pageSize}&clientName=${f_clientName}&city=${f_city}&active=${f_active}"
                   style="padding:8px 14px;background:#f1f5f9;border-radius:8px;text-decoration:none;color:#475569;">Prev</a>
            </c:if>
            <c:forEach begin="0" end="${totalPages-1}" var="p">
                <c:choose>
                    <c:when test="${p==currentPage}"><span style="padding:8px 14px;background:var(--accent-primary);color:#fff;border-radius:8px;">${p+1}</span></c:when>
                    <c:otherwise><a href="?page=${p}&pageSize=${pageSize}&clientName=${f_clientName}&city=${f_city}&active=${f_active}"
                                    style="padding:8px 14px;background:#f1f5f9;border-radius:8px;text-decoration:none;color:#475569;">${p+1}</a></c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages-1}">
                <a href="?page=${currentPage+1}&pageSize=${pageSize}&clientName=${f_clientName}&city=${f_city}&active=${f_active}"
                   style="padding:8px 14px;background:#f1f5f9;border-radius:8px;text-decoration:none;color:#475569;">Next</a>
            </c:if>
        </div>
    </c:if>
</div>

<!-- ── Confirmation Modal ─────────────────────────────────────────── -->
<div id="confirmOverlay" class="confirm-overlay">
    <div class="confirm-box">
        <div class="confirm-icon" id="confirmIcon">⚠️</div>
        <div class="confirm-title" id="confirmTitle">Change Client Status?</div>
        <div class="confirm-msg"  id="confirmMsg">Are you sure?</div>
        <div class="confirm-actions">
            <button class="btn-cancel" onclick="closeConfirm()">Cancel</button>
            <button id="confirmOkBtn" class="btn-confirm-ok btn-danger" onclick="submitToggle()">Confirm</button>
        </div>
    </div>
</div>

<%-- ═══════════════════════════════════════════════════════
     BULK CLIENT IMPORT MODAL
══════════════════════════════════════════════════════════ --%>
<div id="bulkImportModal" class="confirm-overlay" style="z-index:3000;">
  <div style="background:#fff;border-radius:20px;padding:0;width:540px;max-width:96%;box-shadow:0 30px 80px rgba(0,0,0,0.25);animation:popIn .22s ease;overflow:hidden;">

    <%-- Modal Header --%>
    <div style="background:linear-gradient(135deg,#4f46e5,#7c3aed);padding:22px 28px;display:flex;justify-content:space-between;align-items:center;">
      <div>
        <h3 style="color:#fff;margin:0;font-size:1.15rem;font-weight:700;">&#8679; Bulk Import Clients</h3>
        <p style="color:rgba(255,255,255,0.75);margin:4px 0 0;font-size:0.8rem;">Upload an Excel file to create multiple client records at once</p>
      </div>
      <button onclick="closeBulkImportModal()" style="background:rgba(255,255,255,0.2);border:none;color:#fff;border-radius:50%;width:32px;height:32px;font-size:1.1rem;cursor:pointer;display:flex;align-items:center;justify-content:center;">&times;</button>
    </div>

    <%-- Modal Body --%>
    <div style="padding:24px 28px;">

      <%-- Download template row --%>
      <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:14px 18px;margin-bottom:18px;">
        <p style="font-size:0.82rem;font-weight:700;color:#475569;margin:0 0 10px;">&#x1F4E5; Download Template</p>
        <div style="display:flex;gap:10px;flex-wrap:wrap;">
          <a href="${pageContext.request.contextPath}/clients/import/template/excel"
             style="padding:8px 16px;background:#059669;color:#fff;border-radius:8px;text-decoration:none;font-size:0.83rem;font-weight:600;display:flex;align-items:center;gap:6px;">
            &#x1F4C8; Excel Template
          </a>
        </div>
      </div>

      <%-- Upload area --%>
      <div style="margin-bottom:16px;">
        <label style="font-size:0.82rem;font-weight:700;color:#374151;display:block;margin-bottom:8px;">&#x1F4C2; Select Excel File (.xlsx / .xls)</label>
        <div id="importDropZone"
             ondragover="event.preventDefault();this.style.borderColor='#7c3aed';"
             ondragleave="this.style.borderColor='#c4b5fd';"
             ondrop="handleImportDrop(event)"
             style="border:2px dashed #c4b5fd;border-radius:12px;padding:28px;text-align:center;background:#faf5ff;cursor:pointer;transition:.2s;"
             onclick="document.getElementById('importFileInput').click()">
          <div style="font-size:2rem;margin-bottom:6px;">&#x1F4C4;</div>
          <p style="font-size:0.85rem;color:#6d28d9;font-weight:600;margin:0 0 4px;">Click to browse or drag & drop</p>
          <p id="importFileName" style="font-size:0.78rem;color:#9ca3af;margin:0;">No file selected</p>
        </div>
        <input type="file" id="importFileInput" accept=".xlsx,.xls" style="display:none;"
               onchange="handleImportFileChange(this)">
      </div>

      <%-- Rules reminder --%>
      <p style="font-size:0.75rem;color:#64748b;margin:0 0 16px;line-height:1.6;">
        <span style="color:#7c3aed;font-weight:700;">&#9432; Note:</span>
        Client Name + Mobile or Email required &nbsp;|&nbsp; Mobile = 10 digits &nbsp;|&nbsp;
        Duplicate Mobile/Email will be skipped &nbsp;|&nbsp; Client Code auto-generated.
      </p>

      <%-- Upload button + progress --%>
      <div style="display:flex;gap:10px;align-items:center;">
        <button id="btnUploadImport" onclick="submitImportFile()"
                style="padding:10px 24px;background:linear-gradient(135deg,#7c3aed,#4f46e5);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:700;font-size:0.9rem;">
          &#8679; Upload &amp; Import
        </button>
        <button onclick="closeBulkImportModal()"
                style="padding:10px 18px;background:#f1f5f9;color:#475569;border:1px solid #e2e8f0;border-radius:8px;cursor:pointer;font-weight:600;font-size:0.9rem;">
          Cancel
        </button>
      </div>

      <%-- Progress bar (hidden initially) --%>
      <div id="importProgressWrap" style="display:none;margin-top:14px;">
        <div style="height:6px;background:#e2e8f0;border-radius:99px;overflow:hidden;">
          <div id="importProgressBar" style="height:100%;width:0;background:linear-gradient(90deg,#7c3aed,#4f46e5);border-radius:99px;transition:width .4s ease;"></div>
        </div>
        <p id="importProgressText" style="font-size:0.8rem;color:#6d28d9;margin:6px 0 0;text-align:center;">Processing...</p>
      </div>

      <%-- Result Summary (hidden initially) --%>
      <div id="importSummary" style="display:none;margin-top:18px;border-top:1px solid #f1f5f9;padding-top:16px;">
        <p style="font-size:0.85rem;font-weight:700;color:#1e293b;margin:0 0 12px;">&#x2705; Import Complete — Summary</p>
        <div style="display:flex;gap:12px;margin-bottom:14px;">
          <div style="flex:1;background:#f8fafc;border-radius:10px;padding:12px;text-align:center;border:1px solid #e2e8f0;">
            <div id="sumTotal" style="font-size:1.6rem;font-weight:800;color:#1e293b;">0</div>
            <div style="font-size:0.73rem;color:#64748b;font-weight:600;margin-top:2px;">TOTAL ROWS</div>
          </div>
          <div style="flex:1;background:#d1fae5;border-radius:10px;padding:12px;text-align:center;border:1px solid #a7f3d0;">
            <div id="sumSuccess" style="font-size:1.6rem;font-weight:800;color:#065f46;">0</div>
            <div style="font-size:0.73rem;color:#047857;font-weight:600;margin-top:2px;">IMPORTED</div>
          </div>
          <div style="flex:1;background:#fee2e2;border-radius:10px;padding:12px;text-align:center;border:1px solid #fca5a5;">
            <div id="sumFailed" style="font-size:1.6rem;font-weight:800;color:#991b1b;">0</div>
            <div style="font-size:0.73rem;color:#b91c1c;font-weight:600;margin-top:2px;">FAILED</div>
          </div>
        </div>

        <%-- Error download button (shown only if failures exist) --%>
        <div id="importErrorBtns" style="display:none;margin-top:12px;">
          <p style="font-size:0.8rem;color:#64748b;margin:0 0 8px;">Download failed records report:</p>
          <div>
            <a href="${pageContext.request.contextPath}/clients/import/error-report/txt"
               style="padding:8px 16px;background:#dc2626;color:#fff;border-radius:8px;text-decoration:none;font-size:0.8rem;font-weight:600;display:inline-block;">&#x1F4C4; Download Error Report (.txt)</a>
          </div>
        </div>

        <button onclick="window.location.reload()"
                style="margin-top:14px;padding:9px 20px;background:#4f46e5;color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;font-size:0.85rem;">
          Refresh Client List
        </button>
      </div>

    </div><%-- end modal body --%>
  </div>
</div>

<script>
var _pendingFormId = null;

function openConfirm(clientId, clientName, isActive) {
    _pendingFormId = 'toggleForm_' + clientId;
    document.getElementById('confirmIcon').textContent  = isActive ? '🔴' : '🟢';
    document.getElementById('confirmTitle').textContent = isActive ? 'Deactivate Client?' : 'Activate Client?';
    document.getElementById('confirmMsg').textContent   = isActive
        ? 'Deactivating "' + clientName + '" will hide them from all future lead searches.'
        : 'Activating "' + clientName + '" will make them available in lead searches again.';
    var btn = document.getElementById('confirmOkBtn');
    btn.textContent  = isActive ? 'Yes, Deactivate' : 'Yes, Activate';
    btn.className    = 'btn-confirm-ok ' + (isActive ? 'btn-danger' : 'btn-success');
    document.getElementById('confirmOverlay').classList.add('open');
}
function closeConfirm() {
    document.getElementById('confirmOverlay').classList.remove('open');
    _pendingFormId = null;
}
function submitToggle() {
    if (_pendingFormId) document.getElementById(_pendingFormId).submit();
}
document.getElementById('confirmOverlay').addEventListener('click', function(e) {
    if (e.target === this) closeConfirm();
});

/* ── Searchable Select Dropdown ─────────────────────── */
function toggleSelectDropdown(trigger) {
    var panel = trigger.nextElementSibling;
    var isOpen = panel.style.display === 'block';
    document.querySelectorAll('.searchable-select-options-panel').forEach(function(p) { p.style.display = 'none'; });
    if (!isOpen) {
        panel.style.display = 'block';
        var searchInput = panel.querySelector('input[type="text"]');
        if (searchInput) { searchInput.value = ''; searchInput.focus(); }
        panel.querySelectorAll('.searchable-option-item').forEach(function(opt) { opt.style.display = ''; });
    }
}

function filterSelectOptions(input) {
    var filter = input.value.toLowerCase();
    var items = input.parentElement.querySelectorAll('.searchable-option-item');
    items.forEach(function(item) {
        var text = item.textContent.toLowerCase();
        item.style.display = text.indexOf(filter) > -1 ? '' : 'none';
    });
}

function selectOption(item, value) {
    var container = item.closest('.searchable-select-container');
    container.querySelector('.selected-text').textContent = item.textContent;
    container.querySelector('.hidden-select-value').value = value;
    container.querySelector('.searchable-select-options-panel').style.display = 'none';
}

document.addEventListener('click', function(e) {
    if (!e.target.closest('.searchable-select-container')) {
        document.querySelectorAll('.searchable-select-options-panel').forEach(function(p) { p.style.display = 'none'; });
    }
});

/* ── Bulk Import JS ─────────────────────────────────────────────────── */
var importFileObj = null;

function closeBulkImportModal() {
  document.getElementById('bulkImportModal').classList.remove('open');
  resetImportModal();
}

function resetImportModal() {
  importFileObj = null;
  document.getElementById('importFileName').textContent = 'No file selected';
  document.getElementById('importFileInput').value = '';
  document.getElementById('importDropZone').style.borderColor = '#c4b5fd';
  document.getElementById('importProgressWrap').style.display = 'none';
  document.getElementById('importProgressBar').style.width = '0';
  document.getElementById('importSummary').style.display = 'none';
  document.getElementById('importErrorBtns').style.display = 'none';
  document.getElementById('btnUploadImport').disabled = false;
}

function handleImportFileChange(input) {
  if (input.files && input.files[0]) {
    importFileObj = input.files[0];
    document.getElementById('importFileName').textContent = importFileObj.name;
    document.getElementById('importDropZone').style.borderColor = '#7c3aed';
  }
}

function handleImportDrop(event) {
  event.preventDefault();
  var files = event.dataTransfer.files;
  if (files && files[0]) {
    importFileObj = files[0];
    document.getElementById('importFileName').textContent = importFileObj.name;
    document.getElementById('importDropZone').style.borderColor = '#7c3aed';
  }
}

function submitImportFile() {
  if (!importFileObj) {
    showImportError('Please select a file before uploading.');
    return;
  }
  var name = importFileObj.name;
  if (!name.endsWith('.xlsx') && !name.endsWith('.xls')) {
    showImportError('Only .xlsx or .xls files are accepted.');
    return;
  }

  // Show progress
  document.getElementById('importProgressWrap').style.display = 'block';
  document.getElementById('importSummary').style.display = 'none';
  document.getElementById('btnUploadImport').disabled = true;
  animateProgress();

  var formData = new FormData();
  formData.append('file', importFileObj);

  fetch('${pageContext.request.contextPath}/clients/import/upload', {
    method: 'POST',
    body: formData,
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    clearInterval(window._importTimerId);
    document.getElementById('importProgressBar').style.width = '100%';
    document.getElementById('importProgressText').textContent = 'Done!';

    if (data.error) {
      setTimeout(function() {
        document.getElementById('importProgressWrap').style.display = 'none';
        showImportError(data.error);
        document.getElementById('btnUploadImport').disabled = false;
      }, 400);
      return;
    }

    setTimeout(function() {
      document.getElementById('importProgressWrap').style.display = 'none';
      document.getElementById('sumTotal').textContent   = data.total   || 0;
      document.getElementById('sumSuccess').textContent = data.success || 0;
      document.getElementById('sumFailed').textContent  = data.failed  || 0;
      document.getElementById('importSummary').style.display = 'block';
      if (data.failed && data.failed > 0) {
        document.getElementById('importErrorBtns').style.display = 'block';
      }
    }, 500);
  })
  .catch(function(err) {
    clearInterval(window._importTimerId);
    document.getElementById('importProgressWrap').style.display = 'none';
    document.getElementById('btnUploadImport').disabled = false;
    showImportError('Network error. Please try again.');
  });
}

function animateProgress() {
  var bar = document.getElementById('importProgressBar');
  var pct = 5;
  window._importTimerId = setInterval(function() {
    pct = Math.min(pct + (Math.random() * 8), 90);
    bar.style.width = pct + '%';
  }, 300);
}

function showImportError(msg) {
  // Reuse existing confirm-overlay pattern
  var el = document.createElement('div');
  el.style.cssText = 'position:fixed;inset:0;background:rgba(15,23,42,.55);backdrop-filter:blur(3px);z-index:9999;display:flex;justify-content:center;align-items:center;';
  el.innerHTML = '<div style="background:#fff;border-radius:16px;padding:32px 28px;width:360px;max-width:92%;box-shadow:0 20px 60px rgba(0,0,0,.2);text-align:center;">'
    + '<div style="font-size:2.2rem;margin-bottom:10px;">&#9888;&#65039;</div>'
    + '<div style="font-size:1rem;font-weight:700;color:#1e293b;margin-bottom:8px;">Import Error</div>'
    + '<div style="font-size:0.88rem;color:#64748b;margin-bottom:20px;line-height:1.5;">' + msg + '</div>'
    + '<button onclick="this.closest(\'.fixed\') && this.parentElement.parentElement.remove()" style="padding:9px 24px;background:#4f46e5;color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;">OK</button>'
    + '</div>';
  el.onclick = function(e) { if(e.target===el) el.remove(); };
  el.querySelector('button').onclick = function() { el.remove(); };
  document.body.appendChild(el);
}
</script>
</body>
</html>
