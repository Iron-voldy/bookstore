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
    <title>Reviews - ${book.title}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f4f4;
        }
        .book-header {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .review-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .star-rating {
            color: #ffc107;
        }
        .rating-bar {
            height: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            margin-bottom: 5px;
        }
        .rating-bar-fill {
            background-color: #ffc107;
            height: 100%;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <%-- Book Header --%>
        <div class="book-header mb-4">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <img src="<%=request.getContextPath()%>/book-covers/${book.coverImagePath}"
                         alt="${book.title}" class="img-fluid" style="max-height: 250px;">
                </div>
                <div class="col-md-9">
                    <h1>${book.title}</h1>
                    <p class="text-muted">by ${book.author}</p>

                    <%-- Overall Rating --%>
                    <div class="d-flex align-items-center">
                        <div class="star-rating me-2">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= book.averageRating}">
                                        <i class="bi bi-star-fill"></i>
                                    </c:when>
                                    <c:when test="${i - 0.5 <= book.averageRating}">
                                        <i class="bi bi-star-half"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-star"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <span>${book.averageRating} / 5.0</span>
                    </div>
                    <p class="text-muted">${reviewStats.totalReviews} total reviews</p>

                    <%-- Add Review Button --%>
                    <a href="<%=request.getContextPath()%>/add-book-review?bookId=${book.id}"
                       class="btn btn-primary mt-2">
                        <i class="bi bi-pencil-fill me-2"></i>Write a Review
                    </a>
                </div>
            </div>
        </div>

        <%-- Rating Distribution --%>
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">Rating Breakdown</div>
                    <div class="card-body">
                        <c:forEach begin="1" end="5" var="rating" varStatus="status">
                            <div class="d-flex align-items-center mb-2">
                                <div class="me-2">${rating} Star</div>
                                <div class="rating-bar flex-grow-1">
                                    <div class="rating-bar-fill"
                                         style="width: ${(reviewStats.ratingDistribution[rating] * 100) / reviewStats.totalReviews}%"></div>
                                </div>
                                <div class="ms-2">${reviewStats.ratingDistribution[rating]}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <%-- Reviews List --%>
            <div class="col-md-8">
                <h3>Customer Reviews</h3>

                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="alert alert-info">
                            No reviews yet. Be the first to review this book!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-card">
                                <div class="d-flex justify-content-between mb-3">
                                    <div>
                                        <strong>${review.userName}</strong>
                                        <span class="text-muted ms-2">
                                            <fmt:formatDate value="${review.reviewDate}" pattern="MMMM dd, yyyy"/>
                                        </span>
                                    </div>
                                    <div class="star-rating">
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
                                <p>${review.comment}</p>

                                <%-- Show edit/delete for user's own review --%>
                                <c:if test="${sessionScope.userId eq review.userId}">
                                    <div class="review-actions mt-2">
                                        <a href="<%=request.getContextPath()%>/update-book-review?reviewId=${review.reviewId}"
                                           class="btn btn-sm btn-outline-primary me-2">
                                            <i class="bi bi-pencil me-1"></i>Edit
                                        </a>
                                        <form action="<%=request.getContextPath()%>/delete-book-review"
                                              method="post" class="d-inline"
                                              onsubmit="return confirm('Are you sure you want to delete this review?');">
                                            <input type="hidden" name="reviewId" value="${review.reviewId}">
                                            <input type="hidden" name="confirm" value="yes">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash me-1"></i>Delete
                                            </button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>