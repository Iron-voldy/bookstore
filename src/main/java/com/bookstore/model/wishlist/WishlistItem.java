package com.bookstore.model.wishlist;

import java.util.Date;

/**
 * Represents an item in a wishlist
 */
public class WishlistItem {
    private String wishlistId;
    private String bookId;
    private String notes;
    private int priority; // 1-5, where 5 is highest priority
    private Date addedDate;

    /**
     * Default constructor
     */
    public WishlistItem() {
        this.addedDate = new Date();
        this.priority = 3; // Default medium priority
    }

    /**
     * Constructor with essential fields
     */
    public WishlistItem(String wishlistId, String bookId) {
        this.wishlistId = wishlistId;
        this.bookId = bookId;
        this.addedDate = new Date();
        this.priority = 3; // Default medium priority
    }

    /**
     * Full constructor
     */
    public WishlistItem(String wishlistId, String bookId, String notes, int priority, Date addedDate) {
        this.wishlistId = wishlistId;
        this.bookId = bookId;
        this.notes = notes;
        this.priority = validatePriority(priority);
        this.addedDate = addedDate != null ? addedDate : new Date();
    }

    // Getters and Setters
    public String getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(String wishlistId) {
        this.wishlistId = wishlistId;
    }

    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = validatePriority(priority);
    }

    public Date getAddedDate() {
        return addedDate;
    }

    public void setAddedDate(Date addedDate) {
        this.addedDate = addedDate;
    }

    /**
     * Validate priority is between 1 and 5
     * @param priority the priority level to validate
     * @return a valid priority level (between 1 and 5)
     */
    private int validatePriority(int priority) {
        if (priority < 1) {
            return 1;
        } else if (priority > 5) {
            return 5;
        }
        return priority;
    }

    /**
     * Get priority label based on priority value
     * @return String representation of priority
     */
    public String getPriorityLabel() {
        switch(priority) {
            case 1: return "Very Low";
            case 2: return "Low";
            case 3: return "Medium";
            case 4: return "High";
            case 5: return "Very High";
            default: return "Medium";
        }
    }

    /**
     * Convert wishlist item to string representation for file storage
     */
    public String toFileString() {
        return wishlistId + "," +
                bookId + "," +
                (notes != null ? notes.replace(",", "{{COMMA}}") : "") + "," +
                priority + "," +
                addedDate.getTime();
    }

    /**
     * Parse wishlist item from file string
     */
    public static WishlistItem fromFileString(String fileString) {
        try {
            String[] parts = fileString.split(",");
            if (parts.length >= 5) {
                WishlistItem item = new WishlistItem();
                item.setWishlistId(parts[0]);
                item.setBookId(parts[1]);
                item.setNotes(parts[2].replace("{{COMMA}}", ","));
                item.setPriority(Integer.parseInt(parts[3]));
                item.setAddedDate(new Date(Long.parseLong(parts[4])));
                return item;
            }
        } catch (Exception e) {
            System.err.println("Error parsing wishlist item: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public String toString() {
        return "WishlistItem{" +
                "wishlistId='" + wishlistId + '\'' +
                ", bookId='" + bookId + '\'' +
                ", priority=" + priority +
                '}';
    }
}