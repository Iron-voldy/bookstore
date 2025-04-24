package com.bookstore.model.wishlist;

import java.util.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents a user's wishlist
 */
public class Wishlist {
    private String wishlistId;
    private String userId;
    private String name;
    private String description;
    private Date createdDate;
    private List<WishlistItem> items;
    private boolean isPublic;

    /**
     * Default constructor
     */
    public Wishlist() {
        this.createdDate = new Date();
        this.items = new ArrayList<>();
        this.isPublic = false;
    }

    /**
     * Constructor with essential fields
     */
    public Wishlist(String wishlistId, String userId, String name) {
        this.wishlistId = wishlistId;
        this.userId = userId;
        this.name = name;
        this.createdDate = new Date();
        this.items = new ArrayList<>();
        this.isPublic = false;
    }

    /**
     * Full constructor
     */
    public Wishlist(String wishlistId, String userId, String name, String description, Date createdDate, boolean isPublic) {
        this.wishlistId = wishlistId;
        this.userId = userId;
        this.name = name;
        this.description = description;
        this.createdDate = createdDate;
        this.items = new ArrayList<>();
        this.isPublic = isPublic;
    }

    // Getters and Setters
    public String getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(String wishlistId) {
        this.wishlistId = wishlistId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public List<WishlistItem> getItems() {
        return items;
    }

    public void setItems(List<WishlistItem> items) {
        this.items = items;
    }

    public boolean isPublic() {
        return isPublic;
    }

    public void setPublic(boolean isPublic) {
        this.isPublic = isPublic;
    }

    /**
     * Get the number of items in this wishlist
     * @return the number of items
     */
    public int getItemCount() {
        return items != null ? items.size() : 0;
    }

    /**
     * Add an item to this wishlist
     * @param item the item to add
     * @return true if the item was added, false if it already exists
     */
    public boolean addItem(WishlistItem item) {
        // Initialize items list if null
        if (items == null) {
            items = new ArrayList<>();
        }

        // Check if the book is already in the wishlist
        for (WishlistItem existingItem : items) {
            if (existingItem.getBookId().equals(item.getBookId())) {
                return false; // Book already in wishlist
            }
        }

        items.add(item);
        return true;
    }

    /**
     * Remove an item from this wishlist
     * @param bookId the ID of the book to remove
     * @return true if the item was removed, false if it wasn't found
     */
    public boolean removeItem(String bookId) {
        if (items == null) {
            return false;
        }
        return items.removeIf(item -> item.getBookId().equals(bookId));
    }

    /**
     * Check if a book is in this wishlist
     * @param bookId the ID of the book to check
     * @return true if the book is in the wishlist
     */
    public boolean containsBook(String bookId) {
        if (items == null) {
            return false;
        }
        for (WishlistItem item : items) {
            if (item.getBookId().equals(bookId)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Convert wishlist to string representation for file storage
     */
    public String toFileString() {
        return wishlistId + "," +
                userId + "," +
                name + "," +
                (description != null ? description.replace(",", "{{COMMA}}") : "") + "," +
                createdDate.getTime() + "," +
                isPublic;
    }

    /**
     * Parse wishlist from file string
     */
    public static Wishlist fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 6) {
            Wishlist wishlist = new Wishlist();
            wishlist.setWishlistId(parts[0]);
            wishlist.setUserId(parts[1]);
            wishlist.setName(parts[2]);
            wishlist.setDescription(parts[3].replace("{{COMMA}}", ","));
            wishlist.setCreatedDate(new Date(Long.parseLong(parts[4])));
            wishlist.setPublic(Boolean.parseBoolean(parts[5]));
            return wishlist;
        }
        return null;
    }

    @Override
    public String toString() {
        return "Wishlist{" +
                "wishlistId='" + wishlistId + '\'' +
                ", userId='" + userId + '\'' +
                ", name='" + name + '\'' +
                ", itemCount=" + getItemCount() +
                ", isPublic=" + isPublic +
                '}';
    }
}