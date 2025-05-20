<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - BookVerse</title>
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
        }

        .navbar {
            background-color: var(--secondary-dark);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-weight: bold;
            color: var(--accent-color) !important;
        }

        .btn-accent {
            background-color: var(--accent-color);
            color: white;
            border: none;
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
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .card-header {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            font-weight: 600;
        }

        .form-control, .form-select {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        .form-control:focus, .form-select:focus {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.25rem rgba(138, 92, 245, 0.25);
        }

        .form-check-input {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
        }

        .form-check-input:checked {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
        }

        .breadcrumb {
            background-color: var(--secondary-dark);
            padding: 10px 15px;
            border-radius: 5px;
        }

        .breadcrumb-item a {
            color: var(--text-secondary);
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: var(--text-primary);
        }

        .payment-method {
            cursor: pointer;
            transition: all 0.3s;
        }

        .payment-method:hover {
            background-color: var(--secondary-dark);
        }

        .payment-method.selected {
            background-color: rgba(138, 92, 245, 0.1);
            border: 1px solid var(--accent-color);
        }

        .payment-method img {
            height: 40px;
            opacity: 0.8;
            transition: opacity 0.3s;
        }

        .payment-method:hover img,
        .payment-method.selected img {
            opacity: 1;
        }

        .payment-method .form-check-input {
            margin-top: 0;
        }

        .order-summary {
            background-color: var(--secondary-dark);
            border-radius: 8px;
            padding: 20px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .total-row {
            font-weight: bold;
            font-size: 1.1rem;
            border-top: 1px solid var(--border-color);
            padding-top: 10px;
            margin-top: 10px;
        }

        input.credit-card {
            letter-spacing: 3px;
        }

        #card-container {
            color: var(--text-primary);
            width: 100%;
            height: 160px;
            perspective: 600px;
            position: relative;
        }

        .credit-card {
            width: 100%;
            height: 100%;
            border-radius: 15px;
            background: linear-gradient(45deg, #1a1a2e, #16213e, #0f3460);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            position: relative;
            padding: 20px;
            transition: transform 0.6s;
            transform-style: preserve-3d;
        }

        .card-logo {
            position: absolute;
            top: 20px;
            right: 20px;
            height: 40px;
        }

        .card-chip {
            position: absolute;
            top: 70px;
            left: 20px;
            height: 40px;
            width: 55px;
            background: linear-gradient(to bottom, #bbb, #ccc);
            border-radius: 7px;
        }

        .card-chip::before,
        .card-chip::after {
            content: '';
            position: absolute;
            border-radius: 5px;
            background: rgba(0, 0, 0, 0.1);
        }

        .card-chip::before {
            top: 6px;
            left: 6px;
            width: 43px;
            height: 6px;
        }

        .card-chip::after {
            top: 17px;
            left: 6px;
            width: 43px;
            height: 6px;
        }

        .card-number {
            position: absolute;
            bottom: 50px;
            left: 20px;
            right: 20px;
            letter-spacing: 4px;
            font-size: 20px;
            font-family: 'Courier New', monospace;
        }

        .card-holder {
            position: absolute;
            bottom: 20px;
            left: 20px;
            font-size: 16px;
            font-family: 'Courier New', monospace;
        }

        .card-expiry {
            position: absolute;
            bottom: 20px;
            right: 20px;
            font-size: 16px;
            font-family: 'Courier New', monospace;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/">
                <i class="fas fa-book-open me-2"></i>BookVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/books">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/contact">Contact</a>
                    </li>
                </ul>

                <!-- User Menu -->
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/cart">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="badge bg-accent rounded-pill">${sessionScope.cartCount}</span>
                        </a>
                    </li>
                    <c:choose>
                        <c:when test="${empty sessionScope.userId}">
                            <li class="nav-item">
                                <a class="nav-link" href="<%=request.getContextPath()%>/login">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%=request.getContextPath()%>/register">Register</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user me-1"></i> My Account
                                </a>
                                <ul class="dropdown-menu dropdown-menu-dark">
                                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/profile">Profile</a></li>
                                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/order-history">Orders</a></li>
                                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/wishlists">Wishlists</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/logout">Logout</a></li>
                                </ul>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Home</a></li>
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/cart">Cart</a></li>
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/checkout">Checkout</a></li>
                <li class="breadcrumb-item active" aria-current="page">Payment</li>
            </ol>
        </nav>

        <h2 class="mb-4"><i class="fas fa-credit-card me-2"></i> Payment Information</h2>

        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <div class="row">
            <div class="col-lg-8 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Payment Method</h5>
                    </div>
                    <div class="card-body">
                        <form action="<%=request.getContextPath()%>/process-payment" method="post" id="paymentForm">
                            <!-- Payment Method Selection -->
                            <div class="mb-4">
                                <label class="form-label">Select Payment Method</label>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="card payment-method selected" id="credit-card-method" onclick="selectPaymentMethod('CREDIT_CARD')">
                                            <div class="card-body d-flex align-items-center">
                                                <input class="form-check-input me-3" type="radio" name="paymentMethod" id="credit" value="CREDIT_CARD" checked>
                                                <img src="https://cdn.iconscout.com/icon/free/png-256/free-credit-card-2650080-2196542.png" alt="Credit Card" class="me-3">
                                                <label class="form-check-label" for="credit">Credit Card</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="card payment-method" id="debit-card-method" onclick="selectPaymentMethod('DEBIT_CARD')">
                                            <div class="card-body d-flex align-items-center">
                                                <input class="form-check-input me-3" type="radio" name="paymentMethod" id="debit" value="DEBIT_CARD">
                                                <img src="https://cdn.iconscout.com/icon/free/png-256/free-debit-card-credit-bank-transaction-3-30616.png" alt="Debit Card" class="me-3">
                                                <label class="form-check-label" for="debit">Debit Card</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="card payment-method" id="paypal-method" onclick="selectPaymentMethod('PAYPAL')">
                                            <div class="card-body d-flex align-items-center">
                                                <input class="form-check-input me-3" type="radio" name="paymentMethod" id="paypal" value="PAYPAL">
                                                <img src="https://cdn.iconscout.com/icon/free/png-256/free-paypal-54-675727.png" alt="PayPal" class="me-3">
                                                <label class="form-check-label" for="paypal">PayPal</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="card payment-method" id="bank-transfer-method" onclick="selectPaymentMethod('BANK_TRANSFER')">
                                            <div class="card-body d-flex align-items-center">
                                                <input class="form-check-input me-3" type="radio" name="paymentMethod" id="bank" value="BANK_TRANSFER">
                                                <img src="https://cdn.iconscout.com/icon/free/png-256/free-bank-1850789-1571057.png" alt="Bank Transfer" class="me-3">
                                                <label class="form-check-label" for="bank">Bank Transfer</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Credit Card Form -->
                            <div id="creditCardForm">
                                <div class="mb-4" id="card-container">
                                    <div class="credit-card">
                                        <div class="card-logo">
                                            <i class="fab fa-cc-visa fa-2x text-light"></i>
                                        </div>
                                        <div class="card-chip"></div>
                                        <div class="card-number">XXXX XXXX XXXX XXXX</div>
                                        <div class="card-holder">CARDHOLDER NAME</div>
                                        <div class="card-expiry">MM/YY</div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="cardNumber" class="form-label">Card Number</label>
                                    <input type="text" class="form-control credit-card" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456"
                                           maxlength="19" onkeyup="formatCardNumber(this)" onkeydown="return isNumberKey(event)">
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="cardName" class="form-label">Cardholder Name</label>
                                        <input type="text" class="form-control" id="cardName" name="cardName" placeholder="John Doe">
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="cardExpiry" class="form-label">Expiry Date</label>
                                        <input type="text" class="form-control" id="cardExpiry" placeholder="MM/YY" maxlength="5"
                                               onkeyup="formatExpiry(this)" onkeydown="return isExpiryKey(event)">
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="cardCvv" class="form-label">CVV</label>
                                        <input type="password" class="form-control" id="cardCvv" placeholder="123" maxlength="3"
                                               onkeydown="return isNumberKey(event)">
                                    </div>
                                </div>
                            </div>

                            <!-- PayPal Form (Hidden by default) -->
                            <div id="paypalForm" style="display: none;">
                                <div class="mb-3">
                                    <label for="paypalEmail" class="form-label">PayPal Email</label>
                                    <input type="email" class="form-control" id="paypalEmail" placeholder="your@email.com">
                                </div>
                            </div>

                            <!-- Bank Transfer Form (Hidden by default) -->
                            <div id="bankTransferForm" style="display: none;">
                                <div class="alert alert-info mb-3">
                                    <i class="fas fa-info-circle me-2"></i>
                                    After completing your order, you will receive bank account details to make your transfer.
                                </div>
                            </div>

                            <div class="d-flex justify-content-between mt-4">
                                <a href="<%=request.getContextPath()%>/checkout" class="btn btn-outline-light">
                                    <i class="fas fa-arrow-left me-2"></i> Back to Checkout
                                </a>
                                <button type="submit" class="btn btn-accent btn-lg">
                                    <i class="fas fa-lock me-2"></i> Complete Payment
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="order-summary">
                    <h4 class="mb-4">Order Summary</h4>

                    <%
                    // Create DecimalFormat for currency
                    DecimalFormat df = new DecimalFormat("$#,##0.00");

                    // Get values from request attributes
                    double subtotal = 0.0;
                    double tax = 0.0;
                    double shipping = 0.0;
                    double total = 0.0;

                    try {
                        Object subtotalObj = request.getAttribute("orderSubtotal");
                        if (subtotalObj instanceof Double) {
                            subtotal = (Double)subtotalObj;
                        } else if (subtotalObj != null) {
                            subtotal = Double.parseDouble(subtotalObj.toString());
                        }

                        Object taxObj = request.getAttribute("orderTax");
                        if (taxObj instanceof Double) {
                            tax = (Double)taxObj;
                        } else if (taxObj != null) {
                            tax = Double.parseDouble(taxObj.toString());
                        }

                        Object shippingObj = request.getAttribute("orderShipping");
                        if (shippingObj instanceof Double) {
                            shipping = (Double)shippingObj;
                        } else if (shippingObj != null) {
                            shipping = Double.parseDouble(shippingObj.toString());
                        }

                        Object totalObj = request.getAttribute("orderTotal");
                        if (totalObj instanceof Double) {
                            total = (Double)totalObj;
                        } else if (totalObj != null) {
                            total = Double.parseDouble(totalObj.toString());
                        }
                    } catch(Exception e) {
                        // Handle any parsing errors
                        System.out.println("Error parsing order values: " + e.getMessage());
                    }
                    %>

                    <div class="price-row">
                        <span>Subtotal:</span>
                        <span><%= df.format(subtotal) %></span>
                    </div>
                    <div class="price-row">
                        <span>Tax:</span>
                        <span><%= df.format(tax) %></span>
                    </div>
                    <div class="price-row">
                        <span>Shipping:</span>
                        <% if (shipping > 0) { %>
                            <span><%= df.format(shipping) %></span>
                        <% } else { %>
                            <span class="text-success">Free</span>
                        <% } %>
                    </div>

                    <div class="price-row total-row">
                        <span>Total:</span>
                        <span><%= df.format(total) %></span>
                    </div>

                    <hr>

                    <div class="text-center mt-4">
                        <p class="small text-muted mb-0">
                            <i class="fas fa-lock me-1"></i> Secure Payment
                        </p>
                        <div class="mt-2">
                            <i class="fab fa-cc-visa me-2 fa-lg" style="color: #1a1f71;"></i>
                            <i class="fab fa-cc-mastercard me-2 fa-lg" style="color: #eb001b;"></i>
                            <i class="fab fa-cc-amex me-2 fa-lg" style="color: #2e77bc;"></i>
                            <i class="fab fa-cc-paypal fa-lg" style="color: #003087;"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5>BookVerse</h5>
                    <p>Your one-stop destination for all your literary needs. Discover new worlds, one page at a time.</p>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="<%=request.getContextPath()%>/" class="text-decoration-none text-light">Home</a></li>
                        <li><a href="<%=request.getContextPath()%>/books" class="text-decoration-none text-light">Books</a></li>
                        <li><a href="<%=request.getContextPath()%>/contact" class="text-decoration-none text-light">Contact Us</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Contact Information</h5>
                    <address>
                        <i class="fas fa-map-marker-alt me-2"></i> 123 Book Street, Reading City<br>
                        <i class="fas fa-phone me-2"></i> (123) 456-7890<br>
                        <i class="fas fa-envelope me-2"></i> info@bookverse.com
                    </address>
                </div>
            </div>
            <hr>
            <div class="text-center">
                <p class="mb-0">&copy; 2023 BookVerse. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Payment Form Scripts -->
    <script>
        // Select Payment Method
        function selectPaymentMethod(method) {
            // Unselect all methods
            document.querySelectorAll('.payment-method').forEach(element => {
                element.classList.remove('selected');
            });

            // Select chosen method
            document.getElementById(method.toLowerCase().replace('_', '-') + '-method').classList.add('selected');

            // Show/hide appropriate form
            document.getElementById('creditCardForm').style.display =
                (method === 'CREDIT_CARD' || method === 'DEBIT_CARD') ? 'block' : 'none';
            document.getElementById('paypalForm').style.display =
                (method === 'PAYPAL') ? 'block' : 'none';
            document.getElementById('bankTransferForm').style.display =
                (method === 'BANK_TRANSFER') ? 'block' : 'none';

            // Check radio button
            document.querySelector('input[name="paymentMethod"][value="' + method + '"]').checked = true;
        }

        // Format Card Number
        function formatCardNumber(input) {
            // Remove all non-digit characters
            let value = input.value.replace(/\D/g, '');

            // Format with spaces every 4 digits
            let formattedValue = '';
            for (let i = 0; i < value.length; i++) {
                if (i > 0 && i % 4 === 0) {
                    formattedValue += ' ';
                }
                formattedValue += value[i];
            }

            // Update input value
            input.value = formattedValue;

            // Update card display
            document.querySelector('.card-number').textContent =
                formattedValue + 'X'.repeat(Math.max(0, 19 - formattedValue.length));
        }

        // Format Expiry Date
        function formatExpiry(input) {
            // Remove all non-digit characters
            let value = input.value.replace(/\D/g, '');

            // Format with slash after 2 digits
            if (value.length > 2) {
                input.value = value.substring(0, 2) + '/' + value.substring(2);
            } else {
                input.value = value;
            }

            // Update card display
            if (input.value.length > 0) {
                document.querySelector('.card-expiry').textContent = input.value;
            } else {
                document.querySelector('.card-expiry').textContent = 'MM/YY';
            }
        }

        // Allow only numbers for card inputs
        function isNumberKey(evt) {
            let charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        // Allow only numbers and slash for expiry
        function isExpiryKey(evt) {
            let charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode === 47) { // Allow slash
                return true;
            }
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        // Update card display
        document.addEventListener('DOMContentLoaded', function() {
            // Setup card holder name update
            if (document.getElementById('cardName')) {
                document.getElementById('cardName').addEventListener('input', function() {
                    let value = this.value.toUpperCase();
                    if (value) {
                        document.querySelector('.card-holder').textContent = value;
                    } else {
                        document.querySelector('.card-holder').textContent = 'CARDHOLDER NAME';
                    }
                });
            }

            // Form submission validation
            if (document.getElementById('paymentForm')) {
                document.getElementById('paymentForm').addEventListener('submit', function(e) {
                    let paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

                    if (paymentMethod === 'CREDIT_CARD' || paymentMethod === 'DEBIT_CARD') {
                        let cardNumber = document.getElementById('cardNumber').value.replace(/\s/g, '');
                        let cardName = document.getElementById('cardName').value;

                        if (cardNumber.length < 13) {
                            alert('Please enter a valid card number');
                            e.preventDefault();
                            return false;
                        }

                        if (!cardName) {
                            alert('Please enter the cardholder name');
                            e.preventDefault();
                            return false;
                        }
                    }

                    return true;
                });
            }
        });
    </script>
</body>
</html>