<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.user.User" %>
<%@ page import="com.bookstore.model.user.PremiumUser" %>
<%@ page import="com.bookstore.model.user.RegularUser" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - BookVerse</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        :root {
            --primary-dark: #121212;
            --secondary-dark: #1e1e1e;
            --accent-color: #8a5cf5;
            --accent-hover: #6e46c9;
            --text-primary: #f5f5f5;
            --text-secondary: #b0b0b0;
            --danger-color: #d64045;
            --success-color: #4caf50;
            --warning-color: #ff9800;
            --card-bg: #252525;
            --border-color: #333333;
        }

        body {
            background-color: var(--primary-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background-color: var(--secondary-dark);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-weight: bold;
            color: var(--accent-color) !important;
        }

        .nav-link {
            color: var(--text-primary) !important;
            margin: 0 10px;
            position: relative;
        }

        .nav-link:after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 0;
            background-color: var(--accent-color);
            transition: width 0.3s;
        }

        .nav-link:hover:after {
            width: 100%;
        }

        .nav-link.active {
            color: var(--accent-color) !important;
            font-weight: 500;
        }

        .nav-link.active:after {
            width: 100%;
        }

        .btn-accent {
            background-color: var(--accent-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-accent:hover {
            background-color: var(--accent-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(138, 92, 245, 0.3);
        }

        .btn-outline-accent {
            color: var(--accent-color);
            background-color: transparent;
            border: 1px solid var(--accent-color);
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-outline-accent:hover {
            background-color: var(--accent-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(138, 92, 245, 0.3);
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .card-header {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            font-weight: 600;
            padding: 15px 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .alert-custom {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .alert-success {
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            border-left: 4px solid var(--danger-color);
        }

        .alert-warning {
            border-left: 4px solid var(--warning-color);
        }

        .content-container {
            flex: 1 0 auto;
            padding: 40px 0;
        }

        .form-control {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            padding: 12px 15px;
        }

        .form-control:focus {
            background-color: var(--secondary-dark);
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.25rem rgba(138, 92, 245, 0.25);
            color: var(--text-primary);
        }

        .form-control:disabled {
            background-color: rgba(30, 30, 30, 0.5);
            color: var(--text-secondary);
        }

        .form-label {
            color: var(--text-primary);
            font-weight: 500;
            margin-bottom: 8px;
        }

        .input-group-text {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
        }

        .premium-badge {
            background: linear-gradient(135deg, #B68C1A, #FFD700);
            color: #333;
            padding: 3px 8px;
            border-radius: 15px;
            font-weight: bold;
            font-size: 0.8rem;
            display: inline-block;
            margin-left: 10px;
        }

        .user-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid var(--accent-color);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            margin: 0 auto 20px;
        }

        .password-toggle {
            cursor: pointer;
        }

        footer {
            margin-top: auto;
            background-color: var(--secondary-dark);
            color: var(--text-secondary);
            padding: 20px 0;
        }
    </style>
</head>
<body>
    <%
        // Get the user from the session or request attribute
        User currentUser = (User)session.getAttribute("user");
        if (request.getAttribute("user") != null) {
            currentUser = (User)request.getAttribute("user");
        }

        boolean isPremium = currentUser instanceof PremiumUser;
        boolean isRegular = currentUser instanceof RegularUser;
    %>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-book-open me-2"></i>BookVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/search-book">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/view-recommendations">Recommendations</a>
                    </li>
                </ul>

                <!-- User Menu -->
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/view-cart">
                            <i class="fas fa-shopping-cart"></i> Cart
                            <span class="badge rounded-pill bg-accent">
                                ${sessionScope.cartCount != null ? sessionScope.cartCount : 0}
                            </span>
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle active" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-1"></i> ${sessionScope.username}
                            <% if (isPremium) { %>
                                <span class="premium-badge">PREMIUM</span>
                            <% } %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/user/profile.jsp">My Profile</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/order-history">My Orders</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Flash Messages -->
    <c:if test="${not empty successMessage || not empty sessionScope.successMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${not empty successMessage ? successMessage : sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty errorMessage || not empty sessionScope.errorMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${not empty errorMessage ? errorMessage : sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Main Content -->
    <div class="content-container">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="user-avatar">
                                <img src="https://ui-avatars.com/api/?name=<%= currentUser.getFullName() %>&background=8a5cf5&color=fff&size=150" alt="User Avatar" class="img-fluid">
                            </div>
                            <h4><%= currentUser.getFullName() %></h4>
                            <p class="text-muted mb-1">@<%= currentUser.getUsername() %></p>
                            <p class="text-muted mb-4">
                                <% if (isPremium) { %>
                                    <span class="premium-badge">PREMIUM</span> Member
                                <% } else { %>
                                    Regular Member
                                <% } %>
                            </p>
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/user/profile.jsp" class="btn btn-outline-accent">
                                    <i class="fas fa-arrow-left me-1"></i> Back to Profile
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i> Edit Profile</h5>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/update-profile" method="post">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" value="<%= currentUser.getUsername() %>" disabled>
                                    <div class="form-text text-muted">Username cannot be changed.</div>
                                </div>
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" value="<%= currentUser.getFullName() %>" required>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= currentUser.getEmail() %>" required>
                                </div>

                                <hr style="background-color: var(--border-color);">
                                <h5 class="mb-3">Change Password</h5>
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">Current Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                                        <span class="input-group-text password-toggle" onclick="togglePasswordVisibility('currentPassword', 'toggleIcon1')">
                                            <i class="fas fa-eye" id="toggleIcon1"></i>
                                        </span>
                                    </div>
                                    <div class="form-text text-muted">Leave blank if you don't want to change your password.</div>
                                </div>
                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="newPassword" name="newPassword">
                                        <span class="input-group-text password-toggle" onclick="togglePasswordVisibility('newPassword', 'toggleIcon2')">
                                            <i class="fas fa-eye" id="toggleIcon2"></i>
                                        </span>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                                        <span class="input-group-text password-toggle" onclick="togglePasswordVisibility('confirmPassword', 'toggleIcon3')">
                                            <i class="fas fa-eye" id="toggleIcon3"></i>
                                        </span>
                                    </div>
                                </div>

                                <% if (isRegular) { %>
                                <hr style="background-color: var(--border-color);">
                                <h5 class="mb-3">Account Upgrade</h5>
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="upgradeAccount" name="upgradeAccount" value="yes">
                                        <label class="form-check-label" for="upgradeAccount">
                                            Upgrade to Premium Account <span class="premium-badge">PREMIUM</span>
                                        </label>
                                        <div class="form-text text-muted">Upgrade to Premium for $9.99/month. First month free!</div>
                                    </div>
                                </div>
                                <% } %>

                                <div class="d-grid gap-2 mt-4">
                                    <button type="submit" class="btn btn-accent">
                                        <i class="fas fa-save me-2"></i> Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <p class="mb-0">&copy; 2023 BookVerse. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <a href="#" class="me-3 text-light">Privacy Policy</a>
                    <a href="#" class="text-light">Terms of Service</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom Script -->
    <script>
        // Toggle password visibility
        function togglePasswordVisibility(inputId, iconId) {
            const passwordInput = document.getElementById(inputId);
            const toggleIcon = document.getElementById(iconId);

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }

        // Password match validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = this.value;

            if (newPassword !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>