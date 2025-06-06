<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.BookManager" %>
<%@ page import="com.bookstore.model.user.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <%
        // Get book ID from request parameter
        String bookId = request.getParameter("bookId");

        // If no book ID, redirect
        if (bookId == null || bookId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Fetch book details
        BookManager bookManager = new BookManager(getServletContext());
        Book book = bookManager.getBookById(bookId);

        // If book not found, redirect
        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Set book as request attribute for use in the page
        request.setAttribute("book", book);
    %>

    <title>Write a Review for <%= book.getTitle() %> - BookVerse</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f4f4;
        }
        .review-container {
            max-width: 600px;
            margin: 50px auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .star-rating {
            unicode-bidi: bidi-override;
            direction: rtl;
            text-align: left;
        }
        .star-rating > label {
            display: inline-block;
            position: relative;
            width: 1.1em;
            font-size: 2.5rem;
            color: #ccc;
            cursor: pointer;
        }
        .star-rating > label:hover,
        .star-rating > label:hover ~ label,
        .star-rating > input:checked ~ label {
            color: #ffca08;
        }
        .star-rating > input {
            position: absolute;
            left: -999999px;
        }
        .book-info {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
        }
        .book-cover {
            max-width: 100px;
            max-height: 150px;
            margin-right: 20px;
            object-fit: cover;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="review-container">
            <!-- Book Information -->
            <div class="book-info">
                <img src="<%= request.getContextPath() %>/book-covers/<%= book.getCoverImagePath() %>"
                     alt="<%= book.getTitle() %> Cover" class="book-cover">
                <div>
                    <h4><%= book.getTitle() %></h4>
                    <p class="text-muted">by <%= book.getAuthor() %></p>
                </div>
            </div>

            <%-- Error Message --%>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${errorMessage}" />
                </div>
            </c:if>

            <form action="<%= request.getContextPath() %>/add-book-review" method="post">
                <input type="hidden" name="bookId" value="<%= book.getId() %>">

                <%-- Star Rating --%>
                <div class="mb-3">
                    <label class="form-label">Your Rating</label>
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5" required />
                        <label for="star5">★</label>
                        <input type="radio" id="star4" name="rating" value="4" />
                        <label for="star4">★</label>
                        <input type="radio" id="star3" name="rating" value="3" />
                        <label for="star3">★</label>
                        <input type="radio" id="star2" name="rating" value="2" />
                        <label for="star2">★</label>
                        <input type="radio" id="star1" name="rating" value="1" />
                        <label for="star1">★</label>
                    </div>
                </div>

                <%-- Guest Review Name Field --%>
                <%
                    User user = (User) session.getAttribute("user");
                    if (user == null) {
                %>
                    <div class="mb-3">
                        <label for="guestName" class="form-label">Your Name</label>
                        <input type="text" class="form-control" id="guestName" name="guestName" required>
                    </div>
                <% } %>

                <%-- Review Comment --%>
                <div class="mb-3">
                    <label for="comment" class="form-label">Your Review</label>
                    <textarea class="form-control" id="comment" name="comment" rows="4" required
                              placeholder="Share your thoughts about this book"></textarea>
                </div>

                <%-- Submit Button --%>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Submit Review</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>