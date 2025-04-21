<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.user.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upgrade to Premium - BookVerse</title>
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
            --gold-color: #FFD700;
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
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
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

        .plan-card {
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            height: 100%;
        }

        .plan-card:hover {
            border-color: var(--accent-color);
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
        }

        .plan-card.recommended {
            border: 2px solid var(--gold-color);
            position: relative;
        }

        .plan-card.recommended::before {
            content: 'RECOMMENDED';
            position: absolute;
            top: -12px;
            left: 50%;
            transform: translateX(-50%);
            background: linear-gradient(135deg, #B68C1A, #FFD700);
            color: #333;
            padding: 3px 15px;
            font-size: 0.7rem;
            font-weight: bold;
            border-radius: 15px;
        }

        .plan-header {
            background-color: rgba(138, 92, 245, 0.1);
            text-align: center;
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .plan-price {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--accent-color);
        }

        .plan-billing {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .benefit-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .benefit-icon {
            width: 24px;
            color: var(--success-color);
            margin-right: 15px;
            flex-shrink: 0;
        }

        .benefit-text {
            flex-grow: 1;
        }

        .payment-method {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .payment-method:hover {
            border-color: var(--accent-color);
        }

        .payment-method.selected {
            border-color: var(--accent-color);
            background-color: rgba(138, 92, 245, 0.1);
        }

        .payment-logo {
            height: 30px;
            margin-right: 15px;
        }

        footer {
            margin-top: auto;
            background-color: var(--secondary-dark);
            color: var(--text-secondary);
            padding: 20px 0;
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
    </style>
</head>
<body>
    <%
        // Get the user from the request attribute
        User currentUser = (User)request.getAttribute("user");
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
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile.jsp">My Profile</a></li>
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
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="container mt-3">
            <div class="alert alert-custom alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Main Content -->
    <div class="content-container">
        <div class="container">
            <!-- Header -->
            <div class="text-center mb-5">
                <h1 class="display-5 fw-bold">Upgrade to <span style="color: var(--gold-color);">Premium</span> <span class="premium-badge">PREMIUM</span></h1>
                <p class="lead">Enhance your reading experience with exclusive benefits and special offers.</p>
            </div>

            <!-- Subscription Plans -->
            <div class="row mb-5">
                <!-- Silver Plan -->
                <div class="col-md-4 mb-4">
                    <div class="card plan-card h-100">
                        <div class="plan-header">
                            <i class="fas fa-medal fa-3x mb-3" style="color: #C0C0C0;"></i>
                            <h3>Silver</h3>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-4">
                                <div class="plan-price">$9.99</div>
                                <div class="plan-billing">per month</div>
                                <p class="mt-2 text-muted">First month free!</p>
                            </div>
                            <hr style="background-color: var(--border-color);">
                            <h5 class="mb-3">Benefits</h5>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>5% Discount</strong> on all book purchases
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>Free Shipping</strong> on all orders
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>Early Access</strong> to new releases (24 hours)
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-times-circle" style="color: var(--text-secondary);"></i>
                                </div>
                                <div class="benefit-text" style="color: var(--text-secondary);">
                                    Exclusive premium-only titles
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-times-circle" style="color: var(--text-secondary);"></i>
                                </div>
                                <div class="benefit-text" style="color: var(--text-secondary);">
                                    Monthly free book credit
                                </div>
                            </div>
                        </div>
                        <div class="card-footer text-center border-0" style="background-color: transparent;">
                            <button class="btn btn-outline-accent" onclick="selectPlan('silver')">Select Plan</button>
                        </div>
                    </div>
                </div>

                <!-- Gold Plan -->
                <div class="col-md-4 mb-4">
                    <div class="card plan-card recommended h-100">
                        <div class="plan-header">
                            <i class="fas fa-crown fa-3x mb-3" style="color: #FFD700;"></i>
                            <h3>Gold</h3>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-4">
                                <div class="plan-price">$14.99</div>
                                <div class="plan-billing">per month</div>
                                <p class="mt-2 text-muted">First month free!</p>
                            </div>
                            <hr style="background-color: var(--border-color);">
                            <h5 class="mb-3">Benefits</h5>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>10% Discount</strong> on all book purchases
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>Free Shipping</strong> on all orders
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>Early Access</strong> to new releases (48 hours)
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>Exclusive premium-only</strong> titles
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-times-circle" style="color: var(--text-secondary);"></i>
                                </div>
                                <div class="benefit-text" style="color: var(--text-secondary);">
                                    Monthly free book credit
                                </div>
                            </div>
                        </div>
                        <div class="card-footer text-center border-0" style="background-color: transparent;">
                            <button class="btn btn-accent" onclick="selectPlan('gold')">Select Plan</button>
                        </div>
                    </div>
                </div>

                <!-- Platinum Plan -->
                <div class="col-md-4 mb-4">
                    <div class="card plan-card h-100">
                        <div class="plan-header">
                            <i class="fas fa-gem fa-3x mb-3" style="color: #E5E4E2;"></i>
                            <h3>Platinum</h3>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-4">
                                <div class="plan-price">$19.99</div>
                                <div class="plan-billing">per month</div>
                                <p class="mt-2 text-muted">First month free!</p>
                            </div>
                            <hr style="background-color: var(--border-color);">
                            <h5 class="mb-3">Benefits</h5>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>15% Discount</strong> on all book purchases
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>Free Priority Shipping</strong> on all orders
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>Early Access</strong> to new releases (72 hours)
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>Exclusive premium-only</strong> titles
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="benefit-text">
                                    <strong>1 Free book credit</strong> every month
                                </div>
                            </div>
                        </div>
                        <div class="card-footer text-center border-0" style="background-color: transparent;">
                            <button class="btn btn-outline-accent" onclick="selectPlan('platinum')">Select Plan</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Form (Hidden initially) -->
            <div id="paymentForm" style="display: none;">
                <form action="${pageContext.request.contextPath}/upgrade-to-premium" method="post" id="premiumUpgradeForm">
                    <input type="hidden" id="selectedPlan" name="selectedPlan" value="gold">

                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-credit-card me-2"></i> Payment Method</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <div class="payment-method selected" onclick="selectPaymentMethod(this, 'credit-card')">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="paymentMethod" id="creditCard" value="credit-card" checked>
                                            <label class="form-check-label d-flex align-items-center" for="creditCard">
                                                <span class="me-auto">Credit/Debit Card</span>
                                                <div>
                                                    <img src="https://cdn-icons-png.flaticon.com/128/349/349221.png" alt="Visa" class="payment-logo" style="height: 25px;">
                                                    <img src="https://cdn-icons-png.flaticon.com/128/349/349228.png" alt="MasterCard" class="payment-logo" style="height: 25px;">
                                                    <img src="https://cdn-icons-png.flaticon.com/128/349/349230.png" alt="Amex" class="payment-logo" style="height: 25px;">
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="payment-method" onclick="selectPaymentMethod(this, 'paypal')">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="paymentMethod" id="paypal" value="paypal">
                                            <label class="form-check-label d-flex align-items-center" for="paypal">
                                                <span class="me-auto">PayPal</span>
                                                <img src="https://cdn-icons-png.flaticon.com/128/174/174861.png" alt="PayPal" class="payment-logo">
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Credit Card Form -->
                            <div id="creditCardForm" class="mt-4">
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label for="cardName" class="form-label">Name on Card</label>
                                        <input type="text" class="form-control" id="cardName" name="cardName" value="<%= currentUser.getFullName() %>">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label for="cardNumber" class="form-label">Card Number</label>
                                        <input type="text" class="form-control" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="expiryDate" class="form-label">Expiry Date</label>
                                        <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YY">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="cvv" class="form-label">CVV</label>
                                        <input type="text" class="form-control" id="cvv" name="cvv" placeholder="123">
                                    </div>
                                </div>
                            </div>

                            <!-- PayPal Form (Hidden initially) -->
                            <div id="paypalForm" class="mt-4" style="display: none;">
                                <div class="alert alert-custom alert-info" role="alert">
                                    <i class="fas fa-info-circle me-2"></i> You will be redirected to PayPal to complete your payment after clicking "Upgrade Now".
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-file-invoice-dollar me-2"></i> Billing Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="sameAsShipping" checked>
                                <label class="form-check-label" for="sameAsShipping">
                                    Use my account information for billing
                                </label>
                            </div>

                            <div id="billingForm" style="display: none;">
                                <!-- Billing form fields would go here -->
                            </div>

                            <div class="alert alert-custom alert-warning mt-3" role="alert">
                                <i class="fas fa-info-circle me-2"></i> Your first month is completely free! You won't be charged until your free trial ends. You can cancel anytime.
                            </div>
                        </div>
                    </div>

                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-clipboard-check me-2"></i> Order Summary</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span id="planSummary">Gold Plan</span>
                                <span id="planPrice">$14.99/month</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2 text-success">
                                <span>Free Trial</span>
                                <span>-$14.99</span>
                            </div>
                            <hr style="background-color: var(--border-color);">
                            <div class="d-flex justify-content-between fw-bold">
                                <span>Total Today</span>
                                <span>$0.00</span>
                            </div>
                            <div class="d-flex justify-content-between mt-2 text-muted small">
                                <span>After free trial</span>
                                <span id="afterTrialPrice">$14.99/month</span>
                            </div>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-accent btn-lg">
                            <i class="fas fa-crown me-2"></i> Upgrade Now
                        </button>
                        <p class="text-center mt-2 text-muted small">By clicking "Upgrade Now", you agree to our <a href="#" style="color: var(--accent-color);">Terms of Service</a> and <a href="#" style="color: var(--accent-color);">Subscription Terms</a></p>
                    </div>
                </form>
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
        function selectPlan(plan) {
            // Set the selected plan
            document.getElementById('selectedPlan').value = plan;

            // Update the order summary
            let planSummary = document.getElementById('planSummary');
            let planPrice = document.getElementById('planPrice');
            let afterTrialPrice = document.getElementById('afterTrialPrice');

            if (plan === 'silver') {
                planSummary.textContent = 'Silver Plan';
                planPrice.textContent = '$9.99/month';
                afterTrialPrice.textContent = '$9.99/month';
            } else if (plan === 'gold') {
                planSummary.textContent = 'Gold Plan';
                planPrice.textContent = '$14.99/month';
                afterTrialPrice.textContent = '$14.99/month';
            } else if (plan === 'platinum') {
                planSummary.textContent = 'Platinum Plan';
                planPrice.textContent = '$19.99/month';
                afterTrialPrice.textContent = '$19.99/month';
            }

            // Show the payment form
            document.getElementById('paymentForm').style.display = 'block';

            // Scroll to the payment form
            document.getElementById('paymentForm').scrollIntoView({ behavior: 'smooth' });
        }

        function selectPaymentMethod(element, method) {
            // Remove selected class from all payment methods
            let paymentMethods = document.getElementsByClassName('payment-method');
            for (let i = 0; i < paymentMethods.length; i++) {
                paymentMethods[i].classList.remove('selected');
            }

            // Add selected class to clicked payment method
            element.classList.add('selected');

            // Show/hide appropriate form
            if (method === 'credit-card') {
                document.getElementById('creditCardForm').style.display = 'block';
                document.getElementById('paypalForm').style.display = 'none';
                document.getElementById('creditCard').checked = true;
            } else if (method === 'paypal') {
                document.getElementById('creditCardForm').style.display = 'none';
                document.getElementById('paypalForm').style.display = 'block';
                document.getElementById('paypal').checked = true;
            }
        }

        // Handle the "same as shipping" checkbox
        document.getElementById('sameAsShipping').addEventListener('change', function() {
            if (this.checked) {
                document.getElementById('billingForm').style.display = 'none';
            } else {
                document.getElementById('billingForm').style.display = 'block';
            }
        });

        // Form validation
        document.getElementById('premiumUpgradeForm').addEventListener('submit', function(event) {
            // In a real application, add validation for credit card details
            // This is a simplified version for demonstration

            // For this demo, we'll just submit the form
            // In a real app, you'd validate and process payment
            return true;
        });
    </script>
</body>
</html>