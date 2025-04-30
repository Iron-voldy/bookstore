<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.review.Review" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reviews - BookVerse</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">

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

        .container {
            padding-top: 30px;
            padding-bottom: 50px;
        }

        .page-title {
            margin-bottom: 30px;
            display: flex;
            align-items: center;
        }

        .page-title i {
            color: var(--accent-color);
            margin-right: 10px;
            font-size: 1.8rem;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            margin-bottom: 20px;
            overflow: hidden;
        }

        .card-header {
            background-color: rgba(138, 92, 245, 0.1);
            border-bottom: 1px solid var(--border-color);
            padding: 15px 20px;
        }

        .review-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            margin-bottom: 20px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        .review-header {
            background-color: rgba(138, 92, 245, 0.1);
            border-bottom: 1px solid var(--border-color);
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .review-book-info {
            display: flex;
            align-items: center;
        }

        .book-image {
            width: 50px;
            height: 75px;
            background-color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            margin-right: 15px;
            color: #666;
        }

        .book-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 2px;
        }

        .book-author {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .review-content {
            padding: 20px;
        }

        .review-text {
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .review-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--border-color);
        }

        .review-date {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .review-stars {
            color: gold;
        }

        .verified-badge {
            display: inline-block;
            margin-left: 10px;
            font-size: 0.8rem;
            padding: 2px 8px;
            border-radius: 10px;
            background: linear-gradient(to right, var(--accent-color), #af71ff);
            color: white;
        }

        .review-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
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

        .btn-danger {
            background-color: var(--danger-color);
            border: none;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c03a3f;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(214, 64, 69, 0.3);
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        .btn-outline:hover {
            border-color: var(--accent-color);
            color: var(--accent-color);
        }

        .no-reviews {
            text-align: center;
            padding: 50px 20px;
        }

        .no-reviews i {
            font-size: 3rem;
            color: #444;
            display: block;
            margin-bottom: 20px;
        }

        .alert {
            border-radius: 10px;
            background-color: var(--card-bg);
        }

        .alert-success {
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            border-left: 4px solid var(--danger-color);
        }
    </style>
</head>
<body>
    <!-- Header/Navbar goes here -->
    <!-- Using a placeholder, replace with your actual navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/">BookVerse</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <!-- Your navigation links -->
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Page Title -->
        <div class="page-title">
            <i class="bi bi-star"></i>
            <h2>My Book Reviews</h2>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success mb-4">
                <i class="bi bi-check-circle me-2"></i> ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger mb-4">
                <i class="bi bi-exclamation-triangle me-2"></i> ${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <!-- Reviews List -->
        <c:choose>
            <c:when test="${empty userReviews}">
                <div class="no-reviews">
                    <i class="bi bi-journal-text"></i>
                    <h4>You haven't written any reviews yet</h4>
                    <p class="text-muted mb-4">Your book reviews will appear here once you've shared your thoughts.</p>
                    <a href="<%=request.getContextPath()%>/books" class="btn btn-accent">Browse Books</a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${userReviews}">
                    <div class="review-card">
                        <div class="review-header">
                            <div class="review-book-info">
                                <div class="book-image">
                                    <i class="bi bi-book"></i>
                                </div>
                                <div>
                                    <h5 class="book-title">${bookMap[review.bookId].title}</h5>
                                    <p class="book-author">by ${bookMap[review.bookId].author}</p>
                                </div>
                            </div>
                            <c:if test="${review.reviewType.name() == 'VERIFIED'}">
                                <span class="verified-badge">
                                    <i class="bi bi-patch-check-fill me-1"></i> Verified Purchase
                                </span>
                            </c:if>
                        </div>
                        <div class="review-content">
                            <div class="review-meta">
                                <div class="review-date">
                                    <fmt:formatDate value="${review.reviewDate}" pattern="MMMM dd, yyyy"/>
                                </div>
                                <div class="review-stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= review.rating}">
                                                <i class="bi bi-star-fill"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="review-text">
                                ${review.comment}
                            </div>
                            <div class="review-actions">
                                <a href="<%=request.getContextPath()%>/book-reviews?bookId=${review.bookId}"
                                   class="btn btn-outline btn-sm">
                                    <i class="bi bi-eye me-1"></i> View All Book Reviews
                                </a>
                                <a href="<%=request.getContextPath()%>/update-book-review?reviewId=${review.reviewId}"
                                   class="btn btn-accent btn-sm">
                                    <i class="bi bi-pencil me-1"></i> Edit
                                </a>
                                <a href="<%=request.getContextPath()%>/delete-book-review?reviewId=${review.reviewId}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Are you sure you want to delete this review?');">
                                    <i class="bi bi-trash me-1"></i> Delete
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>