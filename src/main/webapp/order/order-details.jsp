<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.order.Order" %>
<%@ page import="com.bookstore.model.order.OrderStatus" %>
<%@ page import="com.bookstore.model.order.OrderItem" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - BookVerse</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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

        .table-dark {
            background-color: var(--card-bg);
            color: var(--text-primary);
        }

        .table-dark th,
        .table-dark td {
            border-color: var(--border-color);
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
        }

        .status-PENDING {
            background-color: var(--warning-color);
            color: black;
        }

        .status-PROCESSING {
            background-color: var(--accent-color);
            color: white;
        }

        .status-SHIPPED {
            background-color: #2196F3;
            color: white;
        }

        .status-DELIVERED {
            background-color: var(--success-color);
            color: white;
        }

        .status-CANCELLED {
            background-color: var(--danger-color);
            color: white;
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

        .alert-custom {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .alert-success {
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            border-left: 4px solid var(--danger-color);
        }

        .modal-content {
            background-color: var(--card-bg);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .modal-header {
            border-bottom: 1px solid var(--border-color);
        }

        .modal-footer {
            border-top: 1px solid var(--border-color);
        }

        .btn-close-white {
            filter: invert(1) grayscale(100%) brightness(200%);
        }
    </style>
</head>
<body>
    <!-- Navbar -->
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
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/cart">
                            <i class="fas fa-shopping-cart"></i>
                            <%
                            Integer cartCount = (Integer)session.getAttribute("cartCount");
                            if (cartCount != null && cartCount > 0) {
                            %>
                            <span class="badge bg-accent rounded-pill"><%=cartCount%></span>
                            <% } %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=request.getContextPath()%>/order-history">
                            Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Home</a></li>
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/order-history">My Orders</a></li>
                <li class="breadcrumb-item active" aria-current="page">Order Details</li>
            </ol>
        </nav>

        <!-- Flash Messages -->
        <% if (session.getAttribute("successMessage") != null) { %>
        <div class="alert alert-custom alert-success alert-dismissible fade show mb-4" role="alert">
            <i class="fas fa-check-circle me-2"></i> <%= session.getAttribute("successMessage") %>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("successMessage"); %>
        <% } %>

        <% if (session.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> <%= session.getAttribute("errorMessage") %>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("errorMessage"); %>
        <% } %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-file-invoice me-2"></i> Order Details</h2>
            <a href="<%=request.getContextPath()%>/order-history" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i> Back to Orders
            </a>
        </div>

        <%
        // Get order from request
        Order order = (Order)request.getAttribute("order");

        // Format values
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy h:mm a");
        SimpleDateFormat dateOnlyFormat = new SimpleDateFormat("MMMM d, yyyy");
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

        if (order != null) {
            String statusDisplay = order.getStatus() != null ? order.getStatus().name() : "UNKNOWN";
        %>
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Order #<%= order.getOrderId() != null ? order.getOrderId().substring(0, 8) : "N/A" %></h5>
                <span class="status-badge status-<%= statusDisplay %>">
                    <%
                    if (order.getStatus() != null) {
                        switch(order.getStatus()) {
                            case PENDING:
                                %>Pending<%
                                break;
                            case PROCESSING:
                                %>Processing<%
                                break;
                            case SHIPPED:
                                %>Shipped<%
                                break;
                            case DELIVERED:
                                %>Delivered<%
                                break;
                            case CANCELLED:
                                %>Cancelled<%
                                break;
                            default:
                                %><%= order.getStatus() %><%
                        }
                    } else {
                        %>Unknown<%
                    }
                    %>
                </span>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6 class="mb-3">Order Information</h6>
                        <table class="table table-borderless table-dark">
                            <tr>
                                <th>Order Date:</th>
                                <td>
                                    <%= order.getOrderDate() != null ? dateFormat.format(order.getOrderDate()) : "N/A" %>
                                </td>
                            </tr>
                            <% if (order.getPayment() != null && order.getPayment().getPaymentDate() != null) { %>
                            <tr>
                                <th>Payment Date:</th>
                                <td><%= dateFormat.format(order.getPayment().getPaymentDate()) %></td>
                            </tr>
                            <% } %>
                            <% if (order.getShippedDate() != null) { %>
                            <tr>
                                <th>Shipped Date:</th>
                                <td><%= dateOnlyFormat.format(order.getShippedDate()) %></td>
                            </tr>
                            <% } %>
                            <% if (order.getTrackingNumber() != null && !order.getTrackingNumber().isEmpty()) { %>
                            <tr>
                                <th>Tracking Number:</th>
                                <td><%= order.getTrackingNumber() %></td>
                            </tr>
                            <% } %>
                            <% if (order.getDeliveredDate() != null) { %>
                            <tr>
                                <th>Delivered Date:</th>
                                <td><%= dateOnlyFormat.format(order.getDeliveredDate()) %></td>
                            </tr>
                            <% } %>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h6 class="mb-3">Shipping Information</h6>
                        <table class="table table-borderless table-dark">
                            <tr>
                                <th>Shipping Address:</th>
                                <td><%= order.getShippingAddress() %></td>
                            </tr>
                            <tr>
                                <th>Contact Email:</th>
                                <td><%= order.getContactEmail() %></td>
                            </tr>
                            <tr>
                                <th>Contact Phone:</th>
                                <td><%= order.getContactPhone() %></td>
                            </tr>
                            <% if (order.getPayment() != null) { %>
                            <tr>
                                <th>Payment Method:</th>
                                <td>
                                    <%= order.getPayment().getPaymentMethod() != null ?
                                        order.getPayment().getPaymentMethod().getDisplayName() : "N/A" %>
                                </td>
                            </tr>
                            <% if (order.getPayment().getPaymentDetails() != null && !order.getPayment().getPaymentDetails().isEmpty()) { %>
                            <tr>
                                <th>Payment Details:</th>
                                <td><%= order.getPayment().getPaymentDetails() %></td>
                            </tr>
                            <% } %>
                            <% } %>
                        </table>
                    </div>
                </div>

                <h6 class="mb-3 mt-4">Order Items</h6>
                <div class="table-responsive mb-4">
                    <table class="table table-dark table-hover">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Type</th>
                                <th class="text-end">Price</th>
                                <th class="text-center">Quantity</th>
                                <th class="text-end">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (order.getItems() != null && !order.getItems().isEmpty()) {
                                for (OrderItem item : order.getItems()) { %>
                                <tr>
                                    <td>
                                        <strong><%= item.getTitle() %></strong><br>
                                        <small class="text-muted">by <%= item.getAuthor() %></small>
                                    </td>
                                    <td>
                                        <%
                                        if (item.getBookType() != null) {
                                            if ("EBOOK".equals(item.getBookType())) { %>
                                                <span class="badge bg-primary">E-Book</span>
                                            <% } else if ("PHYSICAL".equals(item.getBookType())) { %>
                                                <span class="badge bg-info">Physical</span>
                                            <% } else { %>
                                                <span class="badge bg-secondary">Book</span>
                                            <% }
                                        } else { %>
                                            <span class="badge bg-secondary">Book</span>
                                        <% } %>
                                    </td>
                                    <td class="text-end">
                                        <%= currencyFormat.format(item.getDiscountedPrice()) %>
                                    </td>
                                    <td class="text-center"><%= item.getQuantity() %></td>
                                    <td class="text-end">
                                        <%= currencyFormat.format(item.getQuantity() * item.getDiscountedPrice()) %>
                                    </td>
                                </tr>
                                <% }
                            } else { %>
                            <tr>
                                <td colspan="5" class="text-center">No items in this order</td>
                            </tr>
                            <% } %>
                        </tbody>
                        <tfoot class="table-secondary text-dark">
                            <tr>
                                <td colspan="4" class="text-end"><strong>Subtotal:</strong></td>
                                <td class="text-end"><%= currencyFormat.format(order.getSubtotal()) %></td>
                            </tr>
                            <tr>
                                <td colspan="4" class="text-end"><strong>Tax:</strong></td>
                                <td class="text-end"><%= currencyFormat.format(order.getTax()) %></td>
                            </tr>
                            <tr>
                                <td colspan="4" class="text-end"><strong>Shipping:</strong></td>
                                <td class="text-end"><%= currencyFormat.format(order.getShippingCost()) %></td>
                            </tr>
                            <tr>
                                <td colspan="4" class="text-end"><strong>Total:</strong></td>
                                <td class="text-end"><strong><%= currencyFormat.format(order.getTotal()) %></strong></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="d-flex justify-content-between">
                    <a href="<%=request.getContextPath()%>/order-history" class="btn btn-outline-light">
                        <i class="fas fa-arrow-left me-2"></i> Back to Orders
                    </a>
                    <%
                    // Show cancel button only if order can be cancelled (PENDING or PROCESSING)
                    if (order.getStatus() == OrderStatus.PENDING || order.getStatus() == OrderStatus.PROCESSING) {
                    %>
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelOrderModal">
                            <i class="fas fa-times-circle me-2"></i> Cancel Order
                        </button>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Cancel Order Modal -->
        <% if (order.getStatus() == OrderStatus.PENDING || order.getStatus() == OrderStatus.PROCESSING) { %>
        <div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="cancelOrderModalLabel">Cancel Order</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to cancel this order?</p>
                        <p>This action cannot be undone. Any physical items will be returned to inventory.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No, Keep Order</button>
                        <form action="<%=request.getContextPath()%>/cancel-order" method="post">
                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                            <button type="submit" class="btn btn-danger">Yes, Cancel Order</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
        <% } else { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle me-2"></i> Order not found or no longer available.
        </div>
        <% } %>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
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