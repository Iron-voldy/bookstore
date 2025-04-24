<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${wishlist.name} - BookVerse</title>
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
        }

        .book-card {
            transition: transform 0.3s;
        }

        .book-card:hover {
            transform: translateY(-5px);
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

        .book-cover {
            height: 200px;
            object-fit: cover;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
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

        .priority-badge {
            font-size: 0.8rem;
            padding: 3px 8px;
            border-radius: 4px;
        }

        .priority-1 { background-color: #6c757d; }
        .priority-2 { background-color: #0d6efd; }
        .priority-3 { background-color: #198754; }
        .priority-4 { background-color: #fd7e14; }
        .priority-5 { background-color: #dc3545; }

        .rating i {
            color: gold;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../includes/header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/wishlists">My Wishlists</a></li>
                <li class="breadcrumb-item active" aria-current="page">${wishlist.name}</li>
            </ol>
        </nav>

        <!-- Wishlist Header -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h2 class="mb-2">${wishlist.name}</h2>
                        <p class="text-muted mb-2">
                            <c:choose>
                                <c:when test="${not empty wishlist.description}">
                                    ${wishlist.description}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">No description</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <p class="mb-0">
                            <small class="text-muted">
                                <i class="fas fa-calendar-alt me-1"></i> Created:
                                <fmt:formatDate value="${wishlist.createdDate}" pattern="MMMM d, yyyy" />
                            </small>
                        </p>
                        <p class="mb-0">
                            <c:choose>
                                <c:when test="${wishlist.public}">
                                    <span class="badge badge-public"><i class="fas fa-globe me-1"></i> Public</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-private"><i class="fas fa-lock me-1"></i> Private</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/wishlists?action=edit&id=${wishlist.wishlistId}" class="btn btn-outline-light me-2">
                            <i class="fas fa-edit me-1"></i> Edit
                        </a>
                        <button type="button" class="btn btn-outline-danger"
                                data-bs-toggle="modal" data-bs-target="#deleteWishlistModal">
                            <i class="fas fa-trash-alt me-1"></i> Delete
                        </button>
                    </div>
                </div>
            </div>
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

        <!-- Wishlist Items -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3><i class="fas fa-book me-2"></i> Items (${wishlist.itemCount})</h3>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-accent">
                <i class="fas fa-plus me-2"></i> Add More Books
            </a>
        </div>

        <c:choose>
            <c:when test="${empty wishlistItems}">
                <div class="card">
                    <div class="card-body empty-state">
                        <i class="fas fa-book-open"></i>
                        <h4>No Books in Wishlist</h4>
                        <p>Your wishlist is empty. Add books to your wishlist while browsing the store.</p>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-accent mt-3">
                            <i class="fas fa-search me-2"></i> Browse Books
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <c:forEach var="entry" items="${wishlistItems}">
                        <c:set var="item" value="${entry.key}" />
                        <c:set var="book" value="${entry.value}" />
                        <div class="col">
                            <div class="card book-card">
                                <c:choose>
                                    <c:when test="${not empty book.coverImagePath}">
                                        <img src="${pageContext.request.contextPath}/book-covers/${book.coverImagePath}" class="book-cover" alt="${book.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/book-covers/default_cover.jpg" class="book-cover" alt="${book.title}">
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="card-title">${book.title}</h5>
                                        <c:choose>
                                            <c:when test="${item.priority == 5}">
                                                <span class="badge priority-badge priority-5">Very High</span>
                                            </c:when>
                                            <c:when test="${item.priority == 4}">
                                                <span class="badge priority-badge priority-4">High</span>
                                            </c:when>
                                            <c:when test="${item.priority == 3}">
                                                <span class="badge priority-badge priority-3">Medium</span>
                                            </c:when>
                                            <c:when test="${item.priority == 2}">
                                                <span class="badge priority-badge priority-2">Low</span>
                                            </c:when>
                                            <c:when test="${item.priority == 1}">
                                                <span class="badge priority-badge priority-1">Very Low</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                    <p class="card-text text-muted small">by ${book.author}</p>

                                    <div class="rating small mb-2">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= book.averageRating}">
                                                    <i class="fas fa-star"></i>
                                                </c:when>
                                                <c:when test="${i <= book.averageRating + 0.5}">
                                                    <i class="fas fa-star-half-alt"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="far fa-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <span class="ms-1">(${book.averageRating})</span>
                                    </div>

                                    <p class="card-text fw-bold" style="color: var(--accent-color);">$${book.price}</p>

                                    <c:if test="${not empty item.notes}">
                                        <div class="notes mt-2 small">
                                            <strong>Notes:</strong> ${item.notes}
                                        </div>
                                    </c:if>
                                </div>
                                <div class="card-footer d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/book-details?id=${book.id}" class="btn btn-outline-light btn-sm">
                                        <i class="fas fa-eye me-1"></i> Details
                                    </a>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/wishlist-item?action=edit&wishlistId=${wishlist.wishlistId}&bookId=${book.id}" class="btn btn-outline-light btn-sm">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/wishlist-item?action=remove&wishlistId=${wishlist.wishlistId}&bookId=${book.id}" class="btn btn-outline-danger btn-sm">
                                            <i class="fas fa-times"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteWishlistModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-light">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the wishlist "${wishlist.name}"?</p>
                    <p class="text-danger">This action cannot be undone and all items in this wishlist will be removed.</p>
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

    <!-- Include Footer -->
    <jsp:include page="../includes/footer.jsp" />

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>