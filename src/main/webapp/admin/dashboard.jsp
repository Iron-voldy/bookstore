<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.admin.Admin" %>
<%@ page import="com.bookstore.model.admin.AdminManager" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.BookManager" %>
<%@ page import="com.bookstore.model.book.EBook" %>
<%@ page import="com.bookstore.model.book.PhysicalBook" %>
<%@ page import="com.bookstore.model.user.User" %>
<%@ page import="com.bookstore.model.user.UserManager" %>
<%@ page import="com.bookstore.model.user.PremiumUser" %>
<%@ page import="com.bookstore.model.order.OrderManager" %>
<%@ page import="com.bookstore.model.order.OrderStatus" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - BookVerse</title>
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
        }

        .nav-link.active {
            color: var(--accent-color) !important;
            font-weight: 500;
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
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            font-weight: 600;
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

        .stat-card {
            padding: 20px;
            text-align: center;
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .stat-title {
            font-size: 1.1rem;
            color: var(--text-secondary);
        }

        .table-dark {
            background-color: var(--card-bg);
            color: var(--text-primary);
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            color: white;
            margin-right: 15px;
        }

        .activity-time {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .welcome-section {
            background: linear-gradient(to right, var(--secondary-dark), var(--card-bg));
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <%
        // Get admin information from session
        String adminId = (String) session.getAttribute("adminId");
        String adminUsername = (String) session.getAttribute("adminUsername");
        Boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");

        if (adminId == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Initialize data managers
        AdminManager adminManager = new AdminManager(application);
        BookManager bookManager = new BookManager(application);
        UserManager userManager = new UserManager(application);
        OrderManager orderManager = new OrderManager(application);

        // Get admin object
        Admin admin = adminManager.getAdminById(adminId);

        // Get book statistics
        Book[] allBooks = bookManager.getAllBooks();
        int totalBooks = allBooks != null ? allBooks.length : 0;

        // Count physical books and ebooks
        int physicalBookCount = 0;
        int ebookCount = 0;
        int featuredBookCount = 0;
        int lowStockCount = 0; // Books with quantity <= 5

        if (allBooks != null) {
            for (Book book : allBooks) {
                if (book instanceof PhysicalBook) {
                    physicalBookCount++;
                    if (book.getQuantity() <= 5) {
                        lowStockCount++;
                    }
                } else if (book instanceof EBook) {
                    ebookCount++;
                }

                if (book.isFeatured()) {
                    featuredBookCount++;
                }
            }
        }

        // User statistics
        int totalUsers = userManager.getUserCount();
        int premiumUserCount = userManager.getPremiumUserCount();
        int regularUserCount = totalUsers - premiumUserCount;

        // Admin statistics
        int totalAdmins = adminManager.getAdminCount();
        int superAdminCount = adminManager.getSuperAdminCount();
        int regularAdminCount = totalAdmins - superAdminCount;

        // Order statistics
        Map<OrderStatus, Integer> orderCounts = orderManager.getOrderCountsByStatus();
        double totalSales = orderManager.getTotalSales();

        int pendingOrders = orderCounts.getOrDefault(OrderStatus.PENDING, 0);
        int processingOrders = orderCounts.getOrDefault(OrderStatus.PROCESSING, 0);
        int shippedOrders = orderCounts.getOrDefault(OrderStatus.SHIPPED, 0);
        int deliveredOrders = orderCounts.getOrDefault(OrderStatus.DELIVERED, 0);
        int cancelledOrders = orderCounts.getOrDefault(OrderStatus.CANCELLED, 0);
        int totalOrders = pendingOrders + processingOrders + shippedOrders + deliveredOrders + cancelledOrders;

        // Format for last login date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy 'at' h:mm a");

        // Get recent activities (in a real app, this would come from an activity log)
        // For now, we'll create them based on book and user data
        List<String> activityTypes = new ArrayList<>();
        List<String> activityDescriptions = new ArrayList<>();
        List<String> activityUsers = new ArrayList<>();
        List<String> activityTimes = new ArrayList<>();

        // Add recent book additions (newest first)
        if (allBooks != null && allBooks.length > 0) {
            // Sort books by added date (descending)
            java.util.Arrays.sort(allBooks, (b1, b2) ->
                b2.getAddedDate().compareTo(b1.getAddedDate())
            );

            // Add the 5 most recent books
            for (int i = 0; i < Math.min(5, allBooks.length); i++) {
                Book book = allBooks[i];
                activityTypes.add("book-add");
                activityDescriptions.add("New book \"" + book.getTitle() + "\" added");
                activityUsers.add(adminUsername); // Assuming the current admin added them

                // Format the time based on how long ago
                long diffInMillis = System.currentTimeMillis() - book.getAddedDate().getTime();
                long diffInDays = diffInMillis / (24 * 60 * 60 * 1000);

                if (diffInDays == 0) {
                    activityTimes.add("Today");
                } else if (diffInDays == 1) {
                    activityTimes.add("Yesterday");
                } else {
                    activityTimes.add(diffInDays + " days ago");
                }
            }
        }
    %>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/">
                <i class="fas fa-book-open me-2"></i>BookVerse Admin
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=request.getContextPath()%>/admin/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/manage-books.jsp">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/orders">Orders</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/manage-users.jsp">Users</a>
                    </li>
                    <c:if test="${sessionScope.isSuperAdmin}">
                        <li class="nav-item">
                            <a class="nav-link" href="<%=request.getContextPath()%>/admin/manage-admins">Administrators</a>
                        </li>
                    </c:if>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-1"></i> <%= adminUsername %>
                            <% if (isSuperAdmin != null && isSuperAdmin) { %>
                                <span class="badge bg-warning text-dark ms-1">Super Admin</span>
                            <% } %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/admin/profile.jsp">My Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/admin/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-custom alert-success alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="row align-items-center">
                <div class="col-md-9">
                    <h1 class="mb-2">Welcome back, <%= admin != null ? admin.getFullName() : adminUsername %>!</h1>
                    <p class="text-muted mb-0">
                        <i class="far fa-clock me-1"></i> Last login:
                        <% if (admin != null && admin.getLastLoginDate() != null) { %>
                            <%= dateFormat.format(admin.getLastLoginDate()) %>
                        <% } else { %>
                            First time login
                        <% } %>
                    </p>
                </div>
                <div class="col-md-3 text-md-end mt-3 mt-md-0">
                    <a href="<%=request.getContextPath()%>/" class="btn btn-outline-light" target="_blank">
                        <i class="fas fa-external-link-alt me-1"></i> View Site
                    </a>
                </div>
            </div>
        </div>

        <!-- Statistics Section -->
        <h4 class="mb-4"><i class="fas fa-chart-line me-2"></i> Dashboard Overview</h4>
        <div class="row">
            <!-- Books Statistics -->
            <div class="col-md-3 mb-4">
                <div class="card stat-card h-100">
                    <div class="stat-icon" style="color: var(--accent-color);">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-number"><%= totalBooks %></div>
                    <div class="stat-title">Total Books</div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between">
                            <small>Physical Books:</small>
                            <small><%= physicalBookCount %></small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>E-Books:</small>
                            <small><%= ebookCount %></small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>Featured:</small>
                            <small><%= featuredBookCount %></small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Users Statistics -->
            <div class="col-md-3 mb-4">
                <div class="card stat-card h-100">
                    <div class="stat-icon" style="color: #4caf50;">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-number"><%= totalUsers %></div>
                    <div class="stat-title">Total Users</div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between">
                            <small>Premium Users:</small>
                            <small><%= premiumUserCount %></small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>Regular Users:</small>
                            <small><%= regularUserCount %></small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Orders Statistics -->
            <div class="col-md-3 mb-4">
                <div class="card stat-card h-100">
                    <div class="stat-icon" style="color: #ff9800;">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="stat-number"><%= totalOrders %></div>
                    <div class="stat-title">Total Orders</div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between">
                            <small>Completed:</small>
                            <small><%= deliveredOrders %></small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>Pending:</small>
                            <small><%= pendingOrders %></small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>Processing:</small>
                            <small><%= processingOrders %></small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Admin Statistics -->
            <div class="col-md-3 mb-4">
                <div class="card stat-card h-100">
                    <div class="stat-icon" style="color: #2196F3;">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <div class="stat-number"><%= totalAdmins %></div>
                    <div class="stat-title">Administrators</div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between">
                            <small>Super Admins:</small>
                            <small><%= superAdminCount %></small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>Regular Admins:</small>
                            <small><%= regularAdminCount %></small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-bolt me-2"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-6">
                                <a href="<%=request.getContextPath()%>/admin/add-book" class="btn btn-outline-light w-100">
                                    <i class="fas fa-plus-circle me-2"></i> Add Book
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="<%=request.getContextPath()%>/admin/manage-users.jsp" class="btn btn-outline-light w-100">
                                    <i class="fas fa-user-plus me-2"></i> Add User
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="<%=request.getContextPath()%>/admin/manage-books.jsp" class="btn btn-outline-light w-100">
                                    <i class="fas fa-book me-2"></i> Manage Books
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="<%=request.getContextPath()%>/admin/orders" class="btn btn-outline-light w-100">
                                    <i class="fas fa-clipboard-list me-2"></i> View Orders
                                </a>
                            </div>
                            <% if (isSuperAdmin != null && isSuperAdmin) { %>
                                <div class="col-6">
                                    <a href="<%=request.getContextPath()%>/admin/manage-admins" class="btn btn-outline-light w-100">
                                        <i class="fas fa-user-shield me-2"></i> Manage Admins
                                    </a>
                                </div>
                                <div class="col-6">
                                    <a href="<%=request.getContextPath()%>/admin/system-settings.jsp" class="btn btn-outline-light w-100">
                                        <i class="fas fa-cogs me-2"></i> System Settings
                                    </a>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- System Alerts -->
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-exclamation-triangle me-2"></i> System Alerts</h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-danger mb-3" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i> <%= lowStockCount %> books are low on stock or out of stock.
                        </div>
                        <a href="<%=request.getContextPath()%>/admin/manage-books.jsp?filter=out-of-stock" class="btn btn-sm btn-outline-danger mb-3">
                            <i class="fas fa-search me-1"></i> View Low Stock Books
                        </a>

                        <% if(pendingOrders > 0) { %>
                        <div class="alert alert-warning mb-3" role="alert">
                            <i class="fas fa-info-circle me-2"></i> You have <%= pendingOrders %> pending orders that need processing.
                        </div>
                        <a href="<%=request.getContextPath()%>/admin/orders?status=PENDING" class="btn btn-sm btn-outline-warning mb-3">
                            <i class="fas fa-search me-1"></i> View Pending Orders
                        </a>
                        <% } %>

                        <div class="alert alert-info" role="alert">
                            <i class="fas fa-info-circle me-2"></i> Welcome to the BookVerse Administration Panel!
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="row mt-2">
            <div class="col-md-12 mb-4">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i> Recent Orders</h5>
                        <a href="<%=request.getContextPath()%>/admin/orders" class="btn btn-sm btn-outline-light">View All Orders</a>
                    </div>
                    <div class="card-body">
                        <%
                        List<com.bookstore.model.order.Order> recentOrders = orderManager.getAllOrders();
                        if(recentOrders != null && !recentOrders.isEmpty()) {
                            // Limit to 5 most recent orders
                            int showCount = Math.min(5, recentOrders.size());
                        %>
                        <div class="table-responsive">
                            <table class="table table-dark table-hover">
                                <thead>
                                    <tr>
                                        <th>Order #</th>
                                        <th>Date</th>
                                        <th>Customer</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(int i = 0; i < showCount; i++) {
                                        com.bookstore.model.order.Order order = recentOrders.get(i);
                                    %>
                                    <tr>
                                        <td><%= order.getOrderId().substring(0, 8) %></td>
                                        <td><fmt:formatDate value="<%= order.getOrderDate() %>" pattern="MMM d, yyyy" /></td>
                                        <td><%= order.getContactEmail() %></td>
                                        <td>$<fmt:formatNumber value="<%= order.getTotal() %>" pattern="0.00" /></td>
                                        <td>
                                            <% if(order.getStatus() == OrderStatus.PENDING) { %>
                                                <span class="badge bg-warning text-dark">Pending</span>
                                            <% } else if(order.getStatus() == OrderStatus.PROCESSING) { %>
                                                <span class="badge bg-primary">Processing</span>
                                            <% } else if(order.getStatus() == OrderStatus.SHIPPED) { %>
                                                <span class="badge bg-info text-dark">Shipped</span>
                                            <% } else if(order.getStatus() == OrderStatus.DELIVERED) { %>
                                                <span class="badge bg-success">Delivered</span>
                                            <% } else if(order.getStatus() == OrderStatus.CANCELLED) { %>
                                                <span class="badge bg-danger">Cancelled</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <a href="<%=request.getContextPath()%>/admin/order-details?orderId=<%= order.getOrderId() %>" class="btn btn-sm btn-accent">
                                                <i class="fas fa-eye"></i> View
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="text-center py-4">
                            <i class="fas fa-shopping-cart fa-3x mb-3 text-muted"></i>
                            <p>No orders found in the system.</p>
                            <p>Orders will appear here once customers start placing them.</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activities -->
        <div class="row mt-2">
            <div class="col-md-12 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-history me-2"></i> Recent Activities</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-dark table-hover">
                            <thead>
                                <tr>
                                    <th>Activity</th>
                                    <th>User</th>
                                    <th>Date & Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                if (activityTypes.size() > 0) {
                                    for (int i = 0; i < activityTypes.size(); i++) {
                                        String iconClass = "";
                                        String bgClass = "";

                                        // Set icon and color based on activity type
                                        if (activityTypes.get(i).equals("book-add")) {
                                            iconClass = "fas fa-plus";
                                            bgClass = "bg-success";
                                        } else if (activityTypes.get(i).equals("book-edit")) {
                                            iconClass = "fas fa-edit";
                                            bgClass = "bg-primary";
                                        } else if (activityTypes.get(i).equals("user-add")) {
                                            iconClass = "fas fa-user";
                                            bgClass = "bg-info";
                                        } else if (activityTypes.get(i).equals("order")) {
                                            iconClass = "fas fa-shopping-cart";
                                            bgClass = "bg-warning";
                                        } else if (activityTypes.get(i).equals("book-delete")) {
                                            iconClass = "fas fa-trash";
                                            bgClass = "bg-danger";
                                        }
                                %>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="activity-icon <%= bgClass %>">
                                                <i class="<%= iconClass %>"></i>
                                            </div>
                                            <div><%= activityDescriptions.get(i) %></div>
                                        </div>
                                    </td>
                                    <td><%= activityUsers.get(i) %></td>
                                    <td class="activity-time"><%= activityTimes.get(i) %></td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="3" class="text-center">No recent activities found</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer text-end">
                        <a href="#" class="btn btn-sm btn-outline-light">View All Activities</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-3 mt-5">
        <div class="container text-center">
            <p class="mb-0">&copy; 2023 BookVerse Administration Panel. All rights reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>