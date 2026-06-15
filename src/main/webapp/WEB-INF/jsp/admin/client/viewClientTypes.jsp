<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Client Types</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .type-table { width:100%; border-collapse:collapse; }
        .type-table th { background:var(--accent-primary); color:#fff; padding:12px 16px; text-align:left; font-size:0.8rem; text-transform:uppercase; letter-spacing:.05em; }
        .type-table td { padding:12px 16px; border-bottom:1px solid #f1f5f9; font-size:0.9rem; }
        .type-table tr:hover td { background:#f8fafc; }
        .badge-active { background:#d1fae5; color:#065f46; padding:3px 10px; border-radius:20px; font-size:0.75rem; font-weight:600; }
        .badge-inactive { background:#fee2e2; color:#991b1b; padding:3px 10px; border-radius:20px; font-size:0.75rem; font-weight:600; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<div class="page-container" style="padding:30px;">

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
        <h2 style="font-size:1.5rem;font-weight:700;color:var(--text-primary);">Manage Client Types</h2>
        <button onclick="openModal()" style="padding:10px 20px;background:var(--accent-primary);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;">+ Add Type</button>
    </div>

    <c:if test="${not empty success}"><div style="background:#d1fae5;color:#065f46;padding:12px;border-radius:8px;margin-bottom:16px;">${success}</div></c:if>
    <c:if test="${not empty error}"><div style="background:#fee2e2;color:#991b1b;padding:12px;border-radius:8px;margin-bottom:16px;">${error}</div></c:if>

    <div style="background:rgba(255,255,255,0.85);border-radius:14px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.06);">
        <table class="type-table">
            <thead>
                <tr><th>#</th><th>Type Name</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <c:if test="${empty TYPE_LIST}">
                    <tr><td colspan="4" style="text-align:center;padding:40px;color:#94a3b8;">No client types found. Add your first type.</td></tr>
                </c:if>
                <c:forEach var="tp" items="${TYPE_LIST}" varStatus="st">
                    <tr>
                        <td style="color:#94a3b8;font-size:0.8rem;">${st.index + 1}</td>
                        <td><strong>${tp.typeName}</strong></td>
                        <td>
                            <c:choose>
                                <c:when test="${tp.active}"><span class="badge-active">Active</span></c:when>
                                <c:otherwise><span class="badge-inactive">Inactive</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div style="display:flex;gap:6px;">
                                <button onclick="openEditModal('${tp.id}','${tp.typeName}')"
                                        style="padding:5px 12px;background:#dbeafe;color:#1d4ed8;border:1px solid #bfdbfe;border-radius:6px;cursor:pointer;font-size:0.78rem;font-weight:600;">Edit</button>
                                <form method="post" action="${pageContext.request.contextPath}/admin/client/types/toggle" style="display:inline;" onsubmit="return confirm('Toggle status?');">
                                    <input type="hidden" name="id" value="${tp.id}">
                                    <button type="submit"
                                            style="padding:5px 12px;background:${tp.active ? '#fee2e2' : '#d1fae5'};color:${tp.active ? '#b91c1c' : '#065f46'};border:1px solid ${tp.active ? '#fca5a5' : '#a7f3d0'};border-radius:6px;cursor:pointer;font-size:0.78rem;font-weight:600;">
                                        ${tp.active ? 'Deactivate' : 'Activate'}
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal -->
<div id="typeModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:1000;justify-content:center;align-items:center;">
    <div style="background:#fff;border-radius:14px;padding:30px;width:400px;max-width:90%;box-shadow:0 10px 40px rgba(0,0,0,0.2);">
        <h3 id="modalTitle" style="margin:0 0 20px;font-size:1.2rem;font-weight:700;color:var(--text-primary);">Add Client Type</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/client/types/save">
            <input type="hidden" id="typeId" name="id">
            <div style="margin-bottom:16px;">
                <label style="font-size:0.8rem;font-weight:600;color:#64748b;display:block;margin-bottom:4px;">Type Name</label>
                <input type="text" id="typeNameInput" name="typeName" required
                       style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;font-size:0.9rem;">
            </div>
            <div style="display:flex;gap:8px;justify-content:flex-end;">
                <button type="button" onclick="closeModal()" style="padding:8px 16px;background:#f1f5f9;color:#475569;border:none;border-radius:8px;cursor:pointer;font-weight:600;">Cancel</button>
                <button type="submit" style="padding:8px 16px;background:var(--accent-primary);color:#fff;border:none;border-radius:8px;cursor:pointer;font-weight:600;">Save</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal() {
        document.getElementById('modalTitle').textContent = 'Add Client Type';
        document.getElementById('typeId').value = '';
        document.getElementById('typeNameInput').value = '';
        document.getElementById('typeModal').style.display = 'flex';
    }
    function openEditModal(id, name) {
        document.getElementById('modalTitle').textContent = 'Edit Client Type';
        document.getElementById('typeId').value = id;
        document.getElementById('typeNameInput').value = name;
        document.getElementById('typeModal').style.display = 'flex';
    }
    function closeModal() {
        document.getElementById('typeModal').style.display = 'none';
    }
    document.getElementById('typeModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>
</body>
</html>
