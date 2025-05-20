<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Process Payment - Online Bookstore</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Simple styling */
        .navbar {
            background-color: #343a40;
            color: white;
            padding: 1rem;
        }
        .navbar-brand {
            color: white;
            font-size: 1.5rem;
            text-decoration: none;
        }
        footer {
            background-color: #343a40;
            color: white;
            padding: 1rem 0;
            margin-top: 2rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Simple navbar -->
    <div class="navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">Online Bookstore</a>
            <div>
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-light">Cart</a>
                <a href="${pageContext.request.contextPath}/order-history" class="btn btn-outline-light ms-2">My Orders</a>
            </div>
        </div>
    </div>

    <div class="container mt-5 mb-5">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h3 class="card-title mb-0">Payment Information</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger">${errorMessage}</div>
                        </c:if>

                        <div class="row mb-4">
                            <div class="col-md-12">
                                <h5>Order Summary</h5>
                                <hr>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Order Subtotal:</span>
                                    <span>$<fmt:formatNumber value="${orderSubtotal}" pattern="0.00" /></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Tax:</span>
                                    <span>$<fmt:formatNumber value="${orderTax}" pattern="0.00" /></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Shipping:</span>
                                    <span>$<fmt:formatNumber value="${orderShipping}" pattern="0.00" /></span>
                                </div>
                                <div class="d-flex justify-content-between fw-bold">
                                    <span>Total:</span>
                                    <span>$<fmt:formatNumber value="${orderTotal}" pattern="0.00" /></span>
                                </div>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/process-payment" method="post">
                            <div class="mb-4">
                                <h5>Payment Method</h5>
                                <hr>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="CREDIT_CARD" value="CREDIT_CARD" checked>
                                    <label class="form-check-label" for="CREDIT_CARD">Credit Card</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="DEBIT_CARD" value="DEBIT_CARD">
                                    <label class="form-check-label" for="DEBIT_CARD">Debit Card</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="PAYPAL" value="PAYPAL">
                                    <label class="form-check-label" for="PAYPAL">PayPal</label>
                                </div>
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="BANK_TRANSFER" value="BANK_TRANSFER">
                                    <label class="form-check-label" for="BANK_TRANSFER">Bank Transfer</label>
                                </div>
                            </div>

                            <div id="creditCardForm">
                                <div class="mb-3">
                                    <label for="cardNumber" class="form-label">Card Number</label>
                                    <input type="text" class="form-control" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" required>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="expiryDate" class="form-label">Expiry Date</label>
                                        <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YY" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cvv" class="form-label">CVV</label>
                                        <input type="text" class="form-control" id="cvv" name="cvv" placeholder="123" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="cardName" class="form-label">Name on Card</label>
                                    <input type="text" class="form-control" id="cardName" name="cardName" placeholder="John Doe" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="savePaymentInfo" name="savePaymentInfo">
                                    <label class="form-check-label" for="savePaymentInfo">
                                        Save payment information for future purchases
                                    </label>
                                </div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">Complete Payment</button>
                                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-outline-secondary">Back to Checkout</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Simple footer -->
    <footer>
        <div class="container">
            <p>&copy; 2025 Online Bookstore. All rights reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JavaScript -->
    <script>
        // Toggle payment forms based on payment method selection
        document.addEventListener('DOMContentLoaded', function() {
            const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
            const creditCardForm = document.getElementById('creditCardForm');

            paymentMethods.forEach(method => {
                method.addEventListener('change', function() {
                    if (this.value === 'CREDIT_CARD' || this.value === 'DEBIT_CARD') {
                        creditCardForm.style.display = 'block';
                        document.querySelectorAll('#creditCardForm input').forEach(input => {
                            input.setAttribute('required', true);
                        });
                    } else {
                        creditCardForm.style.display = 'none';
                        document.querySelectorAll('#creditCardForm input').forEach(input => {
                            input.removeAttribute('required');
                        });
                    }
                });
            });
        });
    </script>
</body>
</html>