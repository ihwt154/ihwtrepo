<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Edit Lead</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding:30px; max-width:900px; margin:0 auto;">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
        <h2 style="font-size:1.5rem; font-weight:700; color:var(--text-primary);">Edit Lead</h2>
        <a href="${pageContext.request.contextPath}/view_filter_leads" style="padding:9px 18px; background:#f1f5f9; color:#475569; border-radius:8px; text-decoration:none;">Back to Leads</a>
    </div>

    <div class="card" style="background:rgba(255,255,255,0.85); border-radius:16px; padding:32px; box-shadow:0 4px 24px rgba(0,0,0,0.08);">
        <form id="leadForm" action="${pageContext.request.contextPath}/edit_lead" method="post">
            <input type="hidden" name="leadId" value="${LEAD_OBJ.leadId}">

            <%-- Client --%>
            <div class="form-section-title" style="font-weight:600; color:var(--accent-primary); margin-bottom:16px; border-bottom:2px solid var(--accent-primary); padding-bottom:8px;">Client</div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Current Client</label>
                    <input type="text" id="clientSearch" value="${LEAD_OBJ.clientName}" autocomplete="off" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                    <input type="hidden" id="clientId" name="clientId" value="${LEAD_OBJ.clientId}">
                    <div id="clientDropdown" style="position:absolute;z-index:999;background:#fff;border:1px solid #e2e8f0;border-radius:8px;width:300px;display:none;max-height:200px;overflow-y:auto;"></div>
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Lead Name</label>
                    <input type="text" name="leadName" value="${LEAD_OBJ.leadName}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Lead Title</label>
                    <input type="text" name="leadTitle" value="${LEAD_OBJ.leadTitle}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
                <div>
                    <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Event Name</label>
                    <input type="text" name="eventName" value="${LEAD_OBJ.eventName}" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                </div>
            </div>

            <%-- Classification --%>
            <div class="form-section-title" style="font-weight:600; color:var(--accent-primary); margin:24px 0 16px; border-bottom:2px solid var(--accent-primary); padding-bottom:8px;">Classification</div>
            <div style="display:grid; grid-template-columns:1fr 1fr 1fr 1fr; gap:16px; margin-bottom:16px;">
                <div><label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Status</label>
                    <select name="leadStatus" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                        <c:forEach var="s" items="${LEAD_STATUSES}">
                            <option value="${s}" ${LEAD_OBJ.leadStatus == s ? 'selected' : ''}>${s}</option>
                        </c:forEach>
                    </select></div>

                <div><label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Priority</label>
                    <select name="priority" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                        <option value="">-- Priority --</option>
                        <c:forEach var="p" items="${PRIORITIES}">
                            <option value="${p}" ${LEAD_OBJ.priority == p ? 'selected' : ''}>${p}</option>
                        </c:forEach>
                    </select></div>
                <div><label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Lead Source</label>
                    <select name="leadSource" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                        <option value="">-- Select Source --</option>
                        <c:forEach var="src" items="${CLIENT_SOURCES}">
                            <option value="${src.sourceName}" ${LEAD_OBJ.leadSource == src.sourceName ? 'selected' : ''}>${src.sourceName}</option>
                        </c:forEach>
                    </select></div>
                <c:choose>
                    <c:when test="${CURRENT_USER.hasRole('ADMIN') || CURRENT_USER.hasRole('SUPERADMIN')}">
                        <div><label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Assigned To</label>
                            <select name="assignedTo" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                                <option value="">-- User --</option>
                                <c:forEach var="entry" items="${ACTIVE_USERS_MAP}">
                                    <option value="${entry.key}" ${LEAD_OBJ.assignedTo == entry.key ? 'selected' : ''}>${entry.value}</option>
                                </c:forEach>
                            </select></div>
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="assignedTo" value="${LEAD_OBJ.assignedTo != null ? LEAD_OBJ.assignedTo : CURRENT_USER.id}">
                    </c:otherwise>
                </c:choose>
            </div>

            <div style="margin-bottom:24px;">
                <label style="display:block;margin-bottom:4px;font-size:0.85rem;font-weight:600;color:#64748b;">Remarks</label>
                <textarea name="remarks" rows="3" style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;resize:vertical;">${LEAD_OBJ.remarks}</textarea>
            </div>

            <div style="display:flex; gap:12px; justify-content:flex-end;">
                <a href="${pageContext.request.contextPath}/view_filter_leads" style="padding:10px 24px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;">Cancel</a>
                <button type="submit" style="padding:10px 28px;background:var(--accent-primary);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;">Update Lead</button>
            </div>
        </form>
    </div>
</div>
<script>
(function() {
    const si = document.getElementById('clientSearch'), ci = document.getElementById('clientId'), dd = document.getElementById('clientDropdown');
    const ctx = '${pageContext.request.contextPath}';
    si.addEventListener('input', function() {
        const v = this.value.trim(); if (v.length < 2) { dd.style.display='none'; return; }
        fetch(ctx + '/getClientList?clientName=' + encodeURIComponent(v)).then(r=>r.json()).then(data => {
            dd.innerHTML=''; if (!data.length) { dd.style.display='none'; return; }
            data.forEach(c => { const d=document.createElement('div'); d.textContent=c.clientName+(c.city?' ('+c.city+')':''); d.style.cssText='padding:10px;cursor:pointer;border-bottom:1px solid #f1f5f9;'; d.addEventListener('click',()=>{ si.value=c.clientName; ci.value=c.clientId; dd.style.display='none'; }); dd.appendChild(d); });
            dd.style.display='block';
        });
    });
    si.addEventListener('blur', function() {
        setTimeout(() => {
            if (!ci.value) {
                si.value = '';
            }
        }, 200);
    });
    
    document.getElementById('leadForm').addEventListener('submit', function(e) {
        if (!ci.value) {
            e.preventDefault();
            alert('Please select a valid Client from the dropdown before updating the lead.');
            si.focus();
        }
    });

    document.addEventListener('click', e => { if (!e.target.closest('#clientSearch')) dd.style.display='none'; });
})();
</script>
</body>
</html>

