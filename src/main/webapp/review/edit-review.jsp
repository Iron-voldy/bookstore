<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.review.Review" %>

                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5"
                               <%= ((Review)request.getAttribute("review")).getRating() == 5 ? "checked" : "" %> required />
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

                <%-- Submit Button --%>
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">Update Review</button>
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteReviewModal">
                        Delete Review
                    </button>
                </div>
            </form>

            <!-- Delete Review Modal -->
            <div class="modal fade" id="deleteReviewModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Confirm Review Deletion</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete this review? This action cannot be undone.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <form action="${pageContext.request.contextPath}/delete-book-review" method="post" class="d-inline">
                                <input type="hidden" name="reviewId" value="${review.reviewId}">
                                <input type="hidden" name="confirm" value="yes">
                                <button type="submit" class="btn btn-danger">Delete Review</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Additional Review Information Section --%>
            <div class="mt-4 text-muted small">
                <p>
                    <strong>Submitted:</strong> ${review.reviewDate}<br>
                    <strong>Review Type:</strong> ${review.reviewType.displayName}
                </p>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>