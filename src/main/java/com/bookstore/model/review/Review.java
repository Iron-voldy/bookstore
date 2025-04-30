package com.bookstore.model.review;

import java.util.Date;

/**
 * Model class for book reviews
 */
public class Review {

    /**
     * Review types enum
     */
    public enum ReviewType {
        GUEST("Guest Review"),
        STANDARD("User Review"),
        VERIFIED_PURCHASE("Verified Purchase");

        private final String displayName;

        ReviewType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    private String reviewId;
    private String userId;
    private String userName;
    private String bookId;
    private String comment;
    private int rating;
    private Date reviewDate;
    private ReviewType reviewType;

    /**
     * Default constructor
     */
    public Review() {
        this.reviewDate = new Date();
        this.reviewType = ReviewType.STANDARD;
    }

    /**
     * Constructor with all fields
     */
    public Review(String reviewId, String userId, String userName, String bookId,
                  String comment, int rating, Date reviewDate, ReviewType reviewType) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.userName = userName;
        this.bookId = bookId;
        this.comment = comment;
        this.rating = rating;
        this.reviewDate = reviewDate;
        this.reviewType = reviewType;
    }

    // Getters and Setters
    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
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

    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
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
        // Validate rating between 1-5
        if (rating < 1) rating = 1;
        if (rating > 5) rating = 5;
        this.rating = rating;
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

    /**
     * Convert to string representation for file storage
     */
    public String toFileString() {
        StringBuilder sb = new StringBuilder();
        sb.append(reviewId).append(",");
        sb.append(userId).append(",");
        sb.append(userName.replace(",", "{{COMMA}}")).append(",");
        sb.append(bookId).append(",");
        sb.append(comment.replace(",", "{{COMMA}}").replace("\n", "{{NEWLINE}}")).append(",");
        sb.append(rating).append(",");
        sb.append(reviewDate.getTime()).append(",");
        sb.append(reviewType.name());
        return sb.toString();
    }

    /**
     * Create from string representation (from file)
     */
    public static Review fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 8) {
            try {
                Review review = new Review();
                review.setReviewId(parts[0]);
                review.setUserId(parts[1]);
                review.setUserName(parts[2].replace("{{COMMA}}", ","));
                review.setBookId(parts[3]);
                review.setComment(parts[4].replace("{{COMMA}}", ",").replace("{{NEWLINE}}", "\n"));
                review.setRating(Integer.parseInt(parts[5]));
                review.setReviewDate(new Date(Long.parseLong(parts[6])));
                review.setReviewType(ReviewType.valueOf(parts[7]));
                return review;
            } catch (Exception e) {
                System.err.println("Error parsing review from file: " + e.getMessage());
                e.printStackTrace();
                return null;
            }
        }
        return null;
    }

    @Override
    public String toString() {
        return "Review{" +
                "reviewId='" + reviewId + '\'' +
                ", userId='" + userId + '\'' +
                ", userName='" + userName + '\'' +
                ", bookId='" + bookId + '\'' +
                ", rating=" + rating +
                ", reviewDate=" + reviewDate +
                ", reviewType=" + reviewType +
                '}';
    }
}