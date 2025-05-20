<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.bookstore.model.order.Order" %>
<%@ page import="com.bookstore.model.order.OrderItem" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - BookVerse</title>
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

        .order-success {
            text-align: center;
            padding: 40px 0;
        }

        .order-success i {
            font-size: 5rem;
            color: var(--success-color);
            margin-bottom: 20px;
        }

        .table-dark {
            background-color: var(--card-bg);
            color: var(--text-primary);
        }

        .table-dark th,
        .table-dark td {
            border-color: var(--border-color);
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

        .status-badge {
            font-size: 0.9rem;
            padding: 5px 10px;
            border-radius: 50px;
        }

        .status-pending {
            background-color: var(--warning-color);
            color: white;
        }

        .status-processing {
            background-color: var(--accent-color);
            color: white;
        }

        .status-shipped {
            background-color: var(--success-color);
            color: white;
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
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/order-history">My Orders</a></li>
                <li class="breadcrumb-item active" aria-current="page">Order Confirmation</li>
            </ol>
        </nav>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <%
        // Get order from request
        Order order = (Order)request.getAttribute("order");

        // Create formatters
        DecimalFormat df = new DecimalFormat("$#,##0.00");
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy");

        if (order != null) {
        %>
        <div class="card mb-4">
            <div class="card-body order-success">
                <i class="fas fa-check-circle"></i>
                <h2 class="mb-3">Order Placed Successfully!</h2>
                <p class="mb-0">Thank you for your order. Your order number is:</p>
                <h3 class="mb-4"><%= order.getOrderId() %></h3>
                <p>A confirmation email has been sent to <strong><%= order.getContactEmail() %></strong></p>
                <p>You can track your order status in the <a href="<%=request.getContextPath()%>/order-history">Order History</a> section.</p>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8 mb-4">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Order Details</h5>
                        <span class="status-badge status-<%= order.getStatus().toString().toLowerCase() %>"><%= order.getStatus() %></span>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6>Shipping Address</h6>
                                <address>
                                    <%= order.getShippingAddress() %>
                                </address>
                            </div>
                            <div class="col-md-6">
                                <h6>Contact Information</h6>
                                <p class="mb-1">Email: <%= order.getContactEmail() %></p>
                                <p>Phone: <%= order.getContactPhone() %></p>
                            </div>
                        </div>

                        <h6 class="mb-3">Order Items</h6>
                        <div class="table-responsive">
                            <table class="table table-dark">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    // Check if order has items
                                    if (order.getItems() != null) {
                                        for (OrderItem item : order.getItems()) {
                                    %>
                                        <tr>
                                            <td>
                                                <div>
                                                    <h6 class="mb-0"><%= item.getTitle() %></h6>
                                                    <small class="text-muted">by <%= item.getAuthor() %></small>
                                                </div>
                                            </td>
                                            <td><%= df.format(item.getDiscountedPrice()) %></td>
                                            <td><%= item.getQuantity() %></td>
                                            <td><%= df.format(item.getSubtotal()) %></td>
                                        </tr>
                                    <%
                                        }
                                    }
                                    %>
                                </tbody>
                            </table>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="<%=request.getContextPath()%>/order-history" class="btn btn-outline-light">
                                <i class="fas fa-list me-2"></i> View All Orders
                            </a>
                            <a href="<%=request.getContextPath()%>/" class="btn btn-accent">
                                <i class="fas fa-home me-2"></i> Continue Shopping
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="order-summary">
                    <h4 class="mb-4">Order Summary</h4>

                    <div class="price-row">
                        <span>Subtotal:</span>
                        <span><%= df.format(order.getSubtotal()) %></span>
                    </div>
                    <div class="price-row">
                        <span>Tax:</span>
                        <span><%= df.format(order.getTax()) %></span>
                    </div>
                    <div class="price-row">
                        <span>Shipping:</span>
                        <% if (order.getShippingCost() > 0) { %>
                            <span><%= df.format(order.getShippingCost()) %></span>
                        <% } else { %>
                            <span class="text-success">Free</span>
                        <% } %>
                    </div>

                    <div class="price-row total-row">
                        <span>Total:</span>
                        <span><%= df.format(order.getTotal()) %></span>
                    </div>

                    <hr>

                    <div class="mt-4">
                        <h6>Payment Information</h6>
                        <p class="mb-1">Method: <%= order.getPayment() != null ? order.getPayment().getPaymentMethod() : "Unknown" %></p>
                        <% if (order.getPayment() != null && order.getPayment().getPaymentDetails() != null) { %>
                            <p class="mb-1">Details: <%= order.getPayment().getPaymentDetails() %></p>
                        <% } %>
                        <p class="mb-0">Transaction ID: <%= order.getPayment() != null ? order.getPayment().getTransactionId() : "Unknown" %></p>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i>
                Order information is not available. Please check your order history.
            </div>
            <div class="text-center mt-4">
                <a href="<%=request.getContextPath()%>/order-history" class="btn btn-accent">
                    <i class="fas fa-list me-2"></i> View Order History
                </a>
            </div>
        <% } %>
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
</body>
</html>