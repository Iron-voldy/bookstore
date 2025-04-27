<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.order.OrderStatus" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History - BookVerse</title>
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

        .nav-link {
            color: var(--text-primary) !important;
            margin: 0 10px;
            position: relative;
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

        .btn-accent {
            background-color: var(--accent-color);
            color: white;
            border: none;
        }

        .btn-accent:hover {
            background-color: var(--accent-hover);
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
        <!-- Flash Messages -->
        <% if (session.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i> <%=session.getAttribute("successMessage")%>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("successMessage"); %>
        <% } %>

        <% if (session.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> <%=session.getAttribute("errorMessage")%>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("errorMessage"); %>
        <% } %>

        <h2 class="mb-4"><i class="fas fa-history me-2"></i>Order History</h2>

        <!-- Filter Controls -->
        <div class="card mb-4">
            <div class="card-body">
                <form action="<%=request.getContextPath()%>/order-history" method="get" class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label for="status" class="form-label">Filter by Status</label>
                        <select class="form-select" id="status" name="status" onchange="this.form.submit()">
                            <option value="">All Orders</option>
                            <%
                            // Explicitly set statuses to avoid potential null attribute issues
                            OrderStatus[] statuses = OrderStatus.values();
                            String statusFilter = request.getParameter("status");

                            for (OrderStatus status : statuses) {
                                String selected = "";
                                if (status.name().equals(statusFilter)) {
                                    selected = "selected";
                                }
                            %>
                                <option value="<%=status.name()%>" <%=selected%>>
                                    <%=status.getDisplayName()%>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <a href="<%=request.getContextPath()%>/order-history" class="btn btn-outline-light">
                            <i class="fas fa-sync-alt me-1"></i> Reset
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Orders List -->
        <%
        java.util.List<com.bookstore.model.order.Order> orders =
            (java.util.List<com.bookstore.model.order.Order>)request.getAttribute("orders");

        if (orders == null || orders.isEmpty()) {
        %>
            <div class="card">
                <div class="card-body text-center py-5">
                    <i class="fas fa-shopping-bag fa-4x mb-3" style="color: var(--border-color);"></i>
                    <h3>No Orders Found</h3>
                    <p class="text-muted">You haven't placed any orders yet.</p>
                    <a href="<%=request.getContextPath()%>/books" class="btn btn-accent mt-2">
                        <i class="fas fa-shopping-cart me-2"></i> Start Shopping
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-dark table-hover">
                    <thead>
                        <tr>
                            <th>Order #</th>
                            <th>Date</th>
                            <th>Items</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (com.bookstore.model.order.Order order : orders) { %>
                            <tr>
                                <td>
                                    <% if (order.getOrderId() != null) { %>
                                        <%=order.getOrderId().substring(0, 8)%>
                                    <% } else { %>
                                        N/A
                                    <% } %>
                                </td>
                                <td>
                                    <% if (order.getOrderDate() != null) { %>
                                        <%=new java.text.SimpleDateFormat("MMM d, yyyy").format(order.getOrderDate())%>
                                    <% } %>
                                </td>
                                <td><%=order.getTotalItems()%> item(s)</td>
                                <td>$<%=String.format("%.2f", order.getTotal())%></td>
                                <td>
                                    <%
                                    if (order.getStatus() != null) {
                                        switch(order.getStatus().name()) {
                                            case "PENDING":
                                    %>
                                                <span class="badge bg-warning text-dark">Pending</span>
                                    <%
                                                break;
                                            case "PROCESSING":
                                    %>
                                                <span class="badge bg-primary">Processing</span>
                                    <%
                                                break;
                                            case "SHIPPED":
                                    %>
                                                <span class="badge bg-info text-dark">Shipped</span>
                                    <%
                                                break;
                                            case "DELIVERED":
                                    %>
                                                <span class="badge bg-success">Delivered</span>
                                    <%
                                                break;
                                            case "CANCELLED":
                                    %>
                                                <span class="badge bg-danger">Cancelled</span>
                                    <%
                                                break;
                                            default:
                                    %>
                                                <span class="badge bg-secondary"><%=order.getStatus()%></span>
                                    <%
                                                break;
                                        }
                                    }
                                    %>
                                </td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/order-details?orderId=<%=order.getOrderId()%>"
                                       class="btn btn-sm btn-accent">
                                        <i class="fas fa-eye me-1"></i> View
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
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