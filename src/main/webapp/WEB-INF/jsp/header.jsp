<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- ===== HEADER ===== -->
<header class="gs-header">
    <%-- Back Button Integration: Shows on all pages except the main home dashboard --%>
    <c:if test="${not fn:contains(pageContext.request.requestURI, 'dashboard')}">
        <a href="javascript:history.back()" class="gs-back-btn" title="Go Back">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 12H5M12 19l-7-7 7-7"/>
            </svg>
        </a>
    </c:if>
    
    <a href="${pageContext.request.contextPath}/dashboard" class="gs-header-brand">
        <img id="topLogo" src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo">
        <div class="gs-header-title">
            International Chamber of Healthcare & Medical Tourism
        </div>
    </a>

    <div class="gs-header-user" style="margin-left: auto;">
        <span>Welcome, <strong>
                <sec:authentication property="principal.username" />
            </strong></span>
        <div class="gs-user-avatar">
            <sec:authentication property="principal.username" var="currentUser" scope="page" />
            ${fn:toUpperCase(fn:substring(currentUser, 0, 1))}
        </div>
    </div>
</header>

<!-- ===== NAVIGATION ===== -->
<nav class="gs-nav">
    <ul class="gs-nav-list">
        <%-- Lead Management --%>
        <sec:authorize access="hasAnyRole('ADMIN','LEADS_MANAGE')">
            <li class="gs-nav-item">
                <a href="#" class="gs-nav-link">Lead Management</a>
                <ul class="gs-dropdown">
                    <li><a href="${pageContext.request.contextPath}/view_add_lead_form" class="gs-dropdown-item">Add New Lead</a></li>
                    <li><a href="${pageContext.request.contextPath}/view_filter_leads" class="gs-dropdown-item">Manage Leads</a></li>
                </ul>
            </li>
        </sec:authorize>

        <%-- User Management --%>
        <sec:authorize access="hasAnyRole('ADMIN','USER_MANAGE')">
            <li class="gs-nav-item">
                <a href="#" class="gs-nav-link">User Management</a>
                <ul class="gs-dropdown">
                    <li><a href="${pageContext.request.contextPath}/admin/users" class="gs-dropdown-item">Add User</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/users" class="gs-dropdown-item">Manage Users</a></li>
                </ul>
            </li>
        </sec:authorize>

        <%-- Client Management --%>
        <sec:authorize access="hasAnyRole('ADMIN','CLIENT_CREATE','CLIENT_MANAGE')">
            <li class="gs-nav-item">
                <a href="#" class="gs-nav-link">Client Management</a>
                <ul class="gs-dropdown">
                    <li><a href="${pageContext.request.contextPath}/view_add_client_form" class="gs-dropdown-item">Add Client</a></li>
                    <li><a href="${pageContext.request.contextPath}/view_clients_list" class="gs-dropdown-item">Manage Clients</a></li>
                </ul>
            </li>
        </sec:authorize>

        <%-- Logout --%>
        <li class="gs-nav-item gs-nav-logout" style="margin-left: auto;">
            <a href="${pageContext.request.contextPath}/logout" class="gs-nav-link">Logout</a>
        </li>

        <%-- Settings --%>
        <li class="gs-nav-item gs-nav-settings">
            <a href="${pageContext.request.contextPath}/view_form_manage_central_config" class="gs-nav-link" title="Settings">&#9881;</a>
        </li>
    </ul>
</nav>

