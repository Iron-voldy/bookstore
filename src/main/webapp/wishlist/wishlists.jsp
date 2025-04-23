<!-- File: src/main/webapp/wishlist/create-wishlist.jsp (continued) -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Wishlist - BookVerse</title>
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

        .form-check-input {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
        }

        .form-check-input:checked {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
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
    <!-- Include Header -->
    <jsp:include page="../includes/header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/wishlists">My Wishlists</a></li>
                <li class="breadcrumb-item active" aria-current="page">Create Wishlist</li>
            </ol>
        </nav>

        <h2 class="mb-4"><i class="fas fa-plus-circle me-2"></i> Create New Wishlist</h2>

        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Create Wishlist Form -->
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/wishlists" method="post">
                    <input type="hidden" name="action" value="create">

                    <div class="mb-3">
                        <label for="name" class="form-label">Wishlist Name*</label>
                        <input type="text" class="form-control" id="name" name="name" required
                               placeholder="Enter a name for your wishlist" maxlength="100">
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3"
                                  placeholder="Add a description (optional)" maxlength="500"></textarea>
                    </div>

                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="isPublic" name="isPublic">
                            <label class="form-check-label" for="isPublic">
                                Make this wishlist public
                            </label>
                            <div class="form-text text-muted">
                                Public wishlists can be viewed by anyone with the link.
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/wishlists" class="btn btn-outline-light">
                            <i class="fas fa-arrow-left me-2"></i> Back to Wishlists
                        </a>
                        <button type="submit" class="btn btn-accent">
                            <i class="fas fa-save me-2"></i> Create Wishlist
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../includes/footer.jsp" />
</body>
</html>


<!-- File: src/main/webapp/wishlist/edit-wishlist.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Wishlist - BookVerse</title>
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

        .form-check-input {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
        }

        .form-check-input:checked {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
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
    <!-- Include Header -->
    <jsp:include page="../includes/header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/wishlists">My Wishlists</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/wishlists?action=view&id=${wishlist.wishlistId}">${wishlist.name}</a></li>
                <li class="breadcrumb-item active" aria-current="page">Edit</li>
            </ol>
        </nav>

        <h2 class="mb-4"><i class="fas fa-edit me-2"></i> Edit Wishlist</h2>

        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Edit Wishlist Form -->
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/wishlists" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="wishlistId" value="${wishlist.wishlistId}">

                    <div class="mb-3">
                        <label for="name" class="form-label">Wishlist Name*</label>
                        <input type="text" class="form-control" id="name" name="name" required
                               value="${wishlist.name}" maxlength="100">
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3"
                                  maxlength="500">${wishlist.description}</textarea>
                    </div>

                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="isPublic" name="isPublic"
                                   <c:if test="${wishlist.public}">checked</c:if>>
                            <label class="form-check-label" for="isPublic">
                                Make this wishlist public
                            </label>
                            <div class="form-text text-muted">
                                Public wishlists can be viewed by anyone with the link.
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/wishlists?action=view&id=${wishlist.wishlistId}" class="btn btn-outline-light">
                            <i class="fas fa-arrow-left me-2"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-accent">
                            <i class="fas fa-save me-2"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../includes/footer.jsp" />
</body>
</html>


<!-- File: src/main/webapp/wishlist/select-wishlist.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add to Wishlist - BookVerse</title>
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

        .wishlist-option {
            display: block;
            width: 100%;
            text-align: left;
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            transition: all 0.3s;
        }

        .wishlist-option:hover {
            background-color: rgba(138, 92, 245, 0.1);
            border-color: var(--accent-color);
            transform: translateY(-2px);
        }

        .wishlist-option.selected {
            background-color: rgba(138, 92, 245, 0.2);
            border-color: var(--accent-color);
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
    <!-- Include Header -->
    <jsp:include page="../includes/header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/books">Books</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/book-details?id=${book.id}">${book.title}</a></li>
                <li class="breadcrumb-item active" aria-current="page">Add to Wishlist</li>
            </ol>
        </nav>

        <h2 class="mb-4"><i class="fas fa-heart me-2"></i> Add to Wishlist</h2>

        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Book Information -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <img src="${pageContext.request.contextPath}/book-covers/${book.coverImagePath}"
                         alt="${book.title}" class="book-cover me-4">
                    <div class="book-details">
                        <h3>${book.title}</h3>
                        <p class="text-muted">by ${book.author}</p>
                        <div class="d-flex align-items-center mb-2">
                            <div class="rating me-2">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= book.averageRating}">
                                            <i class="fas fa-star" style="color: gold;"></i>
                                        </c:when>
                                        <c:when test="${i <= book.averageRating + 0.5}">
                                            <i class="fas fa-star-half-alt" style="color: gold;"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star" style="color: gold;"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <span class="text-muted">(${book.averageRating})</span>
                        </div>
                        <p class="price" style="color: var(--accent-color); font-weight: bold;">$${book.price}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Select Wishlist Form -->
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/wishlist-item" method="post">
                    <input type="hidden" name="action" value="add-to-selected">
                    <input type="hidden" name="bookId" value="${book.id}">

                    <div class="mb-4">
                        <h5 class="mb-3">Select a Wishlist</h5>

                        <c:choose>
                            <c:when test="${empty wishlists}">
                                <p>You don't have any wishlists yet. Create one first.</p>
                                <a href="${pageContext.request.contextPath}/wishlists?action=create" class="btn btn-accent">
                                    <i class="fas fa-plus me-2"></i> Create Wishlist
                                </a>
                            </c:when>
                            <c:otherwise>
                                <div class="mb-3">
                                    <c:forEach var="wishlist" items="${wishlists}">
                                        <div class="form-check mb-2">
                                            <input class="form-check-input visually-hidden" type="radio"
                                                   name="wishlistId" id="wishlist-${wishlist.wishlistId}"
                                                   value="${wishlist.wishlistId}" required>
                                            <label class="wishlist-option" for="wishlist-${wishlist.wishlistId}">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <h6 class="mb-1">${wishlist.name}</h6>
                                                        <c:if test="${not empty wishlist.description}">
                                                            <p class="text-muted small mb-0">${wishlist.description}</p>
                                                        </c:if>
                                                    </div>
                                                    <span class="badge bg-accent">${wishlist.itemCount} items</span>
                                                </div>
                                            </label>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="mb-3">
                                    <a href="${pageContext.request.contextPath}/wishlists?action=create" class="btn btn-sm btn-outline-light">
                                        <i class="fas fa-plus me-1"></i> Create New Wishlist
                                    </a>
                                </div>

                                <hr class="my-4">

                                <h5 class="mb-3">Add Notes (Optional)</h5>
                                <div class="mb-3">
                                    <textarea class="form-control" id="notes" name="notes" rows="3"
                                              placeholder="Add personal notes about this book"></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="priority" class="form-label">Priority</label>
                                    <select class="form-select" id="priority" name="priority">
                                        <option value="1">Very Low (1)</option>
                                        <option value="2">Low (2)</option>
                                        <option value="3" selected>Medium (3)</option>
                                        <option value="4">High (4)</option>
                                        <option value="5">Very High (5)</option>
                                    </select>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/book-details?id=${book.id}" class="btn btn-outline-light">
                                        <i class="fas fa-arrow-left me-2"></i> Cancel
                                    </a>
                                    <button type="submit" class="btn btn-accent">
                                        <i class="fas fa-heart me-2"></i> Add to Wishlist
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../includes/footer.jsp" />

    <!-- Script for wishlist selection -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const wishlistOptions = document.querySelectorAll('.wishlist-option');

            wishlistOptions.forEach(option => {
                option.addEventListener('click', function() {
                    // Remove selected class from all options
                    wishlistOptions.forEach(o => o.classList.remove('selected'));

                    // Add selected class to clicked option
                    this.classList.add('selected');
                });
            });
        });
    </script>
</body>
</html>