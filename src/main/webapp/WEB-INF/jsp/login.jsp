<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty centralConfig.companyName}">
                ${centralConfig.companyName} - Secure Login
            </c:when>
            <c:otherwise>
                IHWT CRM - Secure Login
            </c:otherwise>
        </c:choose>
    </title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #D97706; /* Golden amber accent */
            --primary-hover: #B45309;
            --text-main: #0f172a;
            --text-muted: #64748b;
        }
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }
        
        /* Decorative background elements */
        .bg-shape-1 {
            position: absolute;
            top: -15%;
            right: -5%;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(217,119,6,0.15) 0%, rgba(217,119,6,0) 70%);
            border-radius: 50%;
            z-index: 1;
        }
        .bg-shape-2 {
            position: absolute;
            bottom: -20%;
            left: -10%;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(56,189,248,0.1) 0%, rgba(56,189,248,0) 70%);
            border-radius: 50%;
            z-index: 1;
        }

        .login-wrapper {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 440px;
            padding: 20px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 48px 40px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(255,255,255,0.1) inset;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-header {
            text-align: center;
            margin-bottom: 36px;
        }

        .login-header h2 {
            font-family: 'Outfit', sans-serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-main);
            letter-spacing: -0.02em;
            margin-bottom: 8px;
        }

        .login-header p {
            font-size: 0.9rem;
            color: var(--text-muted);
            line-height: 1.5;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            padding: 14px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 24px;
            text-align: center;
            border: 1px solid rgba(239, 68, 68, 0.2);
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            color: var(--text-main);
            transition: all 0.3s ease;
            outline: none;
        }

        .form-group input:focus {
            background: #ffffff;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(217, 119, 6, 0.1);
        }

        .btn-primary {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-hover) 100%);
            color: #ffffff;
            border: none;
            border-radius: 12px;
            font-family: 'Outfit', sans-serif;
            font-size: 1.05rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            box-shadow: 0 4px 14px rgba(217, 119, 6, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(217, 119, 6, 0.4);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .footer-text {
            text-align: center;
            margin-top: 24px;
            font-size: 0.8rem;
            color: var(--text-muted);
        }
    </style>
</head>
<body>
    <div class="bg-shape-1"></div>
    <div class="bg-shape-2"></div>

    <div class="login-wrapper">
        <div class="login-card">
            <div class="login-header">
                <c:choose>
                    <c:when test="${not empty centralConfig.logoPath}">
                        <c:set var="logoUrl" value="${fn:startsWith(centralConfig.logoPath, 'http') ? centralConfig.logoPath : pageContext.request.contextPath.concat(centralConfig.logoPath)}" />
                        <img src="${logoUrl}" alt="Logo" style="max-height: 80px; width: auto; margin-bottom: 16px; object-fit: contain;">
                    </c:when>
                    <c:otherwise>
                        <!-- No logo default -->
                    </c:otherwise>
                </c:choose>
                <h2>Welcome Back</h2>
                <p>
                    <c:choose>
                        <c:when test="${not empty centralConfig.companyName}">
                            ${centralConfig.companyName}
                        </c:when>
                        <c:otherwise>
                            ICHMT CRM Portal<br>International Chamber of Healthcare & Medical Tourism
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-danger">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required autocomplete="off" placeholder="Enter your username">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required placeholder="Enter your password">
                </div>
                <button type="submit" class="btn-primary">Sign In</button>
            </form>

            <div class="footer-text">
                &copy; <%= java.time.Year.now().getValue() %> IHWT. All rights reserved.
            </div>
        </div>
    </div>
</body>
</html>
