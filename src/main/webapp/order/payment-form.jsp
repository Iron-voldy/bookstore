<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/includes/header.jsp">
    <jsp:param name="pageTitle" value="Payment - BookVerse" />
</jsp:include>

<div class="container my-5">
    <h2 class="mb-4"><i class="fas fa-credit-card me-2"></i>Payment Details</h2>

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart">Cart</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/checkout">Checkout</a></li>
            <li class="breadcrumb-item active" aria-current="page">Payment</li>
        </ol>
    </nav>

    <div class="row">
        <!-- Payment Form -->
        <div class="col-lg-8 mb-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Payment Information</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/process-payment" method="post" id="paymentForm">
                        <!-- Payment Method Selection -->
                        <h6 class="mb-3">Select Payment Method</h6>
                        <div class="mb-4">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="creditCard" value="CREDIT_CARD" checked>
                                <label class="form-check-label" for="creditCard">
                                    <i class="fab fa-cc-visa me-1"></i> Credit Card
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="debitCard" value="DEBIT_CARD">
                                <label class="form-check-label" for="debitCard">
                                    <i class="fab fa-cc-mastercard me-1"></i> Debit Card
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="paypal" value="PAYPAL">
                                <label class="form-check-label" for="paypal">
                                    <i class="fab fa-paypal me-1"></i> PayPal
                                </label>
                            </div>
                        </div>

                        <!-- Card Information -->
                        <div id="cardDetails">
                            <h6 class="mb-3">Card Details</h6>
                            <div class="mb-3">
                                <label for="cardNumber" class="form-label">Card Number*</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="cardNumber" name="cardNumber"
                                        placeholder="1234 5678 9012 3456" maxlength="19" required>
                                    <span class="input-group-text">
                                        <i class="far fa-credit-card"></i>
                                    </span>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="cardName" class="form-label">Cardholder Name*</label>
                                <input type="text" class="form-control" id="cardName" name="cardName"
                                    placeholder="John Doe" required>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="expiryDate" class="form-label">Expiry Date*</label>
                                    <input type="text" class="form-control" id="expiryDate" name="expiryDate"
                                        placeholder="MM/YY" maxlength="5" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="cvv" class="form-label">CVV*</label>
                                    <input type="text" class="form-control" id="cvv" name="cvv"
                                        placeholder="123" maxlength="4" required>
                                </div>
                            </div>
                        </div>

                        <!-- PayPal Section (hidden by default) -->
                        <div id="paypalDetails" style="display: none;">
                            <div class="alert alert-info" role="alert">
                                <i class="fab fa-paypal me-2"></i> You will be redirected to PayPal to complete your purchase securely.
                            </div>
                        </div>

                        <!-- Billing Summary -->
                        <h6 class="mb-3 mt-4">Billing Summary</h6>
                        <div class="card bg-dark mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Order Subtotal:</span>
                                    <span>$<fmt:formatNumber value="${order.subtotal}" pattern="0.00" /></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Tax:</span>
                                    <span>$<fmt:formatNumber value="${order.tax}" pattern="0.00" /></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Shipping:</span>
                                    <span>$<fmt:formatNumber value="${order.shippingCost}" pattern="0.00" /></span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between fw-bold">
                                    <span>Total:</span>
                                    <span class="text-accent">$<fmt:formatNumber value="${order.total}" pattern="0.00" /></span>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-accent btn-lg" id="paymentButton">
                                <i class="fas fa-lock me-2"></i> Complete Payment
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Order Summary -->
        <div class="col-lg-4">
            <div class="card sticky-top" style="top: 20px">
                <div class="card-header">
                    <h5 class="mb-0">Order #${not empty order.orderId ? order.orderId.substring(0, 8) : ''}</h5>
                </div>
                <div class="card-body">
                    <!-- Order Items -->
                    <h6 class="mb-3">Items (${not empty order.items ? order.items.size() : 0})</h6>
                    <div class="table-responsive">
                        <table class="table table-sm table-dark">
                            <c:forEach var="item" items="${order.items}">
                                <tr>
                                    <td>
                                        <strong>${item.title}</strong><br>
                                        <small class="text-muted">Qty: ${item.quantity}</small>
                                    </td>
                                    <td class="text-end">
                                        $<fmt:formatNumber value="${item.discountedPrice * item.quantity}" pattern="0.00" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>

                    <!-- Shipping Address -->
                    <div class="mt-3">
                        <h6 class="mb-2">Shipping Address</h6>
                        <p class="small text-muted mb-0">${order.shippingAddress}</p>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="d-flex align-items-center">
                        <div>
                            <i class="fas fa-shield-alt me-2 text-success"></i>
                        </div>
                        <div class="small text-muted">
                            Your payment information is processed securely. We do not store credit card details.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Toggle payment method sections
    document.addEventListener('DOMContentLoaded', function() {
        // Toggle payment method sections
        const paymentMethodRadios = document.querySelectorAll('input[name="paymentMethod"]');
        const cardDetails = document.getElementById('cardDetails');
        const paypalDetails = document.getElementById('paypalDetails');
        const paymentButton = document.getElementById('paymentButton');

        paymentMethodRadios.forEach(radio => {
            radio.addEventListener('change', function() {
                if (this.value === 'PAYPAL') {
                    cardDetails.style.display = 'none';
                    paypalDetails.style.display = 'block';
                    paymentButton.innerHTML = '<i class="fab fa-paypal me-2"></i> Pay with PayPal';

                    // Disable card validation
                    document.getElementById('cardNumber').removeAttribute('required');
                    document.getElementById('cardName').removeAttribute('required');
                    document.getElementById('expiryDate').removeAttribute('required');
                    document.getElementById('cvv').removeAttribute('required');
                } else {
                    cardDetails.style.display = 'block';
                    paypalDetails.style.display = 'none';
                    paymentButton.innerHTML = '<i class="fas fa-lock me-2"></i> Complete Payment';

                    // Enable card validation
                    document.getElementById('cardNumber').setAttribute('required', '');
                    document.getElementById('cardName').setAttribute('required', '');
                    document.getElementById('expiryDate').setAttribute('required', '');
                    document.getElementById('cvv').setAttribute('required', '');
                }
            });
        });

        // Format card number with spaces
        const cardNumberInput = document.getElementById('cardNumber');
        if (cardNumberInput) {
            cardNumberInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
                let formattedValue = '';

                for (let i = 0; i < value.length; i++) {
                    if (i > 0 && i % 4 === 0) {
                        formattedValue += ' ';
                    }
                    formattedValue += value[i];
                }

                e.target.value = formattedValue;
            });
        }

        // Format expiry date as MM/YY
        const expiryDateInput = document.getElementById('expiryDate');
        if (expiryDateInput) {
            expiryDateInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');

                if (value.length > 2) {
                    value = value.substring(0, 2) + '/' + value.substring(2, 4);
                }

                e.target.value = value;
            });
        }

        // Only allow numbers for CVV
        const cvvInput = document.getElementById('cvv');
        if (cvvInput) {
            cvvInput.addEventListener('input', function(e) {
                e.target.value = e.target.value.replace(/\D/g, '');
            });
        }
    });
</script>

<jsp:include page="/includes/footer.jsp" />