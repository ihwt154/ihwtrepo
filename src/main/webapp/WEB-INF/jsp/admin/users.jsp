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
        /* Modern Obsidian Glassmorphism and Gold accents */
        :root {
            --gold-primary: #b39254;
            --gold-hover: #96773f;
            --gold-light: rgba(179, 146, 84, 0.1);
        }

        .user-mgmt-container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 24px;
        }

        /* ── Views Toggling ────────────────────────────────────── */
        #user-list-view, #user-form-view {
            transition: all 0.3s ease;
        }

        /* ── Bento & Table Styles ────────────────────────────── */
        .bento-card-table {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            margin-top: 20px;
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .admin-table th, .admin-table td {
            padding: 14px 18px;
            text-align: left;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
        }

        .admin-table th {
            background-color: #f8fafc;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
        }

        .admin-table tbody tr:hover {
            background-color: #f8fafc;
        }

        /* ── Beautiful Form Card Styles ────────────────────────── */
        .user-form-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 36px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
            margin-top: 20px;
        }

        .form-section-title {
            font-size: 24px;
            font-weight: 700;
            color: #0f172a;
            text-align: center;
            margin-bottom: 30px;
            letter-spacing: -0.5px;
        }

        /* 4 Column Grid Layout */
        .form-grid-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 20px;
        }

        .form-grid-row:last-of-type {
            border-bottom: none;
            padding-bottom: 0;
            margin-bottom: 15px;
        }

        /* Span Full Width (4 columns) */
        .form-span-full {
            grid-column: span 4;
        }

        .form-field-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-field-group label {
            font-size: 13px;
            font-weight: 600;
            color: #475569;
        }

        .form-field-group label .required-asterisk {
            color: #ef4444;
            margin-left: 2px;
        }

        .form-field-group input,
        .form-field-group select,
        .form-field-group textarea {
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 14px;
            color: #0f172a;
            background: #f8fafc;
            outline: none;
            transition: all 0.2s ease;
            width: 100%;
        }

        .form-field-group input:focus,
        .form-field-group select:focus,
        .form-field-group textarea:focus {
            border-color: var(--gold-primary);
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(179, 146, 84, 0.15);
        }

        .form-field-group textarea {
            min-height: 80px;
            resize: vertical;
        }

        /* ── Toggle Button Groups ──────────────────────────────── */
        .toggle-btn-group {
            display: flex;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            overflow: hidden;
            background: #f8fafc;
            height: 40px;
        }

        .toggle-btn {
            flex: 1;
            border: none;
            background: none;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            transition: all 0.2s ease;
            outline: none;
            text-align: center;
            line-height: 38px;
            padding: 0;
        }

        .toggle-btn.active {
            background: var(--gold-primary);
            color: #ffffff;
        }

        /* ── Action Buttons ────────────────────────────────────── */
        .btn-gold {
            background: var(--gold-primary);
            color: #ffffff;
            border: none;
            padding: 11px 26px;
            border-radius: 6px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s ease;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }

        .btn-gold:hover {
            background: var(--gold-hover);
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
            background-color: rgba(239, 68, 68, 0.1);
            color: #EF4444;
        }

        .btn-toggle-deactivate:hover {
            background-color: #EF4444;
            color: #ffffff;
        }

        .btn-toggle-activate {
            background-color: rgba(16, 185, 129, 0.1);
            color: #10B981;
        }

        .btn-toggle-activate:hover {
            background-color: #10B981;
            color: #ffffff;
        }

        .btn-edit-action {
            background-color: var(--gold-light);
            color: var(--gold-primary);
            margin-left: 6px;
        }

        .btn-edit-action:hover {
            background-color: var(--gold-primary);
            color: #ffffff;
        }

        .form-actions-row {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 25px;
        }

        .badge-active {
            background: rgba(16, 185, 129, 0.12);
            color: #059669;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-inactive {
            background: rgba(245, 158, 11, 0.12);
            color: #D97706;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>

    <div class="user-mgmt-container">
        
        <!-- ── VIEW 1: USER LIST DIRECTORY ─────────────────────────── -->
        <div id="user-list-view">
            <div class="welcome-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <div>
                    <h2 style="font-size: 26px; font-weight: 700; letter-spacing: -0.5px;">User Directory</h2>
                    <p style="color: var(--text-secondary); font-size: 14px; margin-top: 4px;">Manage system access, assign roles, and monitor user statuses.</p>
                </div>
                <div>
                    <button type="button" class="btn-gold" onclick="addNewUser()">+ Add User</button>
                </div>
            </div>

            <div class="bento-card-table">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Full Name</th>
                            <th>Username</th>
                            <th>Email Address</th>
                            <th>Designation</th>
                            <th>Role / Type</th>
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
                                <td><c:out value="${u.designation != null ? u.designation : '—'}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.hasRole('SUPERADMIN')}">
                                            <span style="color: var(--gold-primary); font-weight: 700;">SUPER ADMIN</span>
                                        </c:when>
                                        <c:when test="${u.hasRole('ADMIN')}">
                                            <span style="color: var(--accent-teal); font-weight: 600;">ADMIN</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--text-secondary);">USER</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.active}">
                                            <span class="badge-active">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-inactive">Inactive</span>
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
                                    </c:if>
                                    <!-- Edit Button (with dataset coordinates) -->
                                    <button type="button" class="btn-action btn-edit-action"
                                            data-id="${u.id}"
                                            data-username="<c:out value="${u.username}"/>"
                                            data-email="<c:out value="${u.email}"/>"
                                            data-firstname="<c:out value="${u.firstName}"/>"
                                            data-lastname="<c:out value="${u.lastName}"/>"
                                            data-companyemail="<c:out value="${u.companyEmail}"/>"
                                            data-companymobile="<c:out value="${u.companyMobile}"/>"
                                            data-designation="<c:out value="${u.designation}"/>"
                                            data-dob="${u.htmlDob}"
                                            data-doj="${u.htmlDoj}"
                                            data-lastworkingday="${u.htmlLastWorkingDay}"
                                            data-mobile="<c:out value="${u.mobile}"/>"
                                            data-address="<c:out value="${u.address}"/>"
                                            data-active="${u.active}"
                                            data-accountlock="${u.accountLock}"
                                            data-remarks="<c:out value="${u.remarks}"/>"
                                            data-usertype="${u.hasRole('SUPERADMIN') ? 'SUPERADMIN' : (u.hasRole('ADMIN') ? 'ADMIN' : 'USER')}"
                                            onclick="editUser(this)">
                                        Edit
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ── VIEW 2: ADD / EDIT USER FORM (Redesigned) ───────────── -->
        <div id="user-form-view" style="display: none;">
            <div class="user-form-card">
                <h3 id="form-title" class="form-section-title">Add User</h3>
                
                <form action="${pageContext.request.contextPath}/admin/users/save" method="post" id="userForm">
                    <input type="hidden" name="id" id="form-id" value="">

                    <!-- Row 1: Credentials & Type -->
                    <div class="form-grid-row">
                        <div class="form-field-group">
                            <label for="form-username">User Name <span class="required-asterisk">*</span></label>
                            <input type="text" id="form-username" name="username" required autocomplete="off">
                        </div>
                        <div class="form-field-group">
                            <label for="form-password">Password <span class="required-asterisk" id="form-password-asterisk">*</span></label>
                            <input type="password" id="form-password" name="password" required>
                            <span id="form-password-help" style="font-size: 11px; color: #64748b; margin-top: 2px;"></span>
                        </div>
                        <div class="form-field-group">
                            <label for="form-password-confirm">Confirm Password <span class="required-asterisk" id="form-password-confirm-asterisk">*</span></label>
                            <input type="password" id="form-password-confirm" required>
                        </div>
                        <div class="form-field-group" id="user-type-container">
                            <label>User Type</label>
                            <div class="toggle-btn-group" id="user-type-toggles">
                                <button type="button" class="toggle-btn active" id="btn-type-user" onclick="setUserType('USER')">USER</button>
                                <button type="button" class="toggle-btn" id="btn-type-admin" onclick="setUserType('ADMIN')">ADMIN</button>
                            </div>
                            <div id="user-type-text" style="display: none; line-height: 40px; font-weight: 700; color: var(--gold-primary); text-transform: uppercase;">
                                SUPER ADMIN
                            </div>
                            <input type="hidden" name="userType" id="form-userType" value="USER">
                        </div>
                    </div>

                    <!-- Row 2: Workplace Details -->
                    <div class="form-grid-row">
                        <div class="form-field-group">
                            <label for="form-fullName">User Full Name <span class="required-asterisk">*</span></label>
                            <input type="text" id="form-fullName" name="fullName" required>
                        </div>
                        <div class="form-field-group">
                            <label for="form-companyEmail">Company Email <span class="required-asterisk">*</span></label>
                            <input type="email" id="form-companyEmail" name="companyEmail" required>
                        </div>
                        <div class="form-field-group">
                            <label for="form-companyMobile">Company Mobile <span class="required-asterisk">*</span></label>
                            <input type="text" id="form-companyMobile" name="companyMobile" required>
                        </div>
                        <div class="form-field-group">
                            <label for="form-designation">Designation</label>
                            <input type="text" id="form-designation" name="designation">
                        </div>
                    </div>

                    <!-- Row 3: Personal Details -->
                    <div class="form-grid-row">
                        <div class="form-field-group">
                            <label for="form-dob">Date of Birth <span class="required-asterisk">*</span></label>
                            <input type="date" id="form-dob" name="dob" required>
                        </div>
                        <div class="form-field-group">
                            <label for="form-email">Personal Email</label>
                            <input type="email" id="form-email" name="email">
                        </div>
                        <div class="form-field-group">
                            <label for="form-mobile">Personal Phone <span class="required-asterisk">*</span></label>
                            <input type="text" id="form-mobile" name="mobile" required>
                        </div>
                        <div class="form-field-group">
                            <label for="form-address">Address <span class="required-asterisk">*</span></label>
                            <input type="text" id="form-address" name="address" required>
                        </div>
                    </div>

                    <!-- Row 4: Account Details -->
                    <div class="form-grid-row">
                        <div class="form-field-group">
                            <label for="form-active">Active <span class="required-asterisk">*</span></label>
                            <select id="form-active" name="active" required>
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                            </select>
                        </div>
                        <div class="form-field-group">
                            <label>Account Lock</label>
                            <div class="toggle-btn-group">
                                <button type="button" class="toggle-btn" id="btn-lock-yes" onclick="setAccountLock(true)">Yes</button>
                                <button type="button" class="toggle-btn active" id="btn-lock-no" onclick="setAccountLock(false)">No</button>
                            </div>
                            <input type="hidden" name="accountLock" id="form-accountLock" value="false">
                        </div>
                        <div class="form-field-group">
                            <label for="form-doj">Date Of Joining <span class="required-asterisk">*</span></label>
                            <input type="date" id="form-doj" name="doj" required>
                        </div>
                        <div class="form-field-group">
                            <label for="form-lastWorkingDay">Last Working Day</label>
                            <input type="date" id="form-lastWorkingDay" name="lastWorkingDay">
                        </div>
                    </div>

                    <!-- Row 5: Remarks -->
                    <div class="form-grid-row">
                        <div class="form-field-group form-span-full">
                            <label for="form-remarks">Remarks</label>
                            <textarea id="form-remarks" name="remarks" placeholder="Enter remarks..."></textarea>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="form-actions-row">
                        <button type="submit" class="btn-gold" id="submit-btn-text">Add User</button>
                        <button type="button" class="btn-gold" style="background-color: #64748b;" onclick="showListView()">View User List</button>
                    </div>
                </form>
            </div>
        </div>

    </div>

    <script>
        /* ── Toggle Views ────────────────────────────────────────── */
        function showListView() {
            document.getElementById('user-list-view').style.display = 'block';
            document.getElementById('user-form-view').style.display = 'none';
        }

        function showFormView(title) {
            document.getElementById('form-title').textContent = title;
            document.getElementById('submit-btn-text').textContent = title;
            document.getElementById('user-list-view').style.display = 'none';
            document.getElementById('user-form-view').style.display = 'block';
        }

        /* ── Toggle Switches (User Type & Account Lock) ──────────── */
        function setUserType(type) {
            document.getElementById('form-userType').value = type;
            const toggles = document.getElementById('user-type-toggles');
            const textDisplay = document.getElementById('user-type-text');
            
            if (type === 'SUPERADMIN') {
                toggles.style.display = 'none';
                textDisplay.style.display = 'block';
            } else {
                toggles.style.display = 'flex';
                textDisplay.style.display = 'none';
                
                const btnUser = document.getElementById('btn-type-user');
                const btnAdmin = document.getElementById('btn-type-admin');
                
                if (type === 'ADMIN') {
                    btnUser.classList.remove('active');
                    btnAdmin.classList.add('active');
                } else {
                    btnUser.classList.add('active');
                    btnAdmin.classList.remove('active');
                }
            }
        }

        function setAccountLock(isLocked) {
            document.getElementById('form-accountLock').value = isLocked ? 'true' : 'false';
            const btnYes = document.getElementById('btn-lock-yes');
            const btnNo = document.getElementById('btn-lock-no');
            
            if (isLocked) {
                btnYes.classList.add('active');
                btnNo.classList.remove('active');
            } else {
                btnYes.classList.remove('active');
                btnNo.classList.add('active');
            }
        }

        /* ── Add User View Initialization ───────────────────────── */
        function addNewUser() {
            document.getElementById('form-id').value = '';
            
            document.getElementById('form-username').value = '';
            document.getElementById('form-username').removeAttribute('readonly');
            
            document.getElementById('form-password').value = '';
            document.getElementById('form-password').setAttribute('required', 'required');
            document.getElementById('form-password-asterisk').style.display = 'inline';
            
            document.getElementById('form-password-confirm').value = '';
            document.getElementById('form-password-confirm').setAttribute('required', 'required');
            document.getElementById('form-password-confirm-asterisk').style.display = 'inline';
            
            document.getElementById('form-password-help').textContent = '';

            document.getElementById('form-fullName').value = '';
            document.getElementById('form-companyEmail').value = '';
            document.getElementById('form-companyMobile').value = '';
            document.getElementById('form-designation').value = '';
            
            document.getElementById('form-dob').value = '';
            document.getElementById('form-email').value = '';
            document.getElementById('form-mobile').value = '';
            document.getElementById('form-address').value = '';
            
            document.getElementById('form-active').value = 'true';
            document.getElementById('form-doj').value = '';
            document.getElementById('form-lastWorkingDay').value = '';
            document.getElementById('form-remarks').value = '';

            setAccountLock(false);
            setUserType('USER');

            showFormView('Add User');
        }

        /* ── Edit User View Initialization ──────────────────────── */
        function editUser(btn) {
            const id = btn.getAttribute('data-id');
            const username = btn.getAttribute('data-username');
            const email = btn.getAttribute('data-email');
            const firstname = btn.getAttribute('data-firstname');
            const lastname = btn.getAttribute('data-lastname');
            const companyemail = btn.getAttribute('data-companyemail');
            const companymobile = btn.getAttribute('data-companymobile');
            const designation = btn.getAttribute('data-designation');
            const dob = btn.getAttribute('data-dob');
            const doj = btn.getAttribute('data-doj');
            const lastworkingday = btn.getAttribute('data-lastworkingday');
            const mobile = btn.getAttribute('data-mobile');
            const address = btn.getAttribute('data-address');
            const active = btn.getAttribute('data-active') === 'true';
            const accountlock = btn.getAttribute('data-accountlock') === 'true';
            const remarks = btn.getAttribute('data-remarks');
            const usertype = btn.getAttribute('data-usertype');

            // Populate form fields
            document.getElementById('form-id').value = id;
            
            document.getElementById('form-username').value = username;
            document.getElementById('form-username').setAttribute('readonly', 'readonly');
            
            // Password is optional during edit
            document.getElementById('form-password').value = '';
            document.getElementById('form-password').removeAttribute('required');
            document.getElementById('form-password-asterisk').style.display = 'none';
            
            document.getElementById('form-password-confirm').value = '';
            document.getElementById('form-password-confirm').removeAttribute('required');
            document.getElementById('form-password-confirm-asterisk').style.display = 'none';
            
            document.getElementById('form-password-help').textContent = 'Leave blank to keep existing';

            document.getElementById('form-fullName').value = (firstname + ' ' + lastname).trim();
            document.getElementById('form-companyEmail').value = companyemail;
            document.getElementById('form-companyMobile').value = companymobile;
            document.getElementById('form-designation').value = designation;
            
            document.getElementById('form-dob').value = dob;
            document.getElementById('form-email').value = email;
            document.getElementById('form-mobile').value = mobile;
            document.getElementById('form-address').value = address;
            
            document.getElementById('form-active').value = active ? 'true' : 'false';
            document.getElementById('form-doj').value = doj;
            document.getElementById('form-lastWorkingDay').value = lastworkingday;
            document.getElementById('form-remarks').value = remarks;

            setAccountLock(accountlock);
            setUserType(usertype);

            showFormView('Update User');
        }

        /* ── Submit Validation ─────────────────────────────────── */
        document.getElementById('userForm').addEventListener('submit', function(e) {
            const password = document.getElementById('form-password').value;
            const confirm = document.getElementById('form-password-confirm').value;
            const id = document.getElementById('form-id').value;
            
            if (password || !id) {
                if (password !== confirm) {
                    e.preventDefault();
                    alert('Passwords do not match.');
                }
            }
        });
    </script>
</body>
</html>
