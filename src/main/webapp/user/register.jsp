<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - BookVerse</title>
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
            padding: 40px 0;
        }

        .register-card {
            max-width: 800px;
            width: 100%;
            margin: 0 auto;
        }

        .password-toggle {
            cursor: pointer;
        }

        .password-strength {
            margin-top: 8px;
            height: 5px;
            border-radius: 3px;
            transition: all 0.3s;
        }

        .strength-weak {
            background-color: var(--danger-color);
            width: 33%;
        }

        .strength-medium {
            background-color: var(--warning-color);
            width: 66%;
        }

        .strength-strong {
            background-color: var(--success-color);
            width: 100%;
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

        .premium-features {
            margin-top: 30px;
            padding: 20px;
            background-color: rgba(182, 140, 26, 0.1);
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: 10px;
        }

        .premium-features h5 {
            color: #FFD700;
        }

        .premium-features ul {
            list-style-type: none;
            padding-left: 0;
        }

        .premium-features li {
            padding: 8px 0;
            position: relative;
            padding-left: 25px;
        }

        .premium-features li:before {
            content: '✓';
            color: #FFD700;
            position: absolute;
            left: 0;
            top: 8px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/">
                <i class="fas fa-book-open me-2"></i>BookVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/search-book">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/login">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=request.getContextPath()%>/register">Register</a>
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

    <!-- Register Content -->
    <div class="content-container">
        <div class="container">
            <div class="card register-card">
                <div class="card-header">
                    <h4 class="mb-0">Create a New Account</h4>
                </div>
                <div class="card-body p-4">
                    <!-- Social Login -->
                    <div class="social-login mb-4">
                        <a href="#" class="social-login-btn google-btn">
                            <i class="fab fa-google me-2"></i> Sign up with Google
                        </a>
                        <a href="#" class="social-login-btn facebook-btn">
                            <i class="fab fa-facebook-f me-2"></i> Sign up with Facebook
                        </a>
                    </div>

                    <div class="divider">OR</div>

                    <!-- Registration Form -->
                    <form action="<%=request.getContextPath()%>/register" method="post" id="registrationForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter your full name" required>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="username" class="form-label">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-at"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" placeholder="Choose a username" required>
                                </div>
                                <div id="usernameHelp" class="form-text text-muted">Username must be 3-20 characters and can contain letters, numbers, and underscores.</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email address" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Create a password" required onkeyup="checkPasswordStrength()">
                                    <span class="input-group-text password-toggle" onclick="togglePasswordVisibility('password', 'toggleIcon1')">
                                        <i class="fas fa-eye" id="toggleIcon1"></i>
                                    </span>
                                </div>
                                <div class="password-strength" id="passwordStrength"></div>
                                <div id="passwordHelp" class="form-text text-muted">Password must be at least 8 characters, including uppercase, lowercase, numbers, and special characters.</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required onkeyup="checkPasswordMatch()">
                                    <span class="input-group-text password-toggle" onclick="togglePasswordVisibility('confirmPassword', 'toggleIcon2')">
                                        <i class="fas fa-eye" id="toggleIcon2"></i>
                                    </span>
                                </div>
                                <div id="passwordMatchMessage" class="form-text"></div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="premiumAccount" name="premiumAccount">
                                <label class="form-check-label" for="premiumAccount">
                                    Sign up for Premium Account <span class="premium-badge">PREMIUM</span> ($9.99/month)
                                </label>
                            </div>

                            <!-- Premium Features -->
                            <div class="premium-features" id="premiumFeatures" style="display: none;">
                                <h5 class="mb-3"><i class="fas fa-crown me-2"></i>Premium Benefits</h5>
                                <ul>
                                    <li>Free shipping on all orders</li>
                                    <li>10% discount on all purchases</li>
                                    <li>Early access to new releases</li>
                                    <li>Unlimited bookmarks</li>
                                    <li>Exclusive premium-only titles</li>
                                    <li>Priority customer support</li>
                                </ul>
                                <small class="d-block mt-2">Your first month is free! You won't be charged until after the trial period.</small>
                            </div>
                        </div>

                        <div class="mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="termsAgreement" name="termsAgreement" required>
                                <label class="form-check-label" for="termsAgreement">
                                    I agree to the <a href="#" style="color: var(--accent-color);">Terms of Service</a> and <a href="#" style="color: var(--accent-color);">Privacy Policy</a>
                                </label>
                            </div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-accent">
                                <i class="fas fa-user-plus me-2"></i> Create Account
                            </button>
                        </div>
                    </form>

                    <div class="text-center mt-4">
                        <p>Already have an account? <a href="<%=request.getContextPath()%>/login" class="text-decoration-none" style="color: var(--accent-color);">Login here</a></p>
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

    <!-- Custom Scripts -->
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

        // Check password strength
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('passwordStrength');
            const passwordHelp = document.getElementById('passwordHelp');

            // Remove existing classes
            strengthBar.classList.remove('strength-weak', 'strength-medium', 'strength-strong');

            if (password.length === 0) {
                strengthBar.style.display = 'none';
                passwordHelp.innerText = 'Password must be at least 8 characters, including uppercase, lowercase, numbers, and special characters.';
                return;
            }

            // Show strength bar
            strengthBar.style.display = 'block';

            // Define strength patterns
            const hasUpperCase = /[A-Z]/.test(password);
            const hasLowerCase = /[a-z]/.test(password);
            const hasNumbers = /\d/.test(password);
            const hasSpecialChars = /[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/.test(password);

            // Calculate strength
            let strength = 0;
            if (password.length >= 8) strength++;
            if (password.length >= 12) strength++;
            if (hasUpperCase && hasLowerCase) strength++;
            if (hasNumbers) strength++;
            if (hasSpecialChars) strength++;

            // Update strength bar and message
            if (strength < 3) {
                strengthBar.classList.add('strength-weak');
                passwordHelp.innerText = 'Weak password. Add uppercase, lowercase, numbers, and special characters.';
            } else if (strength < 5) {
                strengthBar.classList.add('strength-medium');
                passwordHelp.innerText = 'Medium strength password. Consider adding more complexity.';
            } else {
                strengthBar.classList.add('strength-strong');
                passwordHelp.innerText = 'Strong password!';
            }
        }

        // Check if passwords match
        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchMessage = document.getElementById('passwordMatchMessage');

            if (confirmPassword.length === 0) {
                matchMessage.innerText = '';
                return;
            }

            if (password === confirmPassword) {
                matchMessage.innerText = 'Passwords match!';
                matchMessage.style.color = '#4caf50';
            } else {
                matchMessage.innerText = 'Passwords do not match!';
                matchMessage.style.color = '#d64045';
            }
        }

        // Toggle premium features section
        document.getElementById('premiumAccount').addEventListener('change', function() {
            const premiumFeatures = document.getElementById('premiumFeatures');
            if (this.checked) {
                premiumFeatures.style.display = 'block';
            } else {
                premiumFeatures.style.display = 'none';
            }
        });

        // Form validation before submit
        document.getElementById('registrationForm').addEventListener('submit', function(event) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                event.preventDefault();
                alert('Passwords do not match!');
            }
        });
    </script>
</body>
</html>