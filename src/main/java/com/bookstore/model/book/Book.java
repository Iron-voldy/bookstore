package com.bookstore.model.book;

import java.util.Date;
import java.util.UUID;

/**
 * Base Book class representing common book attributes and behaviors
 */
public class Book {
    private String id;
    private String title;
    private String author;
    private String isbn;
    private String publisher;
    private Date publicationDate;
    private String genre;
    private String description;
    private double price;
    private int quantity;
    private String coverImagePath;
    private double averageRating;
    private int numberOfRatings;
    private boolean featured;
    private Date addedDate;

    /**
     * Constructor with all fields
     */
    public Book(String id, String title, String author, String isbn, String publisher,
                Date publicationDate, String genre, String description, double price,
                int quantity, String coverImagePath, double averageRating,
                int numberOfRatings, boolean featured, Date addedDate) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.publisher = publisher;
        this.publicationDate = publicationDate;
        this.genre = genre;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
        this.coverImagePath = coverImagePath;
        this.averageRating = averageRating;
        this.numberOfRatings = numberOfRatings;
        this.featured = featured;
        this.addedDate = addedDate;
    }

    /**
     * Constructor with essential fields
     */
    public Book(String title, String author, String isbn, String publisher,
                Date publicationDate, String genre, String description, double price,
                int quantity) {
        this.id = UUID.randomUUID().toString();
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.publisher = publisher;
        this.publicationDate = publicationDate;
        this.genre = genre;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
        this.coverImagePath = "default_cover.jpg";
        this.averageRating = 0.0;
        this.numberOfRatings = 0;
        this.featured = false;
        this.addedDate = new Date();
    }

    /**
     * Default constructor
     */
    public Book() {
        this.id = UUID.randomUUID().toString();
        this.addedDate = new Date();
        this.averageRating = 0.0;
        this.numberOfRatings = 0;
        this.featured = false;
        this.coverImagePath = "default_cover.jpg";
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public Date getPublicationDate() {
        return publicationDate;
    }

    public void setPublicationDate(Date publicationDate) {
        this.publicationDate = publicationDate;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getCoverImagePath() {
        return coverImagePath;
    }

    public void setCoverImagePath(String coverImagePath) {
        this.coverImagePath = coverImagePath;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getNumberOfRatings() {
        return numberOfRatings;
    }

    public void setNumberOfRatings(int numberOfRatings) {
        this.numberOfRatings = numberOfRatings;
    }

    public boolean isFeatured() {
        return featured;
    }

    public void setFeatured(boolean featured) {
        this.featured = featured;
    }

    public Date getAddedDate() {
        return addedDate;
    }

    public void setAddedDate(Date addedDate) {
        this.addedDate = addedDate;
    }

    /**
     * Check if the book is in stock
     * @return true if quantity > 0
     */
    public boolean isInStock() {
        return quantity > 0;
    }

    /**
     * Add a new rating to the book
     * @param rating the rating to add (1-5)
     */
    public void addRating(int rating) {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }

        double totalRatingPoints = averageRating * numberOfRatings;
        numberOfRatings++;
        averageRating = (totalRatingPoints + rating) / numberOfRatings;
    }

    /**
     * Decrease the quantity by one (when a book is ordered)
     * @return true if successful, false if book is out of stock
     */
    public boolean decreaseQuantity() {
        if (quantity > 0) {
            quantity--;
            return true;
        }
        return false;
    }

    /**
     * Decrease the quantity by a specified amount
     * @param amount the amount to decrease
     * @return true if successful, false if not enough stock
     */
    public boolean decreaseQuantity(int amount) {
        if (quantity >= amount) {
            quantity -= amount;
            return true;
        }
        return false;
    }

    /**
     * Increase the quantity by one (when a book is restocked)
     */
    public void increaseQuantity() {
        quantity++;
    }

    /**
     * Increase the quantity by a specified amount
     * @param amount the amount to increase
     */
    public void increaseQuantity(int amount) {
        quantity += amount;
    }

    /**
     * Calculate discount price (to be overridden by subclasses)
     * @return the discounted price
     */
    public double getDiscountedPrice() {
        return price; // No discount by default
    }

    /**
     * Convert book to string representation for file storage
     * @return string representation
     */
    public String toFileString() {
        StringBuilder sb = new StringBuilder();
        sb.append("BOOK,");
        sb.append(id).append(",");
        sb.append(title).append(",");
        sb.append(author).append(",");
        sb.append(isbn).append(",");
        sb.append(publisher).append(",");
        sb.append(publicationDate != null ? publicationDate.getTime() : "0").append(",");
        sb.append(genre).append(",");
        // Replace any commas in description with a placeholder to avoid parsing issues
        sb.append(description != null ? description.replace(",", "{{COMMA}}") : "").append(",");
        sb.append(price).append(",");
        sb.append(quantity).append(",");
        sb.append(coverImagePath).append(",");
        sb.append(averageRating).append(",");
        sb.append(numberOfRatings).append(",");
        sb.append(featured).append(",");
        sb.append(addedDate != null ? addedDate.getTime() : "0");
        return sb.toString();
    }

    /**
     * Create book from string representation (from file)
     * @param fileString string representation
     * @return book object
     */
    public static Book fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 15 && parts[0].equals("BOOK")) {
            Book book = new Book();
            book.setId(parts[1]);
            book.setTitle(parts[2]);
            book.setAuthor(parts[3]);
            book.setIsbn(parts[4]);
            book.setPublisher(parts[5]);

            long pubDateLong = Long.parseLong(parts[6]);
            if (pubDateLong > 0) {
                book.setPublicationDate(new Date(pubDateLong));
            }

            book.setGenre(parts[7]);
            // Restore commas in description
            book.setDescription(parts[8].replace("{{COMMA}}", ","));
            book.setPrice(Double.parseDouble(parts[9]));
            book.setQuantity(Integer.parseInt(parts[10]));
            book.setCoverImagePath(parts[11]);
            book.setAverageRating(Double.parseDouble(parts[12]));
            book.setNumberOfRatings(Integer.parseInt(parts[13]));
            book.setFeatured(Boolean.parseBoolean(parts[14]));

            long addedDateLong = Long.parseLong(parts[15]);
            if (addedDateLong > 0) {
                book.setAddedDate(new Date(addedDateLong));
            }

            return book;
        }
        return null;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;

        Book book = (Book) obj;
        return id.equals(book.id);
    }

    @Override
    public int hashCode() {
        return id.hashCode();
    }

    @Override
    public String toString() {
        return "Book{" +
                "id='" + id + '\'' +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", isbn='" + isbn + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                '}';
    }
}