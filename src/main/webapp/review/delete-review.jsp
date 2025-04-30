<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.review.Review" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.BookManager" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Review - Confirmation</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f4f4;
        }
        .confirmation-container {
            max-width: 600px;
            margin: 100px auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        .warning-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .action-buttons {
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <%
        // Get review and book details
        Review review = (Review)request.getAttribute("review");
        String bookId = (String)request.getAttribute("bookId");

        // Fetch book details to show context
        BookManager bookManager = new BookManager(getServletContext());
        Book book = bookManager.getBookById(bookId);
    %>

    <div class="container">
        <div class="confirmation-container">
            <i class="bi bi-exclamation-triangle-fill warning-icon"></i>
            <h2 class="mb-3">Delete Review Confirmation</h2>

            <% if (book != null) { %>
                <p class="lead">Are you sure you want to delete your review for "<%= book.getTitle() %>"?</p>
            <% } else { %>
                <p class="lead">Are you sure you want to delete this review?</p>
            <% } %>

            <p class="text-muted">This action cannot be undone.</p>

            <div class="action-buttons">
                <form action="<%= request.getContextPath() %>/delete-book-review" method="post">
                    <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                    <input type="hidden" name="confirm" value="yes">

                    <a href="<%= request.getContextPath() %>/book-reviews?bookId=<%= bookId %>" class="btn btn-secondary btn-lg me-2">
                        <i class="bi bi-x-circle"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-danger btn-lg">
                        <i class="bi bi-trash"></i> Yes, Delete
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>