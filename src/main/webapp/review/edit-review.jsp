<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.review.Review" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Review - ${book.title}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">

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
        }
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 25px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="review-container">
            <h2 class="mb-4">Edit Your Review</h2>

            <!-- Book Info -->
            <div class="book-info">
                <h4>${book.title}</h4>
                <p class="text-muted">by ${book.author}</p>
            </div>

            <%-- Error Message --%>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${errorMessage}
                </div>
            </c:if>

            <form action="<%=request.getContextPath()%>/update-book-review" method="post">
                <input type="hidden" name="reviewId" value="${review.reviewId}">

                <%-- Star Rating --%>
                <div class="mb-3">
                    <label class="form-label">Your Rating</label>
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5"
                               <%= ((Review)request.getAttribute("review")).getRating() == 5 ? "checked" : "" %> />
                        <label for="star5">★</label>
                        <input type="radio" id="star4" name="rating" value="4"
                               <%= ((Review)request.getAttribute("review")).getRating() == 4 ? "checked" : "" %> />
                        <label for="star4">★</label>
                        <input type="radio" id="star3" name="rating" value="3"
                               <%= ((Review)request.getAttribute("review")).getRating() == 3 ? "checked" : "" %> />
                        <label for="star3">★</label>
                        <input type="radio" id="star2" name="rating" value="2"
                               <%= ((Review)request.getAttribute("review")).getRating() == 2 ? "checked" : "" %> />
                        <label for="star2">★</label>
                        <input type="radio" id="star1" name="rating" value="1"
                               <%= ((Review)request.getAttribute("review")).getRating() == 1 ? "checked" : "" %> />
                        <label for="star1">★</label>
                    </div>
                </div>

                <%-- Review Comment --%>
                <div class="mb-3">
                    <label for="comment" class="form-label">Your Review</label>
                    <textarea class="form-control" id="comment" name="comment" rows="4" required
                              placeholder="Share your thoughts about this book">${review.comment}</textarea>
                </div>

                <%-- Action Buttons --%>
                <div class="action-buttons">
                    <a href="<%=request.getContextPath()%>/book-reviews?bookId=${book.id}" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Cancel
                    </a>
                    <div>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> Update Review
                        </button>
                        <a href="<%=request.getContextPath()%>/delete-book-review?reviewId=${review.reviewId}"
                           class="btn btn-danger ms-2"
                           onclick="return confirm('Are you sure you want to delete this review? This action cannot be undone.');">
                            <i class="bi bi-trash"></i> Delete
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>