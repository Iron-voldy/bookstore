<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/manage-users.jsp">Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/manage-orders.jsp">Orders</a>
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
                            <i class="fas fa-user-circle me-1"></i> ${sessionScope.adminUsername}
                            <c:if test="${sessionScope.isSuperAdmin}">
                                <span class="badge bg-warning text-dark ms-1">Super Admin</span>
                            </c:if>
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
                    <h1 class="mb-2">Welcome back, ${admin.fullName}!</h1>
                    <p class="text-muted mb-0">
                        <i class="far fa-clock me-1"></i> Last login:
                        <c:choose>
                            <c:when test="${admin.lastLoginDate != null}">
                                <fmt:formatDate value="${admin.lastLoginDate}" pattern="MMMM d, yyyy 'at' h:mm a" />
                            </c:when>
                            <c:otherwise>
                                First time login
                            </c:otherwise>
                        </c:choose>
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
                    <div class="stat-number">${totalBooks}</div>
                    <div class="stat-title">Total Books</div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between">
                            <small>Physical Books:</small>
                            <small>${physicalBookCount}</small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>E-Books:</small>
                            <small>${ebookCount}</small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>Featured:</small>
                            <small>${featuredBookCount}</small>
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
                    <div class="stat-number">${totalUsers}</div>
                    <div class="stat-title">Total Users</div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between">
                            <small>Premium Users:</small>
                            <small>${premiumUserCount}</small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>Regular Users:</small>
                            <small>${regularUserCount}</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Orders Statistics (Placeholder) -->
            <div class="col-md-3 mb-4">
                <div class="card stat-card h-100">
                    <div class="stat-icon" style="color: #ff9800;">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="stat-number">0</div>
                    <div class="stat-title">Total Orders</div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between">
                            <small>Completed:</small>
                            <small>0</small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>Pending:</small>
                            <small>0</small>
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
                    <div class="stat-number">${totalAdmins}</div>
                    <div class="stat-title">Administrators</div>
                    <div class="mt-3">
                        <div class="d-flex justify-content-between">
                            <small>Super Admins:</small>
                            <small>${superAdminCount}</small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <small>Regular Admins:</small>
                            <small>${regularAdminCount}</small>
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
                                <a href="<%=request.getContextPath()%>/admin/manage-orders.jsp" class="btn btn-outline-light w-100">
                                    <i class="fas fa-clipboard-list me-2"></i> View Orders
                                </a>
                            </div>
                            <c:if test="${sessionScope.isSuperAdmin}">
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
                            </c:if>
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
                            <i class="fas fa-exclamation-circle me-2"></i> ${lowStockCount} books are low on stock or out of stock.
                        </div>
                        <a href="<%=request.getContextPath()%>/admin/manage-books.jsp?filter=out-of-stock" class="btn btn-sm btn-outline-danger mb-3">
                            <i class="fas fa-search me-1"></i> View Low Stock Books
                        </a>

                        <!-- Placeholder for other alerts -->
                        <div class="alert alert-warning mb-3" role="alert">
                            <i class="fas fa-info-circle me-2"></i> Reminder: Regular system backups are recommended.
                        </div>
                        <div class="alert alert-info" role="alert">
                            <i class="fas fa-info-circle me-2"></i> Welcome to the BookVerse Administration Panel!
                        </div>
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
                                <!-- This would be populated from a database in a real system -->
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="activity-icon bg-success">
                                                <i class="fas fa-plus"></i>
                                            </div>
                                            <div>New book "The Silent Patient" added</div>
                                        </div>
                                    </td>
                                    <td>admin</td>
                                    <td class="activity-time">Today, 10:24 AM</td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="activity-icon bg-primary">
                                                <i class="fas fa-edit"></i>
                                            </div>
                                            <div>Book "The Great Gatsby" updated</div>
                                        </div>
                                    </td>
                                    <td>john_admin</td>
                                    <td class="activity-time">Today, 9:15 AM</td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="activity-icon bg-info">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div>New user "janesmith" registered</div>
                                        </div>
                                    </td>
                                    <td>System</td>
                                    <td class="activity-time">Yesterday, 3:45 PM</td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="activity-icon bg-warning">
                                                <i class="fas fa-shopping-cart"></i>
                                            </div>
                                            <div>New order #1234 placed</div>
                                        </div>
                                    </td>
                                    <td>janesmith</td>
                                    <td class="activity-time">Yesterday, 2:30 PM</td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="activity-icon bg-danger">
                                                <i class="fas fa-trash"></i>
                                            </div>
                                            <div>Book "Old Title" removed</div>
                                        </div>
                                    </td>
                                    <td>admin</td>
                                    <td class="activity-time">2 days ago</td>
                                </tr>
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