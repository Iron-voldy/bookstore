package com.bookstore.model.review;

import java.util.Date;

/**
 * Represents a book review with core attributes and behaviors
 */
public class Review {
    private String reviewId;
    private String bookId;
    private String userId;  // null for guest reviews
    private String userName;
    private String comment;
    private int rating;     // 1-5 star rating
    private Date reviewDate;
    private ReviewType reviewType;

    // Constructors
    public Review() {
        this.reviewId = "";
        this.bookId = "";
        this.userId = null;
        this.userName = "";
        this.comment = "";
        this.rating = 0;
        this.reviewDate = new Date();
        this.reviewType = ReviewType.STANDARD;
    }

    public Review(String reviewId, String bookId, String userId, String userName,
                  String comment, int rating, ReviewType reviewType) {
        this.reviewId = reviewId;
        this.bookId = bookId;
        this.userId = userId;
        this.userName = userName;
        this.comment = comment;
        this.rating = validateRating(rating);
        this.reviewDate = new Date();
        this.reviewType = reviewType;
    }

    // Getters and Setters
    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = validateRating(rating);
    }

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    public ReviewType getReviewType() {
        return reviewType;
    }

    public void setReviewType(ReviewType reviewType) {
        this.reviewType = reviewType;
    }

    // Validation method for rating
    private int validateRating(int rating) {
        return Math.max(1, Math.min(5, rating));
    }

    // Convert review to file string for persistence
    public String toFileString() {
        return String.format("%s,%s,%s,%s,%s,%d,%d,%s",
                reviewId,
                bookId,
                userId != null ? userId : "null",
                userName.replace(",", "{{COMMA}}"),
                comment.replace(",", "{{COMMA}}"),
                rating,
                reviewDate.getTime(),
                reviewType.name()
        );
    }

    // Create review from file string
    public static Review fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 8) {
            Review review = new Review();
            review.setReviewId(parts[0]);
            review.setBookId(parts[1]);
            review.setUserId("null".equals(parts[2]) ? null : parts[2]);
            review.setUserName(parts[3].replace("{{COMMA}}", ","));
            review.setComment(parts[4].replace("{{COMMA}}", ","));
            review.setRating(Integer.parseInt(parts[5]));
            review.setReviewDate(new Date(Long.parseLong(parts[6])));
            review.setReviewType(ReviewType.valueOf(parts[7]));
            return review;
        }
        return null;
    }

    @Override
    public String toString() {
        return "Review{" +
                "reviewId='" + reviewId + '\'' +
                ", bookId='" + bookId + '\'' +
                ", userName='" + userName + '\'' +
                ", rating=" + rating +
                ", reviewType=" + reviewType +
                '}';
    }
}