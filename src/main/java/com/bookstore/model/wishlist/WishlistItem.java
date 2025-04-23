package com.bookstore.model.wishlist;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
        this.priority = priority;
        this.addedDate = addedDate;
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
        // Ensure priority is between 1 and 5
        if (priority < 1) {
            this.priority = 1;
        } else if (priority > 5) {
            this.priority = 5;
        } else {
            this.priority = priority;
        }
    }

    public Date getAddedDate() {
        return addedDate;
    }

    public void setAddedDate(Date addedDate) {
        this.addedDate = addedDate;
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

