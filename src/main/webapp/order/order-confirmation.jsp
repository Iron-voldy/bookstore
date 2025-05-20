<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - Online Bookstore</title>
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
                    <div class="card-header bg-success text-white">
                        <h3 class="card-title mb-0">Order Confirmed</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success">${successMessage}</div>
                        </c:if>

                        <div class="text-center mb-4">
                            <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                            <h4 class="mt-3">Thank you for your order!</h4>
                            <p>Your order has been placed successfully.</p>
                        </div>

                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Order Details</h5>
                            </div>
                            <div class="card-body">
                                <p><strong>Order ID:</strong> ${order.orderId}</p>
                                <p><strong>Order Status:</strong> ${order.status}</p>
                                <c:if test="${not empty order.payment}">
                                    <p><strong>Payment Method:</strong> ${order.payment.paymentMethod}</p>
                                </c:if>
                                <p><strong>Shipping Address:</strong> ${order.shippingAddress}</p>
                            </div>
                        </div>

                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Order Items</h5>
                            </div>
                            <div class="card-body">
                                <c:if test="${empty order.items}">
                                    <p>No items in this order.</p>
                                </c:if>
                                <c:if test="${not empty order.items}">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Product</th>
                                                    <th>Price</th>
                                                    <th>Quantity</th>
                                                    <th class="text-end">Subtotal</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${order.items}">
                                                    <tr>
                                                        <td>
                                                            <div>
                                                                <strong>${item.title}</strong>
                                                            </div>
                                                            <small class="text-muted">by ${item.author}</small>
                                                        </td>
                                                        <td>$${item.discountedPrice}</td>
                                                        <td>${item.quantity}</td>
                                                        <td class="text-end">$${item.subtotal}</td>
                                                    </tr>
                                                </c:forEach>
                                                <tr>
                                                    <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
                                                    <td class="text-end">$${orderSubtotal}</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" class="text-end"><strong>Tax:</strong></td>
                                                    <td class="text-end">$${orderTax}</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" class="text-end"><strong>Shipping:</strong></td>
                                                    <td class="text-end">$${orderShipping}</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                                    <td class="text-end">$${orderTotal}</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/order-details?orderId=${order.orderId}" class="btn btn-primary">View Order Details</a>
                            <a href="${pageContext.request.contextPath}/order-history" class="btn btn-outline-secondary">View All Orders</a>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">Continue Shopping</a>
                        </div>
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
</body>
</html>