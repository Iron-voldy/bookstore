package com.bookstore.model.order;

/**
 * Represents an item within an order
 */
public class OrderItem {
    private String bookId;
    private String title;
    private String author;
    private double price;
    private double discountedPrice;
    private int quantity;
    private String bookType; // "PHYSICAL" or "EBOOK"

    /**
     * Constructor with all fields
     */
    public OrderItem(String bookId, String title, String author, double price,
                     double discountedPrice, int quantity, String bookType) {
        this.bookId = bookId;
        this.title = title;
        this.author = author;
        this.price = price;
        this.discountedPrice = discountedPrice;
        this.quantity = quantity;
        this.bookType = bookType;
    }

    /**
     * Default constructor
     */
    public OrderItem() {
    }

    // Getters and Setters
    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscountedPrice() {
        return discountedPrice;
    }

    public void setDiscountedPrice(double discountedPrice) {
        this.discountedPrice = discountedPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getBookType() {
        return bookType;
    }

    public void setBookType(String bookType) {
        this.bookType = bookType;
    }

    /**
     * Calculate the subtotal for this item
     */
    public double getSubtotal() {
        return discountedPrice * quantity;
    }

    /**
     * Convert item to string representation for storage
     */
    public String toFileString() {
        return bookId + "," +
                title.replace(",", "{{COMMA}}") + "," +
                author.replace(",", "{{COMMA}}") + "," +
                price + "," +
                discountedPrice + "," +
                quantity + "," +
                (bookType != null ? bookType : "");
    }

    /**
     * Create item from string representation
     */
    public static OrderItem fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 7) {
            OrderItem item = new OrderItem();
            item.setBookId(parts[0]);
            item.setTitle(parts[1].replace("{{COMMA}}", ","));
            item.setAuthor(parts[2].replace("{{COMMA}}", ","));
            item.setPrice(Double.parseDouble(parts[3]));
            item.setDiscountedPrice(Double.parseDouble(parts[4]));
            item.setQuantity(Integer.parseInt(parts[5]));
            item.setBookType(parts[6]);
            return item;
        }
        return null;
    }

    @Override
    public String toString() {
        return "OrderItem{" +
                "bookId='" + bookId + '\'' +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", price=" + price +
                ", discountedPrice=" + discountedPrice +
                ", quantity=" + quantity +
                ", bookType='" + bookType + '\'' +
                '}';
    }
}