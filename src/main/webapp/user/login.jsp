<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - BookVerse</title>
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

        .form-check-input {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
        }

        .form-check-input:checked {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
        }

        .content-container {
            flex: 1 0 auto;
            display: flex;
            align-items: center;
            padding: 40px 0;
        }

        .login-card {
            max-width: 450px;
            width: 100%;
            margin: 0 auto;
        }

        .password-toggle {
            cursor: pointer;
        }

        .social-login-btn {
            display: block;
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
            text-decoration: none;
            color: white;
            font-weight: 500;
            transition: all 0.3s;
        }

        .google-btn {
            background-color: #DB4437;
        }

        .facebook-btn {
            background-color: #4267B2;
        }

        .social-login-btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            color: white;
        }

        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            color: var(--text-secondary);
            margin: 20px 0;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid var(--border-color);
        }

        .divider::before {
            margin-right: 1em;
        }

        .divider::after {
            margin-left: 1em;
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
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/search-book">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/login">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Flash Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty errorMessage || not empty sessionScope.errorMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                ${not empty errorMessage ? errorMessage : sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Login Content -->
    <div class="content-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card login-card">
                        <div class="card-header">
                            <h4 class="mb-0">Login to Your Account</h4>
                        </div>
                        <div class="card-body p-4">
                            <!-- Social Login -->
                            <div class="social-login mb-4">
                                <a href="#" class="social-login-btn google-btn">
                                    <i class="fab fa-google me-2"></i> Continue with Google
                                </a>
                                <a href="#" class="social-login-btn facebook-btn">
                                    <i class="fab fa-facebook-f me-2"></i> Continue with Facebook
                                </a>
                            </div>

                            <div class="divider">OR</div>

                            <!-- Login Form -->
                            <form action="${pageContext.request.contextPath}/login" method="post">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                                        <input type="text" class="form-control" id="username" name="username" placeholder="Enter your username" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                                        <span class="input-group-text password-toggle" onclick="togglePasswordVisibility()">
                                            <i class="fas fa-eye" id="toggleIcon"></i>
                                        </span>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" value="" id="rememberMe" name="rememberMe">
                                        <label class="form-check-label" for="rememberMe">
                                            Remember me
                                        </label>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none" style="color: var(--accent-color);">Forgot password?</a>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-accent">
                                        <i class="fas fa-sign-in-alt me-2"></i> Login
                                    </button>
                                </div>
                            </form>

                            <div class="text-center mt-4">
                                <p>Don't have an account? <a href="${pageContext.request.contextPath}/register" class="text-decoration-none" style="color: var(--accent-color);">Register now</a></p>
                            </div>
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

    <!-- Password Toggle Script -->
    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('toggleIcon');

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
    </script>
</body>
</html>