<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlists - BookVerse</title>
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
            height: 100%;
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .wishlist-card {
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .wishlist-card .card-body {
            flex: 1;
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

        .empty-state {
            text-align: center;
            padding: 40px 20px;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 20px;
            color: var(--text-secondary);
        }

        .badge-public {
            background-color: var(--accent-color);
        }

        .badge-private {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
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
    </style>
</head>
<body>
    <!-- Debug Info - Remove in production -->
    <%
    System.out.println("wishlists.jsp: Processing page");
    if (request.getAttribute("wishlists") != null) {
        java.util.List<com.bookstore.model.wishlist.Wishlist> wishlists =
            (java.util.List<com.bookstore.model.wishlist.Wishlist>)request.getAttribute("wishlists");
        System.out.println("wishlists.jsp: Wishlists count = " + wishlists.size());
        for (com.bookstore.model.wishlist.Wishlist wishlist : wishlists) {
            System.out.println("wishlists.jsp: Wishlist name = " + wishlist.getName() + ", Items count = " + wishlist.getItemCount());
        }
    }
    %>

    <!-- Include Header -->
    <jsp:include page="../includes/header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item active" aria-current="page">My Wishlists</li>
            </ol>
        </nav>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-heart me-2"></i> My Wishlists</h2>
            <a href="${pageContext.request.contextPath}/wishlists?action=create" class="btn btn-accent">
                <i class="fas fa-plus me-2"></i> Create New Wishlist
            </a>
        </div>

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

        <!-- Wishlists Grid -->
        <c:choose>
            <c:when test="${empty wishlists}">
                <div class="card">
                    <div class="card-body empty-state">
                        <i class="fas fa-heart-broken"></i>
                        <h4>No Wishlists Yet</h4>
                        <p>You haven't created any wishlists yet. Start by creating your first wishlist!</p>
                        <a href="${pageContext.request.contextPath}/wishlists?action=create" class="btn btn-accent mt-3">
                            <i class="fas fa-plus me-2"></i> Create New Wishlist
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                    <c:forEach var="wishlist" items="${wishlists}">
                        <div class="col">
                            <div class="card wishlist-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h5 class="card-title">${wishlist.name}</h5>
                                        <c:choose>
                                            <c:when test="${wishlist.public}">
                                                <span class="badge badge-public">Public</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-private">Private</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="card-text text-muted">
                                        <c:choose>
                                            <c:when test="${not empty wishlist.description}">
                                                ${wishlist.description}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">No description</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p class="card-text">
                                        <small class="text-muted">
                                            <i class="fas fa-calendar-alt me-1"></i> Created:
                                            <fmt:formatDate value="${wishlist.createdDate}" pattern="MMM d, yyyy" />
                                        </small>
                                    </p>
                                    <p class="card-text">
                                        <i class="fas fa-book me-1"></i> ${wishlist.getItemCount()} items
                                    </p>
                                </div>
                                <div class="card-footer d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/wishlists?action=view&id=${wishlist.wishlistId}" class="btn btn-accent">
                                        <i class="fas fa-eye me-1"></i> View
                                    </a>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/wishlists?action=edit&id=${wishlist.wishlistId}" class="btn btn-outline-light">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger"
                                                data-bs-toggle="modal" data-bs-target="#deleteWishlistModal${wishlist.wishlistId}">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Delete Confirmation Modal -->
                            <div class="modal fade" id="deleteWishlistModal${wishlist.wishlistId}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content bg-dark text-light">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Confirm Deletion</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <p>Are you sure you want to delete the wishlist "${wishlist.name}"?</p>
                                            <p class="text-danger">This action cannot be undone.</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancel</button>
                                            <form action="${pageContext.request.contextPath}/wishlists" method="post">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="wishlistId" value="${wishlist.wishlistId}">
                                                <button type="submit" class="btn btn-danger">Delete</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../includes/footer.jsp" />
</body>
</html>