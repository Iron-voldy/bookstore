<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.review.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        // Get book from request
        Book book = (Book)request.getAttribute("book");
        List<Review> reviews = (List<Review>)request.getAttribute("reviews");
        Map<String, Object> reviewStats = (Map<String, Object>)request.getAttribute("reviewStats");

        // Ensure book is not null
        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
    %>
    <title>Reviews - <%= book.getTitle() %></title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary-dark: #121212;
            --secondary-dark: #1e1e1e;
            --accent-color: #8a5cf5;
            --text-primary: #f5f5f5;
            --text-secondary: #b0b0b0;
            --border-color: #333333;
            --card-bg: #252525;
        }

        body {
            background-color: var(--primary-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .book-header {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .book-cover {
            max-height: 250px;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.2);
        }

        .rating-stars {
            color: gold;
        }

        .review-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            margin-bottom: 15px;
            padding: 20px;
        }

        .rating-bar {
            background-color: #333;
            height: 10px;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        .rating-bar-fill {
            background-color: gold;
            height: 100%;
            border-radius: 5px;
        }

        .btn-accent {
            background-color: var(--accent-color);
            color: white;
            border: none;
        }

        .btn-accent:hover {
            background-color: #7a46c9;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <!-- Book Header -->
        <div class="book-header mb-4">
            <div class="row">
                <div class="col-md-3 text-center">
                    <img src="<%= request.getContextPath() %>/book-covers/<%= book.getCoverImagePath() %>"
                         alt="<%= book.getTitle() %>" class="book-cover img-fluid">
                </div>
                <div class="col-md-9">
                    <h1><%= book.getTitle() %></h1>
                    <p class="text-muted">by <%= book.getAuthor() %></p>

                    <!-- Overall Rating -->
                    <div class="d-flex align-items-center mb-3">
                        <div class="rating-stars me-2">
                            <%
                                double rating = book.getAverageRating();
                                for (int i = 1; i <= 5; i++) {
                                    if (i <= rating) {
                            %>
                                <i class="bi bi-star-fill"></i>
                            <% } else if (i - 0.5 <= rating) { %>
                                <i class="bi bi-star-half"></i>
                            <% } else { %>
                                <i class="bi bi-star"></i>
                            <% } } %>
                        </div>
                        <span><%= String.format("%.1f", book.getAverageRating()) %> / 5.0</span>
                        <span class="text-muted ms-2">
                            (<%= book.getNumberOfRatings() %> total reviews)
                        </span>
                    </div>

                    <!-- Write Review Button -->
                    <a href="<%= request.getContextPath() %>/add-book-review?bookId=<%= book.getId() %>"
                       class="btn btn-accent">
                        <i class="bi bi-pencil-fill me-2"></i>Write a Review
                    </a>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Rating Breakdown -->
            <div class="col-md-4 mb-4">
                <div class="card" style="background-color: var(--card-bg); border-color: var(--border-color);">
                    <div class="card-header" style="background-color: rgba(138, 92, 245, 0.1);">
                        Rating Breakdown
                    </div>
                    <div class="card-body">
                        <%
                            Map<Integer, Integer> ratingDistribution =
                                (Map<Integer, Integer>)reviewStats.get("ratingDistribution");
                            int totalReviews = (int)reviewStats.get("totalReviews");

                            for (int star = 5; star >= 1; star--) {
                                int count = ratingDistribution.getOrDefault(star, 0);
                                double percentage = totalReviews > 0 ?
                                    (count * 100.0 / totalReviews) : 0;
                        %>
                            <div class="d-flex align-items-center mb-2">
                                <div class="me-2"><%= star %> Star</div>
                                <div class="rating-bar flex-grow-1">
                                    <div class="rating-bar-fill"
                                         style="width: <%= percentage %>%"></div>
                                </div>
                                <div class="ms-2"><%= count %></div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Reviews List -->
            <div class="col-md-8">
                <h3 class="mb-4">Customer Reviews</h3>

                <% if (reviews == null || reviews.isEmpty()) { %>
                    <div class="alert alert-info">
                        No reviews yet. Be the first to review this book!
                    </div>
                <% } else {
                    for (Review review : reviews) {
                %>
                    <div class="review-card">
                        <div class="d-flex justify-content-between mb-3">
                            <div>
                                <strong><%= review.getUserName() %></strong>
                                <span class="text-muted ms-2">
                                    <fmt:formatDate value="<%= review.getReviewDate() %>" pattern="MMMM dd, yyyy"/>
                                </span>
                            </div>
                            <div class="rating-stars">
                                <%
                                    int reviewRating = review.getRating();
                                    for (int i = 1; i <= 5; i++) {
                                        if (i <= reviewRating) {
                                %>
                                    <i class="bi bi-star-fill"></i>
                                <% } else { %>
                                    <i class="bi bi-star"></i>
                                <% } } %>
                            </div>
                        </div>
                        <p><%= review.getComment() %></p>

                        <%-- Show edit/delete for user's own review --%>
                        <%
                            String userId = (String)session.getAttribute("userId");
                            if (userId != null && userId.equals(review.getUserId())) {
                        %>
                            <div class="review-actions mt-2">
                                <a href="<%= request.getContextPath() %>/update-book-review?reviewId=<%= review.getReviewId() %>"
                                   class="btn btn-sm btn-outline-primary me-2">
                                    <i class="bi bi-pencil me-1"></i>Edit
                                </a>
                                <a href="<%= request.getContextPath() %>/delete-book-review?reviewId=<%= review.getReviewId() %>"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Are you sure you want to delete this review?');">
                                    <i class="bi bi-trash me-1"></i>Delete
                                </a>
                            </div>
                        <% } %>
                    </div>
                <% } } %>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>