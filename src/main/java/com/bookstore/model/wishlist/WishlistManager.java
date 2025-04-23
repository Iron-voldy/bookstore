package com.bookstore.model.wishlist;

import java.io.*;
import java.util.*;
import javax.servlet.ServletContext;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;

/**
 * Manager class for handling wishlists
 */
public class WishlistManager {
    private static final String WISHLIST_FILE = "wishlists.txt";
    private static final String WISHLIST_ITEMS_FILE = "wishlist_items.txt";

    private Map<String, Wishlist> wishlists;
    private Map<String, List<WishlistItem>> wishlistItems;
    private ServletContext servletContext;
    private String wishlistFilePath;
    private String wishlistItemsFilePath;
    private BookManager bookManager;

    /**
     * Constructor
     */
    public WishlistManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        this.wishlists = new HashMap<>();
        this.wishlistItems = new HashMap<>();
        this.bookManager = new BookManager(servletContext);
        initializeFilePaths();
        loadWishlists();
        loadWishlistItems();
    }

    /**
     * Initialize file paths
     */
    private void initializeFilePaths() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String dataPath = "/WEB-INF/data";
            wishlistFilePath = servletContext.getRealPath(dataPath) + File.separator + WISHLIST_FILE;
            wishlistItemsFilePath = servletContext.getRealPath(dataPath) + File.separator + WISHLIST_ITEMS_FILE;

            // Create directory if it doesn't exist
            File dataDir = new File(servletContext.getRealPath(dataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback for non-web applications
            String dataPath = "data";
            wishlistFilePath = dataPath + File.separator + WISHLIST_FILE;
            wishlistItemsFilePath = dataPath + File.separator + WISHLIST_ITEMS_FILE;

            // Create directory if it doesn't exist
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("Wishlist file path: " + wishlistFilePath);
        System.out.println("Wishlist items file path: " + wishlistItemsFilePath);
    }

    /**
     * Load wishlists from file
     */
    private void loadWishlists() {
        File file = new File(wishlistFilePath);

        // Create the file if it doesn't exist
        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created wishlists file: " + wishlistFilePath);
                return;
            } catch (IOException e) {
                System.err.println("Error creating wishlists file: " + e.getMessage());
                e.printStackTrace();
                return;
            }
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;

                Wishlist wishlist = Wishlist.fromFileString(line);
                if (wishlist != null) {
                    wishlists.put(wishlist.getWishlistId(), wishlist);
                }
            }
            System.out.println("Loaded " + wishlists.size() + " wishlists");
        } catch (IOException e) {
            System.err.println("Error loading wishlists: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Load wishlist items from file
     */
    private void loadWishlistItems() {
        File file = new File(wishlistItemsFilePath);

        // Create the file if it doesn't exist
        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created wishlist items file: " + wishlistItemsFilePath);
                return;
            } catch (IOException e) {
                System.err.println("Error creating wishlist items file: " + e.getMessage());
                e.printStackTrace();
                return;
            }
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;

                WishlistItem item = WishlistItem.fromFileString(line);
                if (item != null) {
                    String wishlistId = item.getWishlistId();
                    if (!wishlistItems.containsKey(wishlistId)) {
                        wishlistItems.put(wishlistId, new ArrayList<>());
                    }
                    wishlistItems.get(wishlistId).add(item);

                    // Add item to the corresponding wishlist object
                    Wishlist wishlist = wishlists.get(wishlistId);
                    if (wishlist != null) {
                        wishlist.addItem(item);
                    }
                }
            }
            System.out.println("Loaded wishlist items for " + wishlistItems.size() + " wishlists");
        } catch (IOException e) {
            System.err.println("Error loading wishlist items: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Save wishlists to file
     */
    private boolean saveWishlists() {
        try {
            // Ensure directory exists
            File file = new File(wishlistFilePath);
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                boolean created = file.getParentFile().mkdirs();
                System.out.println("Created directory: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Wishlist wishlist : wishlists.values()) {
                    writer.write(wishlist.toFileString());
                    writer.newLine();
                }
            }

            System.out.println("Saved " + wishlists.size() + " wishlists");
            return true;
        } catch (IOException e) {
            System.err.println("Error saving wishlists: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Save wishlist items to file
     */
    private boolean saveWishlistItems() {
        try {
            // Ensure directory exists
            File file = new File(wishlistItemsFilePath);
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                boolean created = file.getParentFile().mkdirs();
                System.out.println("Created directory: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (List<WishlistItem> items : wishlistItems.values()) {
                    for (WishlistItem item : items) {
                        writer.write(item.toFileString());
                        writer.newLine();
                    }
                }
            }

            System.out.println("Saved wishlist items");
            return true;
        } catch (IOException e) {
            System.err.println("Error saving wishlist items: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Create a new wishlist
     * @param userId the user ID
     * @param name the name of the wishlist
     * @param description the description of the wishlist
     * @param isPublic whether the wishlist is public
     * @return the created wishlist ID, or null if creation failed
     */
    public String createWishlist(String userId, String name, String description, boolean isPublic) {
        // Generate wishlist ID
        String wishlistId = UUID.randomUUID().toString();

        // Create wishlist object
        Wishlist wishlist = new Wishlist(wishlistId, userId, name, description, new Date(), isPublic);

        // Add to map
        wishlists.put(wishlistId, wishlist);

        // Initialize items list
        wishlistItems.put(wishlistId, new ArrayList<>());

        // Save to file
        if (saveWishlists()) {
            return wishlistId;
        } else {
            // Remove from map if save failed
            wishlists.remove(wishlistId);
            wishlistItems.remove(wishlistId);
            return null;
        }
    }

    /**
     * Get a wishlist by ID
     * @param wishlistId the wishlist ID
     * @return the wishlist, or null if not found
     */
    public Wishlist getWishlist(String wishlistId) {
        return wishlists.get(wishlistId);
    }

    /**
     * Get all wishlists for a user
     * @param userId the user ID
     * @return list of wishlists belonging to the user
     */
    public List<Wishlist> getUserWishlists(String userId) {
        List<Wishlist> userWishlists = new ArrayList<>();
        for (Wishlist wishlist : wishlists.values()) {
            if (wishlist.getUserId().equals(userId)) {
                userWishlists.add(wishlist);
            }
        }
        return userWishlists;
    }

    /**
     * Get the default wishlist for a user, creating it if it doesn't exist
     * @param userId the user ID
     * @return the default wishlist
     */
    public Wishlist getDefaultWishlist(String userId) {
        // Look for existing default wishlist
        for (Wishlist wishlist : wishlists.values()) {
            if (wishlist.getUserId().equals(userId) && wishlist.getName().equals("My Wishlist")) {
                return wishlist;
            }
        }

        // Create default wishlist if none exists
        String wishlistId = createWishlist(userId, "My Wishlist", "Default wishlist", false);
        return wishlistId != null ? wishlists.get(wishlistId) : null;
    }

    /**
     * Update a wishlist
     * @param wishlist the updated wishlist
     * @return true if update was successful
     */
    public boolean updateWishlist(Wishlist wishlist) {
        if (!wishlists.containsKey(wishlist.getWishlistId())) {
            return false;
        }

        wishlists.put(wishlist.getWishlistId(), wishlist);
        return saveWishlists();
    }

    /**
     * Delete a wishlist
     * @param wishlistId the wishlist ID
     * @return true if deletion was successful
     */
    public boolean deleteWishlist(String wishlistId) {
        if (!wishlists.containsKey(wishlistId)) {
            return false;
        }

        // Remove items first
        List<WishlistItem> items = wishlistItems.remove(wishlistId);
        boolean itemsRemoved = items != null;

        // Remove wishlist
        wishlists.remove(wishlistId);

        // Save changes
        boolean wishlistsSaved = saveWishlists();
        boolean itemsSaved = itemsRemoved ? saveWishlistItems() : true;

        return wishlistsSaved && itemsSaved;
    }

    /**
     * Add a book to a wishlist
     * @param wishlistId the wishlist ID
     * @param bookId the book ID
     * @param notes user notes about the book
     * @param priority priority level (1-5)
     * @return true if the book was added successfully
     */
    public boolean addBookToWishlist(String wishlistId, String bookId, String notes, int priority) {
        Wishlist wishlist = wishlists.get(wishlistId);
        if (wishlist == null) {
            return false;
        }

        // Check if book exists
        Book book = bookManager.getBookById(bookId);
        if (book == null) {
            return false;
        }

        // Create wishlist item
        WishlistItem item = new WishlistItem(wishlistId, bookId, notes, priority, new Date());

        // Add to wishlist
        boolean added = wishlist.addItem(item);
        if (!added) {
            return false; // Book already in wishlist
        }

        // Add to map
        if (!wishlistItems.containsKey(wishlistId)) {
            wishlistItems.put(wishlistId, new ArrayList<>());
        }
        wishlistItems.get(wishlistId).add(item);

        // Save changes
        return saveWishlistItems();
    }

    /**
     * Remove a book from a wishlist
     * @param wishlistId the wishlist ID
     * @param bookId the book ID
     * @return true if the book was removed successfully
     */
    public boolean removeBookFromWishlist(String wishlistId, String bookId) {
        Wishlist wishlist = wishlists.get(wishlistId);
        if (wishlist == null) {
            return false;
        }

        // Remove from wishlist
        boolean removed = wishlist.removeItem(bookId);
        if (!removed) {
            return false; // Book not in wishlist
        }

        // Remove from map
        List<WishlistItem> items = wishlistItems.get(wishlistId);
        if (items != null) {
            items.removeIf(item -> item.getBookId().equals(bookId));
        }

        // Save changes
        return saveWishlistItems();
    }

    /**
     * Update notes and priority for a book in a wishlist
     * @param wishlistId the wishlist ID
     * @param bookId the book ID
     * @param notes updated notes
     * @param priority updated priority
     * @return true if the update was successful
     */
    public boolean updateWishlistItem(String wishlistId, String bookId, String notes, int priority) {
        List<WishlistItem> items = wishlistItems.get(wishlistId);
        if (items == null) {
            return false;
        }

        // Find the item
        for (WishlistItem item : items) {
            if (item.getBookId().equals(bookId)) {
                // Update the item
                item.setNotes(notes);
                item.setPriority(priority);

                // Save changes
                return saveWishlistItems();
            }
        }

        return false; // Item not found
    }

    /**
     * Get all items in a wishlist
     * @param wishlistId the wishlist ID
     * @return list of wishlist items
     */
    public List<WishlistItem> getWishlistItems(String wishlistId) {
        List<WishlistItem> items = wishlistItems.get(wishlistId);
        return items != null ? new ArrayList<>(items) : new ArrayList<>();
    }

    /**
     * Check if a book is in any of a user's wishlists
     * @param userId the user ID
     * @param bookId the book ID
     * @return true if the book is in any of the user's wishlists
     */
    public boolean isBookInUserWishlists(String userId, String bookId) {
        for (Wishlist wishlist : getUserWishlists(userId)) {
            if (wishlist.containsBook(bookId)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check if a book is in a specific wishlist
     * @param wishlistId the wishlist ID
     * @param bookId the book ID
     * @return true if the book is in the wishlist
     */
    public boolean isBookInWishlist(String wishlistId, String bookId) {
        Wishlist wishlist = wishlists.get(wishlistId);
        return wishlist != null && wishlist.containsBook(bookId);
    }

    /**
     * Get book-specific details for items in a wishlist
     * @param wishlistId the wishlist ID
     * @return map of wishlist items to their corresponding books
     */
    public Map<WishlistItem, Book> getWishlistItemsWithBooks(String wishlistId) {
        Map<WishlistItem, Book> result = new LinkedHashMap<>();
        List<WishlistItem> items = wishlistItems.get(wishlistId);

        if (items != null) {
            for (WishlistItem item : items) {
                Book book = bookManager.getBookById(item.getBookId());
                if (book != null) {
                    result.put(item, book);
                }
            }
        }

        return result;
    }

    /**
     * Get the count of all wishlists for a user
     * @param userId the user ID
     * @return the count of wishlists
     */
    public int getUserWishlistCount(String userId) {
        int count = 0;
        for (Wishlist wishlist : wishlists.values()) {
            if (wishlist.getUserId().equals(userId)) {
                count++;
            }
        }
        return count;
    }
}