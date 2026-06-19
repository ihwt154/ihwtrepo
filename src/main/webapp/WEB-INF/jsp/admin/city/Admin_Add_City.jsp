<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM – Manage Cities</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .city-page { padding: 30px; max-width: 900px; margin: 0 auto; }

        /* ── Header ─────────────────────────────────────── */
        .city-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
        }
        .city-header h2 {
            font-size: 1.6rem;
            font-weight: 700;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin: 0;
        }
        .back-btn {
            padding: 9px 18px;
            background: #f1f5f9;
            color: #475569;
            border-radius: 9px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: background 0.18s;
        }
        .back-btn:hover { background: #e2e8f0; }

        /* ── Cards ──────────────────────────────────────── */
        .glass-card {
            background: rgba(255,255,255,0.92);
            border-radius: 18px;
            padding: 32px;
            box-shadow: 0 8px 32px rgba(99,102,241,0.10);
            border: 1px solid rgba(99,102,241,0.08);
            margin-bottom: 28px;
            backdrop-filter: blur(8px);
        }
        .card-title {
            font-size: 1rem;
            font-weight: 700;
            color: #6366f1;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            padding-bottom: 12px;
            border-bottom: 2px solid #ede9fe;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ── Form ───────────────────────────────────────── */
        .add-city-row {
            display: flex;
            gap: 12px;
            align-items: flex-end;
        }
        .add-city-row .fg { flex: 1; }
        .fg label {
            display: block;
            font-size: 11px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 7px;
        }
        .fg input {
            width: 100%;
            padding: 11px 14px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            color: #1e293b;
            background: #f8fafc;
            box-sizing: border-box;
            transition: all 0.2s;
            outline: none;
        }
        .fg input:focus {
            border-color: #6366f1;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.12);
        }
        .btn-add {
            padding: 11px 28px;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(99,102,241,0.35);
            transition: opacity 0.2s, transform 0.15s;
            white-space: nowrap;
        }
        .btn-add:hover { opacity: 0.88; transform: translateY(-1px); }
        .btn-add:active { transform: translateY(0); }

        /* ── Alerts ─────────────────────────────────────── */
        .alert-success {
            background: linear-gradient(135deg,#d1fae5,#a7f3d0);
            color: #065f46;
            padding: 12px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 600;
            border-left: 4px solid #059669;
        }
        .alert-error {
            background: linear-gradient(135deg,#fee2e2,#fecaca);
            color: #991b1b;
            padding: 12px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 600;
            border-left: 4px solid #dc2626;
        }

        /* ── Cities Table ───────────────────────────────── */
        .cities-table {
            width: 100%;
            border-collapse: collapse;
        }
        .cities-table thead tr {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
        }
        .cities-table thead th {
            color: #fff;
            padding: 12px 18px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            text-align: left;
        }
        .cities-table tbody tr {
            border-bottom: 1px solid #f1f5f9;
            transition: background 0.15s;
        }
        .cities-table tbody tr:hover { background: #f8f7ff; }
        .cities-table tbody tr:last-child { border-bottom: none; }
        .cities-table tbody td {
            padding: 13px 18px;
            font-size: 14px;
            color: #1e293b;
        }
        .city-badge {
            display: inline-block;
            padding: 4px 14px;
            background: #ede9fe;
            color: #6366f1;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .search-box {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            margin-bottom: 16px;
            box-sizing: border-box;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .search-box:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.1);
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #94a3b8;
            font-size: 14px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>

<div class="city-page">

    <div class="city-header">
        <h2>🏙️ City Management</h2>
        <a href="${pageContext.request.contextPath}/view_clients_list" class="back-btn">← Back to Clients</a>
    </div>

    <%-- Flash messages --%>
    <c:if test="${not empty success}">
        <div class="alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert-error">⚠️ ${error}</div>
    </c:if>

    <%-- ── Add City Form ─────────────────────────────────────── --%>
    <div class="glass-card">
        <div class="card-title">➕ Add New City</div>
        <form action="${pageContext.request.contextPath}/city/save" method="post">
            <div class="add-city-row">
                <div class="fg">
                    <label for="cityName">City Name <span style="color:#ef4444;">*</span></label>
                    <input type="text" id="cityName" name="name" placeholder="e.g. Mumbai, Delhi, Bangalore..."
                           required autocomplete="off"
                           style="font-size:15px;">
                </div>
                <button type="submit" class="btn-add">+ Add City</button>
            </div>
        </form>
    </div>

    <%-- ── Existing Cities ────────────────────────────────────── --%>
    <div class="glass-card">
        <div class="card-title">🗂️ All Cities <span style="background:#ede9fe;color:#6366f1;border-radius:20px;padding:2px 12px;font-size:12px;margin-left:8px;">${fn:length(ALL_CITIES)}</span></div>
        <c:choose>
            <c:when test="${not empty ALL_CITIES}">
                <input type="text" class="search-box" id="citySearch" placeholder="🔍 Search cities..." onkeyup="filterCities()">
                <div style="overflow:hidden;border-radius:12px;border:1px solid #f1f5f9;">
                    <table class="cities-table" id="citiesTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>City Name</th>
                                <th>ID</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="city" items="${ALL_CITIES}" varStatus="loop">
                                <tr>
                                    <td style="color:#94a3b8;font-size:13px;">${loop.index + 1}</td>
                                    <td><span class="city-badge">${city.name}</span></td>
                                    <td style="color:#94a3b8;font-size:12px;">#${city.id}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div style="font-size:3rem;margin-bottom:12px;">🏙️</div>
                    <div style="font-size:1rem;font-weight:600;color:#64748b;margin-bottom:6px;">No cities yet</div>
                    <div>Use the form above to add your first city.</div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
function filterCities() {
    var filter = document.getElementById('citySearch').value.toLowerCase();
    var rows = document.querySelectorAll('#citiesTable tbody tr');
    rows.forEach(function(row) {
        var text = row.textContent.toLowerCase();
        row.style.display = text.indexOf(filter) > -1 ? '' : 'none';
    });
}

// Auto-focus the input after page load
window.addEventListener('DOMContentLoaded', function() {
    var inp = document.getElementById('cityName');
    if (inp) inp.focus();
});
</script>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
</body>
</html>
