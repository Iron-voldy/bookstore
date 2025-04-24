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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous">
    <!-- Custom CSS -->
    <style>
        body {
            background-color: #121212;
            color: #f5f5f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar {
            background-color: #1e1e1e;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }
        .navbar-brand {
            color: #8a5cf5 !important;
        }
        .btn-accent {
            background-color: #8a5cf5;
            color: white;
            border: none;
        }
        .btn-accent:hover {
            background-color: #6e46c9;
        }
        .card {
            background-color: #252525;
            border: 1px solid #333333;
            border-radius: 8px;
        }
        .empty-state {
            text-align: center;
            padding: 40px 20px;
        }
        .badge-public {
            background-color: #8a5cf5;
        }
        .badge-private {
            background-color: #1e1e1e;
            border: 1px solid #333333;
        }
        .alert-custom {
            background-color: #1e1e1e;
            color: #f5f5f5;
            border: 1px solid #333333;
        }
        .alert-success {
            border-left: 4px solid #4caf50;
        }
        .alert-danger {
            border-left: 4px solid #d64045;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../includes/header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
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
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h5 class="card-title">${wishlist.name}</h5>
                                        <c:choose>
                                            <c:when test="${wishlist.isPublic}">
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
                                                No description
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
                                        <i class="fas fa-book me-1"></i> ${wishlist.itemCount} items
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
                                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal${wishlist.wishlistId}">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <!-- Delete Confirmation Modal -->
                            <div class="modal fade" id="deleteModal${wishlist.wishlistId}" tabindex="-1" aria-hidden="true">
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
</body>
</html>