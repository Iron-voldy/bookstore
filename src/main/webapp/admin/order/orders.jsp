<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.order.Order" %>
<%@ page import="com.bookstore.model.order.OrderStatus" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Admin Dashboard</title>
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
                    --info-color: #2196F3;
                    --card-bg: #252525;
                    --border-color: #333333;
                }

                body {
                    background-color: var(--primary-dark);
                    color: var(--text-primary);
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                .sidebar {
                    background-color: var(--secondary-dark);
                    min-height: 100vh;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 250px;
                    padding-top: 20px;
                    z-index: 100;
                }

                .sidebar-brand {
                    padding: 15px 20px;
                    margin-bottom: 20px;
                    border-bottom: 1px solid var(--border-color);
                }

                .sidebar-brand a {
                    color: var(--accent-color);
                    text-decoration: none;
                    font-weight: bold;
                    font-size: 1.2rem;
                }

                .sidebar-menu {
                    padding: 0;
                    list-style: none;
                }

                .sidebar-menu li {
                    margin-bottom: 5px;
                }

                .sidebar-menu a {
                    display: block;
                    padding: 12px 20px;
                    color: var(--text-primary);
                    text-decoration: none;
                    transition: all 0.3s;
                }

                .sidebar-menu a:hover,
                .sidebar-menu a.active {
                    background-color: rgba(138, 92, 245, 0.1);
                    color: var(--accent-color);
                    border-left: 4px solid var(--accent-color);
                }

                .sidebar-menu a.active {
                    font-weight: 500;
                }

                .sidebar-menu i {
                    margin-right: 10px;
                    width: 20px;
                    text-align: center;
                }

                .main-content {
                    margin-left: 250px;
                    padding: 20px;
                }

                .card {
                    background-color: var(--card-bg);
                    border: 1px solid var(--border-color);
                    border-radius: 8px;
                    margin-bottom: 20px;
                }

                .card-header {
                    background-color: var(--secondary-dark);
                    border-bottom: 1px solid var(--border-color);
                    padding: 15px 20px;
                }

                .stat-card {
                    border-left: 4px solid;
                    transition: transform 0.3s;
                }

                .stat-card:hover {
                    transform: translateY(-5px);
                }

                .stat-card.pending {
                    border-left-color: var(--warning-color);
                }

                .stat-card.processing {
                    border-left-color: var(--accent-color);
                }

                .stat-card.shipped {
                    border-left-color: var(--info-color);
                }

                .stat-card.delivered {
                    border-left-color: var(--success-color);
                }

                .stat-card.cancelled {
                    border-left-color: var(--danger-color);
                }

                .stat-card.sales {
                    border-left-color: #28a745;
                }

                .stat-card .stat-icon {
                    font-size: 2.5rem;
                    opacity: 0.8;
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
                    color: white;
                }

                .search-container {
                    position: relative;
                }

                .search-container .form-control {
                    background-color: var(--secondary-dark);
                    border: 1px solid var(--border-color);
                    color: var(--text-primary);
                    padding-left: 40px;
                }

                .search-icon {
                    position: absolute;
                    left: 15px;
                    top: 10px;
                    color: var(--text-secondary);
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
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-book-open me-2"></i> BookVerse Admin
            </a>
        </div>
        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/manage-books.jsp">
                    <i class="fas fa-book"></i> Books
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/orders" class="active">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/manage-users.jsp">
                    <i class="fas fa-users"></i> Users
                </a>
            </li>
            <c:if test="${sessionScope.isSuperAdmin}">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/manage-admins">
                        <i class="fas fa-user-shield"></i> Admins
                    </a>
                </li>
            </c:if>
            <li>
                <a href="${pageContext.request.contextPath}/admin/logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-custom alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-custom alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Page Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-shopping-cart me-2"></i> Order Management</h2>
            <div class="search-container">
                <form action="${pageContext.request.contextPath}/admin/orders" method="get">
                    <div class="input-group">
                        <span class="search-icon">
                            <i class="fas fa-search"></i>
                        </span>
                        <input type="text" class="form-control" name="search" placeholder="Search orders..." value="${search}">
                        <button class="btn btn-accent" type="submit">Search</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Order Statistics -->
        <div class="row mb-4">
            <div class="col-md-2">
                <div class="card stat-card pending">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-warning">Pending</h6>
                            <h3 class="mb-0">${orderCounts['PENDING'] != null ? orderCounts['PENDING'] : 0}</h3>
                        </div>
                        <div class="stat-icon text-warning">
                            <i class="fas fa-clock"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card stat-card processing">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-primary">Processing</h6>
                            <h3 class="mb-0">${orderCounts['PROCESSING'] != null ? orderCounts['PROCESSING'] : 0}</h3>
                        </div>
                        <div class="stat-icon text-primary">
                            <i class="fas fa-spinner"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card stat-card shipped">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-info">Shipped</h6>
                            <h3 class="mb-0">${orderCounts['SHIPPED'] != null ? orderCounts['SHIPPED'] : 0}</h3>
                        </div>
                        <div class="stat-icon text-info">
                            <i class="fas fa-truck"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card stat-card delivered">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-success">Delivered</h6>
                            <h3 class="mb-0">${orderCounts['DELIVERED'] != null ? orderCounts['DELIVERED'] : 0}</h3>
                        </div>
                        <div class="stat-icon text-success">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card stat-card cancelled">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-danger">Cancelled</h6>
                            <h3 class="mb-0">${orderCounts['CANCELLED'] != null ? orderCounts['CANCELLED'] : 0}</h3>
                        </div>
                        <div class="stat-icon text-danger">
                            <i class="fas fa-times-circle"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card stat-card sales">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-success">Total Sales</h6>
                            <h3 class="mb-0">$
                                <c:choose>
                                    <c:when test="${totalSales != null}">
                                        <fmt:formatNumber value="${totalSales}" pattern="0.00" />
                                    </c:when>
                                    <c:otherwise>
                                        0.00
                                    </c:otherwise>
                                </c:choose>
                            </h3>
                        </div>
                        <div class="stat-icon text-success">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Controls -->
        <div class="card mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/orders" method="get" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label for="status" class="form-label">Filter by Status</label>
                        <select class="form-select" id="status" name="status" onchange="this.form.submit()">
                            <option value="" ${empty statusFilter ? 'selected' : ''}>All Orders</option>
                            <c:forEach var="status" items="${statuses}">
                                <option value="${status}" ${status.name() == statusFilter ? 'selected' : ''}>${status.displayName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-light">
                            <i class="fas fa-sync-alt me-1"></i> Reset Filters
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <c:choose>
                        <c:when test="${not empty search}">
                            Search Results for "${search}"
                        </c:when>
                        <c:when test="${not empty statusFilter}">
                            ${statusFilter} Orders
                        </c:when>
                        <c:otherwise>
                            All Orders
                        </c:otherwise>
                    </c:choose>
                </h5>
                <span>Showing ${orders.size()} order(s)</span>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="text-center py-5">
                            <i class="fas fa-search fa-4x mb-3" style="color: var(--border-color);"></i>
                            <h4>No Orders Found</h4>
                            <p class="text-muted">Try adjusting your search or filter criteria</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-dark table-hover">
                                <thead>
                                    <tr>
                                        <th>Order #</th>
                                        <th>Date</th>
                                        <th>Customer</th>
                                        <th>Items</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td>${order.orderId.substring(0, 8)}</td>
                                            <td>
                                                <fmt:formatDate value="${order.orderDate}" pattern="MMM d, yyyy HH:mm" />
                                            </td>
                                            <td>${order.contactEmail}</td>
                                            <td>${order.items.size()} item(s)</td>
                                            <td>$<fmt:formatNumber value="${order.total}" pattern="0.00" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.status == 'PENDING'}">
                                                        <span class="badge bg-warning text-dark">Pending</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'PROCESSING'}">
                                                        <span class="badge bg-primary">Processing</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'SHIPPED'}">
                                                        <span class="badge bg-info text-dark">Shipped</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'DELIVERED'}">
                                                        <span class="badge bg-success">Delivered</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'CANCELLED'}">
                                                        <span class="badge bg-danger">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${order.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/order-details?orderId=${order.orderId}"
                                                   class="btn btn-sm btn-accent">
                                                    <i class="fas fa-eye me-1"></i> View
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>