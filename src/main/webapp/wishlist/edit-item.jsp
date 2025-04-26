<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.wishlist.Wishlist" %>
<%@ page import="com.bookstore.model.wishlist.WishlistItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Wishlist Item - BookVerse</title>
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

        .alert-custom {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
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

        .book-cover {
            height: 150px;
            object-fit: cover;
            border-radius: 4px;
        }

        .book-details {
            max-width: 500px;
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

        .priority-indicator {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }

        .priority-dot {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            margin-right: 5px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .priority-dot:hover {
            transform: scale(1.2);
        }

        .priority-dot.selected {
            transform: scale(1.3);
            box-shadow: 0 0 5px rgba(255, 255, 255, 0.5);
        }

        .priority-1 { background-color: #6c757d; }
        .priority-2 { background-color: #0d6efd; }
        .priority-3 { background-color: #198754; }
        .priority-4 { background-color: #fd7e14; }
        .priority-5 { background-color: #dc3545; }

        .priority-label {
            margin-left: 10px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <%
        // Access the data directly with scriptlets for debugging
        Book book = (Book) request.getAttribute("book");
        Wishlist wishlist = (Wishlist) request.getAttribute("wishlist");
        String notes = (String) request.getAttribute("notes");
        Integer priority = (Integer) request.getAttribute("priority");

        if (priority == null) priority = 3; // Default to medium if not set

        // Debug output
        System.out.println("JSP Debug - Book: " + (book != null ? book.getTitle() : "null"));
        System.out.println("JSP Debug - Wishlist: " + (wishlist != null ? wishlist.getName() : "null"));
        System.out.println("JSP Debug - Notes: " + notes);
        System.out.println("JSP Debug - Priority: " + priority);
    %>

    <!-- Include Header -->
    <jsp:include page="../includes/header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Home</a></li>
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/wishlists">My Wishlists</a></li>
                <li class="breadcrumb-item">
                    <a href="<%=request.getContextPath()%>/wishlists?action=view&id=<%=wishlist != null ? wishlist.getWishlistId() : ""%>">
                        <%=wishlist != null ? wishlist.getName() : "Wishlist"%>
                    </a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Edit Item</li>
            </ol>
        </nav>

        <h2 class="mb-4"><i class="fas fa-edit me-2"></i> Edit Wishlist Item</h2>

        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <% if (book == null || wishlist == null) { %>
            <div class="alert alert-custom alert-danger mb-4">
                <i class="fas fa-exclamation-circle me-2"></i>
                Book or wishlist information is missing. Please go back and try again.
            </div>
            <div class="text-center mt-4">
                <a href="<%=request.getContextPath()%>/wishlists" class="btn btn-outline-light">
                    <i class="fas fa-arrow-left me-2"></i> Back to Wishlists
                </a>
            </div>
        <% } else { %>
            <!-- Book Information -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <img src="<%=request.getContextPath()%>/book-covers/<%=book.getCoverImagePath()%>"
                             alt="<%=book.getTitle()%>" class="book-cover me-4">
                        <div class="book-details">
                            <h3><%=book.getTitle()%></h3>
                            <p class="text-muted">by <%=book.getAuthor()%></p>
                            <div class="d-flex align-items-center mb-2">
                                <div class="rating me-2">
                                    <%
                                        double rating = book.getAverageRating();
                                        for (int i = 1; i <= 5; i++) {
                                            if (i <= rating) {
                                    %>
                                        <i class="fas fa-star" style="color: gold;"></i>
                                    <% } else if (i <= rating + 0.5) { %>
                                        <i class="fas fa-star-half-alt" style="color: gold;"></i>
                                    <% } else { %>
                                        <i class="far fa-star" style="color: gold;"></i>
                                    <% } } %>
                                </div>
                                <span class="text-muted">(<%=book.getAverageRating()%>)</span>
                            </div>
                            <p class="price" style="color: var(--accent-color); font-weight: bold;">$<%=book.getPrice()%></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Edit Wishlist Item Form -->
            <div class="card">
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/wishlist-item" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="wishlistId" value="<%=wishlist.getWishlistId()%>">
                        <input type="hidden" name="bookId" value="<%=book.getId()%>">

                        <div class="mb-3">
                            <label for="notes" class="form-label">Notes</label>
                            <textarea class="form-control" id="notes" name="notes" rows="4"
                                     placeholder="Add personal notes about this book"><%=notes != null ? notes : ""%></textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Priority</label>
                            <div class="d-flex flex-column">
                                <div class="priority-indicator">
                                    <div class="d-flex">
                                        <div class="priority-dot priority-1"
                                             onclick="selectPriority(1)"
                                             id="priority-dot-1"></div>
                                        <div class="priority-dot priority-2"
                                             onclick="selectPriority(2)"
                                             id="priority-dot-2"></div>
                                        <div class="priority-dot priority-3"
                                             onclick="selectPriority(3)"
                                             id="priority-dot-3"></div>
                                        <div class="priority-dot priority-4"
                                             onclick="selectPriority(4)"
                                             id="priority-dot-4"></div>
                                        <div class="priority-dot priority-5"
                                             onclick="selectPriority(5)"
                                             id="priority-dot-5"></div>
                                    </div>
                                    <div class="priority-label" id="priority-label">
                                        <%
                                        String priorityLabel = "Medium";
                                        switch (priority) {
                                            case 1: priorityLabel = "Very Low"; break;
                                            case 2: priorityLabel = "Low"; break;
                                            case 3: priorityLabel = "Medium"; break;
                                            case 4: priorityLabel = "High"; break;
                                            case 5: priorityLabel = "Very High"; break;
                                        }
                                        %>
                                        <%=priorityLabel%>
                                    </div>
                                </div>
                                <input type="hidden" id="priority" name="priority" value="<%=priority%>">
                            </div>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="<%=request.getContextPath()%>/wishlists?action=view&id=<%=wishlist.getWishlistId()%>" class="btn btn-outline-light">
                                <i class="fas fa-arrow-left me-2"></i> Cancel
                            </a>
                            <div>
                                <a href="<%=request.getContextPath()%>/wishlist-item?action=remove&wishlistId=<%=wishlist.getWishlistId()%>&bookId=<%=book.getId()%>"
                                   class="btn btn-outline-danger me-2">
                                    <i class="fas fa-trash-alt me-2"></i> Remove from Wishlist
                                </a>
                                <button type="submit" class="btn btn-accent">
                                    <i class="fas fa-save me-2"></i> Save Changes
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../includes/footer.jsp" />

    <!-- Script for priority selection -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set initial priority
            const initialPriority = <%=priority%>;
            selectPriority(initialPriority);
        });

        function selectPriority(priority) {
            // Update hidden input
            document.getElementById('priority').value = priority;

            // Remove selected class from all dots
            for (let i = 1; i <= 5; i++) {
                document.getElementById('priority-dot-' + i).classList.remove('selected');
            }

            // Add selected class to clicked dot
            document.getElementById('priority-dot-' + priority).classList.add('selected');

            // Update label
            const labelText = getPriorityText(priority);
            document.getElementById('priority-label').textContent = labelText;
        }

        function getPriorityText(priority) {
            switch (priority) {
                case 1: return 'Very Low';
                case 2: return 'Low';
                case 3: return 'Medium';
                case 4: return 'High';
                case 5: return 'Very High';
                default: return 'Medium';
            }
        }
    </script>
</body>
</html>