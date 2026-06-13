<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Lead Followups</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .followup-card { background:#fff; border-radius:12px; padding:18px 20px; border-left:4px solid var(--accent-primary); margin-bottom:12px; box-shadow:0 1px 6px rgba(0,0,0,0.05); }
        .followup-meta { font-size:0.78rem; color:#94a3b8; margin-bottom:8px; }
        .followup-section { font-size:0.85rem; color:#64748b; margin-bottom:4px; }
        .followup-content { font-size:0.9rem; color:#1e293b; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding:30px; max-width:900px; margin:0 auto;">

    <%-- Lead Header --%>
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
        <div>
            <h2 style="font-size:1.5rem; font-weight:700; color:var(--text-primary); margin:0;">Lead Followups</h2>
            <p style="color:#64748b; margin:4px 0 0;">
                <strong>${LEAD_OBJ.leadName}</strong>
                <c:if test="${not empty LEAD_OBJ.clientName}"> Â· ${LEAD_OBJ.clientName}</c:if>
                <c:if test="${not empty LEAD_OBJ.leadStatus}"> Â· <span style="background:#dbeafe;color:#1d4ed8;padding:2px 8px;border-radius:10px;font-size:0.78rem;">${LEAD_OBJ.leadStatus}</span></c:if>
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/view_filter_leads" style="padding:9px 18px;background:#f1f5f9;color:#475569;border-radius:8px;text-decoration:none;">â† All Leads</a>
    </div>

    <c:if test="${not empty success}"><div style="background:#d1fae5;color:#065f46;padding:12px;border-radius:8px;margin-bottom:16px;">${success}</div></c:if>

    <div style="display:grid; grid-template-columns:1fr 1.4fr; gap:24px;">

        <%-- Add Followup Form --%>
        <div style="background:rgba(255,255,255,0.9);border-radius:14px;padding:24px;box-shadow:0 2px 12px rgba(0,0,0,0.06);align-self:start;">
            <h3 style="font-size:1rem;font-weight:700;color:var(--accent-primary);margin-bottom:16px;border-bottom:2px solid var(--accent-primary);padding-bottom:8px;">Record Followup</h3>
            <form action="${pageContext.request.contextPath}/create_lead_followup" method="post">
                <input type="hidden" name="leadId" value="${LEAD_OBJ.leadId}">

                <div style="margin-bottom:14px;">
                    <label style="display:block;margin-bottom:4px;font-size:0.82rem;font-weight:600;color:#64748b;">Action Taken At <span style="color:red">*</span></label>
                    <input type="datetime-local" name="followuptime" required style="width:100%;padding:9px;border:1px solid #e2e8f0;border-radius:8px;font-size:0.9rem;">
                </div>
                <div style="margin-bottom:14px;">
                    <label style="display:block;margin-bottom:4px;font-size:0.82rem;font-weight:600;color:#64748b;">Response / Action Taken <span style="color:red">*</span></label>
                    <textarea name="response" rows="3" required style="width:100%;padding:9px;border:1px solid #e2e8f0;border-radius:8px;resize:vertical;font-size:0.9rem;"></textarea>
                </div>
                <div style="margin-bottom:14px;">
                    <label style="display:block;margin-bottom:4px;font-size:0.82rem;font-weight:600;color:#64748b;">Next Followup At</label>
                    <input type="datetime-local" name="nextfollowuptime" style="width:100%;padding:9px;border:1px solid #e2e8f0;border-radius:8px;font-size:0.9rem;">
                </div>
                <div style="margin-bottom:18px;">
                    <label style="display:block;margin-bottom:4px;font-size:0.82rem;font-weight:600;color:#64748b;">Next Action Plan</label>
                    <textarea name="nextactionplan" rows="2" style="width:100%;padding:9px;border:1px solid #e2e8f0;border-radius:8px;resize:vertical;font-size:0.9rem;"></textarea>
                </div>
                <button type="submit" style="width:100%;padding:11px;background:var(--accent-primary);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;font-size:0.9rem;">Save Followup</button>
            </form>
        </div>

        <%-- Followup History --%>
        <div>
            <h3 style="font-size:1rem;font-weight:700;color:var(--text-primary);margin-bottom:16px;">History (${FOLLOWUP_LIST.size()})</h3>
            <c:if test="${empty FOLLOWUP_LIST}">
                <div style="background:#f8fafc;border-radius:12px;padding:32px;text-align:center;color:#94a3b8;">No followups recorded yet.</div>
            </c:if>
            <c:forEach var="f" items="${FOLLOWUP_LIST}">
                <div class="followup-card">
                    <div class="followup-meta">
                        ðŸ• Action at: <strong>${f.formattedFollowupTime}</strong>
                        <c:if test="${not empty f.updatedByName}"> Â· by <strong>${f.updatedByName}</strong></c:if>
                    </div>
                    <div class="followup-section">Response:</div>
                    <div class="followup-content" style="margin-bottom:10px;">${f.response}</div>
                    <c:if test="${not empty f.formattedNextFollowupTime}">
                        <div class="followup-meta" style="margin-top:8px;">â­ Next followup: <strong>${f.formattedNextFollowupTime}</strong></div>
                        <div class="followup-section">Next Action:</div>
                        <div class="followup-content">${f.nextactionplan}</div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
</body>
</html>

