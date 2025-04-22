<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.BookManager" %>
<%@ page import="com.bookstore.model.book.EBook" %>
<%@ page import="com.bookstore.model.book.PhysicalBook" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Books - BookVerse Admin</title>
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

        .book-cover-thumb {
            width: 50px;
            height: 75px;
            object-fit: cover;
            border-radius: 4px;
        }

        .badge-ebook {
            background-color: #4267B2;
        }

        .badge-physical {
            background-color: #8a5cf5;
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
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/dashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=request.getContextPath()%>/admin/manage-books.jsp">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/manage-users.jsp">Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/manage-orders.jsp">Orders</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/logout">
                            <i class="fas fa-sign-out-alt me-1"></i> Logout
                        </a>
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
            <h2><i class="fas fa-books me-2"></i> Manage Books</h2>
            <a href="<%=request.getContextPath()%>/admin/add-book" class="btn btn-accent">
                <i class="fas fa-plus-circle me-1"></i> Add New Book
            </a>
        </div>

        <!-- Books Table Card -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Book Inventory</h5>
                <div class="dropdown">
                    <button class="btn btn-sm btn-outline-light dropdown-toggle" type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-filter me-1"></i> Filter
                    </button>
                    <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="filterDropdown">
                        <li><a class="dropdown-item" href="#" onclick="filterBooks('all')">All Books</a></li>
                        <li><a class="dropdown-item" href="#" onclick="filterBooks('physical')">Physical Books</a></li>
                        <li><a class="dropdown-item" href="#" onclick="filterBooks('ebook')">E-Books</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#" onclick="filterBooks('featured')">Featured Books</a></li>
                        <li><a class="dropdown-item" href="#" onclick="filterBooks('out-of-stock')">Out of Stock</a></li>
                    </ul>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="booksTable" class="table table-dark table-hover">
                        <thead>
                            <tr>
                                <th>Cover</th>
                                <th>Title</th>
                                <th>Author</th>
                                <th>ISBN</th>
                                <th>Type</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Get all books from database
                                BookManager bookManager = new BookManager(application);
                                Book[] books = bookManager.getAllBooks();

                                if (books != null && books.length > 0) {
                                    for (Book book : books) {
                                        // Determine book type
                                        String bookType = "Regular";
                                        String badgeClass = "bg-secondary";

                                        if (book instanceof PhysicalBook) {
                                            bookType = "Physical";
                                            badgeClass = "badge-physical";
                                        } else if (book instanceof EBook) {
                                            bookType = "E-Book";
                                            badgeClass = "badge-ebook";
                                        }

                                        // Get cover image URL
                                        String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
                                        if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
                                            coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
                                        }
                            %>
                            <tr>
                                <td>
                                    <img src="<%= coverPath %>" alt="<%= book.getTitle() %>" class="book-cover-thumb">
                                </td>
                                <td><%= book.getTitle() %></td>
                                <td><%= book.getAuthor() %></td>
                                <td><%= book.getIsbn() %></td>
                                <td><span class="badge <%= badgeClass %>"><%= bookType %></span></td>
                                <td>$<fmt:formatNumber value="<%= book.getPrice() %>" pattern="#,##0.00" /></td>
                                <td>
                                    <% if (book instanceof EBook) { %>
                                        <span class="badge bg-success">Unlimited</span>
                                    <% } else { %>
                                        <% if (book.getQuantity() > 0) { %>
                                            <span class="badge bg-success"><%= book.getQuantity() %></span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Out of Stock</span>
                                        <% } %>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <a href="<%=request.getContextPath()%>/admin/update-book?id=<%= book.getId() %>" class="btn btn-outline-light">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger"
                                                onclick="confirmDelete('<%= book.getId() %>', '<%= book.getTitle() %>')">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                        <a href="<%=request.getContextPath()%>/book-details?id=<%= book.getId() %>" class="btn btn-outline-info">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer text-muted">
                Total Books: <%= books != null ? books.length : 0 %>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-light">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete the book: <span id="bookTitle" class="fw-bold"></span>?
                    <p class="text-danger mt-2">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" action="<%=request.getContextPath()%>/admin/delete-book" method="post">
                        <input type="hidden" id="bookId" name="bookId" value="">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

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
            const booksTable = $('#booksTable').DataTable({
                responsive: true,
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                language: {
                    search: "_INPUT_",
                    searchPlaceholder: "Search books..."
                }
            });

            // Custom search input styling
            $('.dataTables_filter input').addClass('form-control form-control-sm bg-secondary-dark');
            $('.dataTables_length select').addClass('form-control form-control-sm bg-secondary-dark');
        });

        // Delete confirmation
        function confirmDelete(bookId, bookTitle) {
            document.getElementById('bookId').value = bookId;
            document.getElementById('bookTitle').textContent = bookTitle;

            const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }

        // Filter books
        function filterBooks(filter) {
            const table = $('#booksTable').DataTable();

            table.search('').columns().search('').draw();

            if (filter === 'physical') {
                table.column(4).search('Physical').draw();
            } else if (filter === 'ebook') {
                table.column(4).search('E-Book').draw();
            } else if (filter === 'featured') {
                // Would need additional column for featured status
                table.search('Featured').draw();
            } else if (filter === 'out-of-stock') {
                table.column(6).search('Out of Stock').draw();
            }
            // 'all' doesn't need special handling, as we've already cleared all filters
        }
    </script>
</body>
</html>