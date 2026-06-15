<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal.username" var="currentUser" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IHWT CRM - User Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Extra User Management Specific CSS integrated with Obsidian Glassmorphism */
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background: rgba(15, 23, 42, 0.45);
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid var(--border-glow);
        }
        .admin-table th, .admin-table td {
            padding: 16px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        }
        .admin-table th {
            background-color: rgba(15, 23, 42, 0.8);
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-secondary);
        }
        .admin-table tr:last-child td {
            border-bottom: none;
        }
        .admin-table tbody tr {
            transition: background-color var(--transition-speed);
        }
        .admin-table tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.02);
        }
        .user-mgmt-grid {
            grid-column: span 3;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
        }
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-glow);
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            transition: border-color var(--transition-speed);
        }
        .form-card:hover {
            border-color: var(--border-glow-hover);
        }
        .form-card h3 {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            padding-bottom: 10px;
            color: #ffffff;
        }
        .form-card .form-group label {
            color: var(--text-secondary);
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .form-card .form-group input {
            border: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(10, 15, 30, 0.4);
            color: #ffffff;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            width: 100%;
            margin-bottom: 18px;
            outline: none;
            transition: all var(--transition-speed);
        }
        .form-card .form-group input:focus {
            border-color: var(--accent-amber);
            background: rgba(10, 15, 30, 0.6);
            box-shadow: 0 0 10px rgba(245, 158, 11, 0.15);
        }
        .btn-action {
            background: none;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            padding: 6px 12px;
            border-radius: 6px;
            transition: all 0.2s ease;
        }
        .btn-toggle-deactivate {
            background-color: rgba(239, 68, 68, 0.15);
            color: #F87171;
        }
        .btn-toggle-deactivate:hover {
            background-color: #EF4444;
            color: #ffffff;
        }
        .btn-toggle-activate {
            background-color: rgba(16, 185, 129, 0.15);
            color: #34D399;
        }
        .btn-toggle-activate:hover {
            background-color: #10B981;
            color: #ffffff;
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>

    <!-- Main Workspace User Directory Grid -->
    <main class="dashboard-container">
        <div class="welcome-header" style="grid-column: span 3; margin-bottom: 10px;">
            <h2 style="font-size: 26px; font-weight: 700; letter-spacing: -0.5px;">User Directory</h2>
            <p style="color: var(--text-secondary); font-size: 14px; margin-top: 4px;">Manage system access, create new administrator or agent profiles, and monitor login states.</p>
        </div>

        <div class="user-mgmt-grid">
            <!-- Users List -->
            <section class="bento-card" style="padding: 24px; justify-content: flex-start;">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td><strong style="color: var(--text-primary);"><c:out value="${u.firstName}"/> <c:out value="${u.lastName}"/></strong></td>
                                <td><c:out value="${u.username}"/></td>
                                <td><c:out value="${u.email}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.active}">
                                            <span class="badge badge-active">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-warning">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${u.username != currentUser}">
                                        <form action="${pageContext.request.contextPath}/admin/users/toggle" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${u.id}">
                                            <c:choose>
                                                <c:when test="${u.active}">
                                                    <button type="submit" class="btn-action btn-toggle-deactivate">Deactivate</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="submit" class="btn-action btn-toggle-activate">Activate</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                        <!-- Edit button -->
                                        <button type="button" class="btn-action btn-edit" onclick="populateEditForm(${u.id}, '${u.username}', '${u.email}', '${u.firstName}', '${u.lastName}')">Edit</button>
                                    </c:if>
                                    <c:if test="${u.username == currentUser}">
                                        <span style="font-size:12px; color:var(--text-secondary); font-style:italic;">Logged In</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

            <!-- Add User Form -->
            <section class="form-card">
                <h3>Create User Profile</h3>
                <form action="${pageContext.request.contextPath}/admin/users/save" method="post">
<input type="hidden" name="id" id="form-id" value="">
<div class="form-group">
    <label for="form-username">Username</label>
    <input type="text" id="form-username" name="username" required autocomplete="off">
</div>
<div class="form-group">
    <label for="form-password">Password</label>
    <input type="password" id="form-password" name="password" required>
</div>
<div class="form-group">
    <label for="form-email">Email Address</label>
    <input type="email" id="form-email" name="email" required>
</div>
<div class="form-group">
    <label for="form-firstname">First Name</label>
    <input type="text" id="form-firstname" name="firstName" required>
</div>
<div class="form-group">
    <label for="form-lastname">Last Name</label>
    <input type="text" id="form-lastname" name="lastName" required>
</div>
<button type="submit" class="btn-primary" style="margin-top: 10px; width: 100%; padding: 12px; border: none; border-radius: 8px; color: white; font-weight: 600; cursor: pointer; transition: all var(--transition-speed);">Create Account</button>
</form>
<script>
function populateEditForm(id, username, email, firstName, lastName) {
    document.getElementById('form-id').value = id;
    document.getElementById('form-username').value = username;
    document.getElementById('form-email').value = email;
    document.getElementById('form-firstname').value = firstName;
    document.getElementById('form-lastname').value = lastName;
    // Optionally change button text to 'Update Account'
    const btn = document.querySelector('.form-card .btn-primary');
    btn.textContent = 'Update Account';
}
</script>
            </section>
        </div>
    </main>
</body>
</html>

