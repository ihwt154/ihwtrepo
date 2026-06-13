<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - Federation Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <!-- Main Workspace Dashboard Grid (Futuristic Bento Box Grid) -->
    <main class="dashboard-container">
        <!-- Welcome Banner Bento Card -->
        <section class="bento-card welcome-bento">
            <div class="banner-left">
                <h2>Welcome, Super Admin</h2>
                <p>IHWT Federation - Dashboard</p>
            </div>
            <div class="banner-right">
                <h3>IHWT Federation</h3>
                <span>★ ADMINISTRATOR VIEW</span>
            </div>
        </section>

        <!-- Stats Bento Card 1: Total Leads -->
        <section class="bento-card">
            <div>
                <div class="stats-header">
                    <span>Total Leads</span>
                    <span class="stats-icon">📄</span>
                </div>
                <div class="stats-number">${totalLeads}</div>
            </div>
            <div class="stats-trend" style="color: var(--text-secondary);">
                Active Database Registry
            </div>
        </section>

        <!-- Stats Bento Card 2: Qualified Leads -->
        <section class="bento-card">
            <div>
                <div class="stats-header">
                    <span>Qualified</span>
                    <span class="stats-icon">✓</span>
                </div>
                <div class="stats-number">${qualifiedLeads}</div>
            </div>
            <div class="stats-trend" style="color: var(--accent-emerald);">
                Interest & Budget Matches
            </div>
        </section>

        <!-- Stats Bento Card 3: Flagged/Follow-up Leads -->
        <section class="bento-card">
            <div>
                <div class="stats-header">
                    <span>Flagged</span>
                    <span class="stats-icon">🚩</span>
                </div>
                <div class="stats-number">${flaggedLeads}</div>
            </div>
            <div class="stats-trend" style="color: var(--accent-amber);">
                Pending Outreach Responses
            </div>
        </section>

        <!-- Lead Status Donut Chart Bento Box -->
        <section class="bento-card donut-bento">
            <h3 class="bento-card-title">Status Distribution</h3>
            <div class="chart-wrapper">
                <c:choose>
                    <c:when test="${totalLeads > 0}">
                        <div style="text-align: center; position: relative;">
                            <!-- SVG Donut Chart -->
                            <svg class="donut-svg" width="160" height="160" viewBox="0 0 32 32">
                                <circle class="donut-hole" cx="16" cy="16" r="12" fill="transparent"></circle>
                                <circle class="donut-ring" cx="16" cy="16" r="12" fill="transparent" stroke="rgba(15, 23, 42, 0.08)" stroke-width="5"></circle>
                                
                                <!-- Lost/Closed (Green) -->
                                <circle class="donut-segment" cx="16" cy="16" r="12" fill="transparent" stroke="var(--accent-emerald)" stroke-width="5" stroke-dasharray="${lostPercent} 100" stroke-dashoffset="0"></circle>
                                <!-- WIP (Charcoal/Secondary) -->
                                <circle class="donut-segment" cx="16" cy="16" r="12" fill="transparent" stroke="var(--text-secondary)" stroke-width="5" stroke-dasharray="${contactedPercent} 100" stroke-dashoffset="-${lostPercent}"></circle>
                                <!-- Open (Amber) -->
                                <circle class="donut-segment" cx="16" cy="16" r="12" fill="transparent" stroke="var(--accent-amber)" stroke-width="5" stroke-dasharray="${newPercent} 100" stroke-dashoffset="-${lostPercent + contactedPercent}"></circle>
                            </svg>
                            <div style="position: absolute; top: 40%; left: 0; width: 100%; text-align: center;">
                                <span style="font-size: 24px; font-weight: 700; color: var(--text-primary);">${totalLeads}</span><br>
                                <span style="font-size: 10px; color: var(--text-secondary); text-transform: uppercase;">Leads</span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-chart-text">
                            No lead data available.<br>Create leads to view distribution.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${totalLeads > 0}">
                <div class="chart-legend">
                    <div class="legend-item">
                        <div class="legend-dot" style="background-color: var(--accent-amber);"></div> Open (${newPercent}%)
                    </div>
                    <div class="legend-item">
                        <div class="legend-dot" style="background-color: var(--text-secondary);"></div> WIP (${contactedPercent}%)
                    </div>
                    <div class="legend-item">
                        <div class="legend-dot" style="background-color: var(--accent-emerald);"></div> Closed (${lostPercent}%)
                    </div>
                </div>
            </c:if>
        </section>

        <!-- Lead Bar Chart Bento Box (2 Cols) -->
        <section class="bento-card bar-bento">
            <h3 class="bento-card-title">All Leads - Status Breakdown</h3>
            <div class="chart-wrapper" style="align-items: stretch;">
                <c:choose>
                    <c:when test="${totalLeads > 0}">
                        <div class="bar-chart-container">
                            <!-- Bar 1 (Open) -->
                            <div class="bar-column">
                                <span class="bar-value">${newLeads}</span>
                                <div class="bar-pill" style="height: ${newPercent > 0 ? (newPercent * 1.5) : 8}px; min-height: 8px; background-color: var(--accent-amber);"></div>
                                <span class="bar-label">Open</span>
                            </div>
                            <!-- Bar 2 (WIP) -->
                            <div class="bar-column">
                                <span class="bar-value">${contactedLeads}</span>
                                <div class="bar-pill" style="height: ${contactedPercent > 0 ? (contactedPercent * 1.5) : 8}px; min-height: 8px; background-color: var(--text-secondary);"></div>
                                <span class="bar-label">Work In Progress</span>
                            </div>
                            <!-- Bar 3 (Failed-Closed) -->
                            <div class="bar-column">
                                <span class="bar-value">${lostLeads}</span>
                                <div class="bar-pill" style="height: ${lostPercent > 0 ? (lostPercent * 1.5) : 8}px; min-height: 8px; background-color: var(--accent-emerald);"></div>
                                <span class="bar-label">Failed-Closed</span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-chart-text" style="margin: auto;">
                            No lead metrics found in the registry.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- Quick Actions Bento Section (Spans 3 Cols) -->
        <section class="bento-card actions-bento">
            <h3 class="bento-card-title">Quick System Actions</h3>
            <div class="actions-grid">
                <a href="#" class="bento-action-btn">
                    <span class="bento-action-icon">➕</span>
                    <div class="bento-action-details">
                        <h4>New Lead</h4>
                        <p>Register a new federation lead profile</p>
                    </div>
                </a>
                <a href="#" class="bento-action-btn">
                    <span class="bento-action-icon">🔍</span>
                    <div class="bento-action-details">
                        <h4>Manage Leads</h4>
                        <p>View directory & track conversion status</p>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="bento-action-btn">
                    <span class="bento-action-icon">👤</span>
                    <div class="bento-action-details">
                        <h4>User Management</h4>
                        <p>Manage admin & agent user profiles</p>
                    </div>
                </a>
            </div>
        </section>
    </main>
</body>
</html>
