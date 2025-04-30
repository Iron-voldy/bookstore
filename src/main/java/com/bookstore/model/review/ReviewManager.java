package com.bookstore.model.review;

import java.io.*;
import java.util.*;
import javax.servlet.ServletContext;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.order.Order;
import com.bookstore.model.order.OrderManager;
import com.bookstore.model.order.OrderItem;
import com.bookstore.util.ValidationUtil;

/**
 * Manages review-related operations for the bookstore
 */
public class ReviewManager {
    private static final String REVIEWS_FILE_NAME = "book_reviews.txt";
    private List<Review> reviews;
    private ServletContext servletContext;
    private String dataFilePath;
    private BookManager bookManager;
    private OrderManager orderManager;

    // Constructors
    public ReviewManager() {
        this(null);
    }

    public ReviewManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        this.reviews = new ArrayList<>();
        this.bookManager = new BookManager(servletContext);
        this.orderManager = new OrderManager(servletContext);
        initializeFilePath();
        loadReviews();
    }

    // Initialize file path
    private void initializeFilePath() {
        if (servletContext != null) {
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + REVIEWS_FILE_NAME;

            // Ensure directory exists
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + REVIEWS_FILE_NAME;

            // Ensure directory exists
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("ReviewManager: Using data file path: " + dataFilePath);
    }

    // Load reviews from file
    private void loadReviews() {
        File file = new File(dataFilePath);

        // Create file if it doesn't exist
        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created reviews file: " + dataFilePath);
            } catch (IOException e) {
                System.err.println("Error creating reviews file: " + e.getMessage());
                e.printStackTrace();
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;

                Review review = Review.fromFileString(line);
                if (review != null) {
                    reviews.add(review);
                }
            }
            System.out.println("Total reviews loaded: " + reviews.size());
        } catch (IOException e) {
            System.err.println("Error loading reviews: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Save reviews to file
    private boolean saveReviews() {
        try {
            File file = new File(dataFilePath);

            // Ensure parent directory exists
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                boolean created = file.getParentFile().mkdirs();
                System.out.println("Created directory: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Review review : reviews) {
                    writer.write(review.toFileString());
                    writer.newLine();
                }
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error saving reviews: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Add a review for a standard user
    public Review addStandardReview(String userId, String userName, String bookId,
                                    String comment, int rating) {
        // Validate inputs
        if (ValidationUtil.isNullOrEmpty(bookId) || ValidationUtil.isNullOrEmpty(comment)) {
            return null;
        }

        // Check if user has already reviewed this book
        if (hasUserReviewedBook(userId, bookId)) {
            return null;
        }

        // Create review
        Review review = new Review(
                UUID.randomUUID().toString(),
                bookId,
                userId,
                userName,
                comment,
                rating,
                ReviewType.STANDARD
        );

        // Add to reviews and save
        reviews.add(review);
        saveReviews();

        // Update book rating
        updateBookRating(bookId);

        return review;
    }

    // Add a verified review (from a purchased book)
    public Review addVerifiedReview(String userId, String userName, String bookId,
                                    String comment, int rating) {
        // Validate inputs
        if (ValidationUtil.isNullOrEmpty(bookId) || ValidationUtil.isNullOrEmpty(comment)) {
            return null;
        }

        // Check if user has purchased the book
        boolean hasPurchased = checkVerifiedPurchase(userId, bookId);
        if (!hasPurchased) {
            return null;
        }

        // Check if user has already reviewed this book
        if (hasUserReviewedBook(userId, bookId)) {
            return null;
        }

        // Create review
        Review review = new Review(
                UUID.randomUUID().toString(),
                bookId,
                userId,
                userName,
                comment,
                rating,
                ReviewType.VERIFIED
        );

        // Add to reviews and save
        reviews.add(review);
        saveReviews();

        // Update book rating
        updateBookRating(bookId);

        return review;
    }

    // Add a guest review
    public Review addGuestReview(String guestName, String bookId,
                                 String comment, int rating) {
        // Validate inputs
        if (ValidationUtil.isNullOrEmpty(bookId) ||
                ValidationUtil.isNullOrEmpty(comment) ||
                ValidationUtil.isNullOrEmpty(guestName)) {
            return null;
        }

        // Create review
        Review review = new Review(
                UUID.randomUUID().toString(),
                bookId,
                null,
                guestName,
                comment,
                rating,
                ReviewType.GUEST
        );

        // Add to reviews and save
        reviews.add(review);
        saveReviews();

        // Update book rating
        updateBookRating(bookId);

        return review;
    }

    // Update an existing review
    public boolean updateReview(String reviewId, String userId,
                                String comment, int rating) {
        for (Review review : reviews) {
            if (review.getReviewId().equals(reviewId)) {
                // Validate user permission
                if (userId != null && !userId.equals(review.getUserId())) {
                    return false;
                }

                // Update review details
                review.setComment(comment);
                review.setRating(rating);

                // Save changes
                saveReviews();

                // Update book rating
                updateBookRating(review.getBookId());

                return true;
            }
        }
        return false;
    }

    // Delete a review
    public boolean deleteReview(String reviewId, String userId) {
        Iterator<Review> iterator = reviews.iterator();
        while (iterator.hasNext()) {
            Review review = iterator.next();
            if (review.getReviewId().equals(reviewId)) {
                // Validate user permission
                if (userId != null && !userId.equals(review.getUserId())) {
                    return false;
                }

                // Store book ID before removing
                String bookId = review.getBookId();

                // Remove review
                iterator.remove();
                saveReviews();

                // Update book rating
                updateBookRating(bookId);

                return true;
            }
        }
        return false;
    }

    // Get reviews for a specific book
    public List<Review> getBookReviews(String bookId) {
        List<Review> bookReviews = new ArrayList<>();
        for (Review review : reviews) {
            if (review.getBookId().equals(bookId)) {
                bookReviews.add(review);
            }
        }

        // Sort by date, newest first
        bookReviews.sort((r1, r2) -> r2.getReviewDate().compareTo(r1.getReviewDate()));
        return bookReviews;
    }
    // Get reviews by a specific user
    public List<Review> getUserReviews(String userId) {
        List<Review> userReviews = new ArrayList<>();
        for (Review review : reviews) {
            if (userId.equals(review.getUserId())) {
                userReviews.add(review);
            }
        }

        // Sort by date, newest first
        userReviews.sort((r1, r2) -> r2.getReviewDate().compareTo(r1.getReviewDate()));
        return userReviews;
    }

    // Check if a user has already reviewed a book
    public boolean hasUserReviewedBook(String userId, String bookId) {
        if (userId == null) return false;

        for (Review review : reviews) {
            if (review.getBookId().equals(bookId) &&
                    userId.equals(review.getUserId())) {
                return true;
            }
        }
        return false;
    }

    // Verify if a user has purchased the book
    private boolean checkVerifiedPurchase(String userId, String bookId) {
        // Get user's order history
        List<Order> userOrders = orderManager.getOrdersByUser(userId);

        for (Order order : userOrders) {
            for (OrderItem item : order.getItems()) {
                if (item.getBookId().equals(bookId)) {
                    return true;
                }
            }
        }
        return false;
    }

    // Calculate and update book rating
    private void updateBookRating(String bookId) {
        List<Review> bookReviews = getBookReviews(bookId);

        if (bookReviews.isEmpty()) {
            return;
        }

        // Calculate average rating
        double totalRating = 0;
        for (Review review : bookReviews) {
            totalRating += review.getRating();
        }
        double averageRating = totalRating / bookReviews.size();

        // Round to one decimal place
        averageRating = Math.round(averageRating * 10.0) / 10.0;

        // Update book rating
        Book book = bookManager.getBookById(bookId);
        if (book != null) {
            book.setAverageRating(averageRating);
            book.setNumberOfRatings(bookReviews.size());
            bookManager.updateBook(book);
        }
    }

    // Get review statistics for a book
    public Map<String, Object> getReviewStatistics(String bookId) {
        List<Review> bookReviews = getBookReviews(bookId);

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalReviews", bookReviews.size());

        // Rating distribution
        Map<Integer, Integer> ratingDistribution = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            ratingDistribution.put(i, 0);
        }

        for (Review review : bookReviews) {
            int rating = review.getRating();
            ratingDistribution.put(rating, ratingDistribution.get(rating) + 1);
        }

        stats.put("ratingDistribution", ratingDistribution);

        // Verified and guest review counts
        int verifiedReviews = 0;
        int guestReviews = 0;

        for (Review review : bookReviews) {
            if (review.getReviewType() == ReviewType.VERIFIED) {
                verifiedReviews++;
            } else if (review.getReviewType() == ReviewType.GUEST) {
                guestReviews++;
            }
        }

        stats.put("verifiedReviews", verifiedReviews);
        stats.put("guestReviews", guestReviews);

        return stats;
    }

    // Get a specific review by its ID
    public Review getReviewById(String reviewId) {
        for (Review review : reviews) {
            if (review.getReviewId().equals(reviewId)) {
                return review;
            }
        }
        return null;
    }
}