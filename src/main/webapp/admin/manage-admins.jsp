<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Administrators - BookVerse Admin</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
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

        /* DataTables Custom Styling */
        .dataTables_wrapper {
            padding: 20px 0;
        }

        table.dataTable {
            border-collapse: collapse !important;
            color: var(--text-primary);
        }

        .table-dark {
            background-color: var(--card-bg);
            color: var(--text-primary);
        }

        .table-dark th,
        .table-dark td {
            border-color: var(--border-color);
        }

        .dataTables_info,
        .dataTables_paginate,
        .dataTables_length,
        .dataTables_filter {
            color: var(--text-secondary) !important;
            margin: 10px 0;
        }

        .dataTables_filter input,
        .dataTables_length select {
            background-color: var(--secondary-dark) !important;
            border: 1px solid var(--border-color) !important;
            color: var(--text-primary) !important;
            border-radius: 4px;
            padding: 5px 10px;
        }

        .page-link {
            background-color: var(--secondary-dark);
            border-color: var(--border-color);
            color: var(--text-primary);
        }

        .page-item.active .page-link {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
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

        .modal-content {
            background-color: var(--card-bg);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .modal-header, .modal-footer {
            border-color: var(--border-color);
        }

        .badge-super-admin {
            background-color: #ff9800;
            color: black;
        }

        .badge-admin {
            background-color: #2196F3;
            color: white;
        }

        .badge-active {
            background-color: var(--success-color);
        }

        .badge-inactive {
            background-color: var(--danger-color);
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
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/dashboard">Dashboard</a>
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
                            <a class="nav-link active" href="<%=request.getContextPath()%>/admin/manage-admins">Administrators</a>
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

        <!-- Page Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-user-shield me-2"></i> Manage Administrators</h2>
            <button type="button" class="btn btn-accent" data-bs-toggle="modal" data-bs-target="#addAdminModal">
                <i class="fas fa-plus-circle me-1"></i> Add Administrator
            </button>
        </div>

        <!-- Admins Table Card -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Administrator Accounts</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="adminsTable" class="table table-dark table-hover">
                        <thead>
                            <tr>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Last Login</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="admin" items="${admins}">
                                <tr>
                                    <td>${admin.username}</td>
                                    <td>${admin.fullName}</td>
                                    <td>${admin.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${admin.role eq 'SUPER_ADMIN'}">
                                                <span class="badge badge-super-admin">Super Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-admin">Admin</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${admin.active}">
                                                <span class="badge badge-active">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactive">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${admin.lastLoginDate != null}">
                                                <fmt:formatDate value="${admin.lastLoginDate}" pattern="MM/dd/yyyy HH:mm" />
                                            </c:when>
                                            <c:otherwise>
                                                Never
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <!-- Edit Button -->
                                            <button type="button" class="btn btn-outline-light"
                                                    data-bs-toggle="modal" data-bs-target="#editAdminModal"
                                                    data-admin-id="${admin.adminId}"
                                                    data-username="${admin.username}"
                                                    data-fullname="${admin.fullName}"
                                                    data-email="${admin.email}"
                                                    data-role="${admin.role}">
                                                <i class="fas fa-edit"></i>
                                            </button>

                                            <!-- Reset Password Button -->
                                            <button type="button" class="btn btn-outline-warning"
                                                    data-bs-toggle="modal" data-bs-target="#resetPasswordModal"
                                                    data-admin-id="${admin.adminId}"
                                                    data-username="${admin.username}">
                                                <i class="fas fa-key"></i>
                                            </button>

                                            <!-- Activate/Deactivate Button -->
                                            <c:if test="${sessionScope.adminId ne admin.adminId}">
                                                <c:choose>
                                                    <c:when test="${admin.active}">
                                                        <button type="button" class="btn btn-outline-danger"
                                                                onclick="confirmDeactivate('${admin.adminId}', '${admin.username}')">
                                                            <i class="fas fa-user-slash"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="<%=request.getContextPath()%>/admin/manage-admins" method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="activate">
                                                            <input type="hidden" name="adminId" value="${admin.adminId}">
                                                            <button type="submit" class="btn btn-outline-success">
                                                                <i class="fas fa-user-check"></i>
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>

                                            <!-- Delete Button -->
                                            <c:if test="${sessionScope.adminId ne admin.adminId}">
                                                <button type="button" class="btn btn-outline-danger"
                                                        onclick="confirmDelete('${admin.adminId}', '${admin.username}')">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Admin Modal -->
    <div class="modal fade" id="addAdminModal" tabindex="-1" aria-labelledby="addAdminModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addAdminModalLabel">Add New Administrator</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%=request.getContextPath()%>/admin/manage-admins" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="role" class="form-label">Role</label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="ADMIN">Admin</option>
                                <option value="SUPER_ADMIN">Super Admin</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-accent">Add Administrator</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Admin Modal -->
    <div class="modal fade" id="editAdminModal" tabindex="-1" aria-labelledby="editAdminModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editAdminModalLabel">Edit Administrator</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%=request.getContextPath()%>/admin/manage-admins" method="post">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="adminId" id="editAdminId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="editUsername" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="editFullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="editFullName" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="editEmail" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="editRole" class="form-label">Role</label>
                            <select class="form-select" id="editRole" name="role" required>
                                <option value="ADMIN">Admin</option>
                                <option value="SUPER_ADMIN">Super Admin</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-accent">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Reset Password Modal -->
    <div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-labelledby="resetPasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resetPasswordModalLabel">Reset Password</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%=request.getContextPath()%>/admin/manage-admins" method="post">
                    <input type="hidden" name="action" value="resetPassword">
                    <input type="hidden" name="adminId" id="resetPasswordAdminId">
                    <div class="modal-body">
                        <p>Reset password for administrator: <strong id="resetPasswordUsername"></strong></p>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmNewPassword" class="form-label">Confirm New Password</label>
                            <input type="password" class="form-control" id="confirmNewPassword" name="confirmPassword" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-accent">Reset Password</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete administrator <span id="deleteAdminUsername" class="fw-bold"></span>?
                    <p class="text-danger mt-2">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" action="<%=request.getContextPath()%>/admin/manage-admins" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="adminId" id="deleteAdminId">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Deactivate Confirmation Modal -->
    <div class="modal fade" id="deactivateModal" tabindex="-1" aria-labelledby="deactivateModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deactivateModalLabel">Confirm Deactivation</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to deactivate administrator <span id="deactivateAdminUsername" class="fw-bold"></span>?
                    <p class="mt-2">Deactivated administrators cannot log in, but their account information is preserved.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deactivateForm" action="<%=request.getContextPath()%>/admin/manage-admins" method="post">
                        <input type="hidden" name="action" value="deactivate">
                        <input type="hidden" name="adminId" id="deactivateAdminId">
                        <button type="submit" class="btn btn-danger">Deactivate</button>
                    </form>
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

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>

    <!-- Custom JavaScript -->
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            $('#adminsTable').DataTable({
                responsive: true,
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                language: {
                    search: "_INPUT_",
                    searchPlaceholder: "Search administrators..."
                }
            });

            // Edit Admin Modal
            $('#editAdminModal').on('show.bs.modal', function (event) {
                const button = $(event.relatedTarget);
                const adminId = button.data('admin-id');
                const username = button.data('username');
                const fullName = button.data('fullname');
                const email = button.data('email');
                const role = button.data('role');

                const modal = $(this);
                modal.find('#editAdminId').val(adminId);
                modal.find('#editUsername').val(username);
                modal.find('#editFullName').val(fullName);
                modal.find('#editEmail').val(email);
                modal.find('#editRole').val(role);
            });

            // Reset Password Modal
            $('#resetPasswordModal').on('show.bs.modal', function (event) {
                const button = $(event.relatedTarget);
                const adminId = button.data('admin-id');
                const username = button.data('username');

                const modal = $(this);
                modal.find('#resetPasswordAdminId').val(adminId);
                modal.find('#resetPasswordUsername').text(username);
            });

            // Password match validation for add form
            $('#addAdminModal form').on('submit', function(e) {
                const password = $('#password').val();
                const confirmPassword = $('#confirmPassword').val();

                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                }
            });

            // Password match validation for reset password form
            $('#resetPasswordModal form').on('submit', function(e) {
                const newPassword = $('#newPassword').val();
                const confirmNewPassword = $('#confirmNewPassword').val();

                if (newPassword !== confirmNewPassword) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                }
            });
        });

        // Delete confirmation
        function confirmDelete(adminId, username) {
            document.getElementById('deleteAdminId').value = adminId;
            document.getElementById('deleteAdminUsername').textContent = username;

            const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }

        // Deactivate confirmation
        function confirmDeactivate(adminId, username) {
            document.getElementById('deactivateAdminId').value = adminId;
            document.getElementById('deactivateAdminUsername').textContent = username;

            const deactivateModal = new bootstrap.Modal(document.getElementById('deactivateModal'));
            deactivateModal.show();
        }
    </script>
</body>
</html>