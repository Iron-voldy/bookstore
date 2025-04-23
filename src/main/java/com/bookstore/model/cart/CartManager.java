package com.bookstore.model.cart;

import java.io.*;
import java.util.*;
import javax.servlet.ServletContext;
import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;

/**
 * CartManager handles all shopping cart operations including persistence
 */
public class CartManager {
    private static final String CART_FILE_NAME = "carts.txt";
    private Map<String, Map<String, Integer>> userCarts; // userId -> (bookId -> quantity)
    private ServletContext servletContext;
    private String dataFilePath;
    private BookManager bookManager;

    /**
     * Constructor with ServletContext
     */
    public CartManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        this.userCarts = new HashMap<>();
        this.bookManager = new BookManager(servletContext);
        initializeFilePath();
        loadCarts();
    }

    /**
     * Initialize the file path
     */
    private void initializeFilePath() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + CART_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + CART_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("CartManager: Using data file path: " + dataFilePath);
    }

    /**
     * Load carts from file
     */
    private void loadCarts() {
        File file = new File(dataFilePath);

        // If file doesn't exist, create it
        if (!file.exists()) {
            try {
                // Ensure parent directory exists
                if (file.getParentFile() != null) {
                    file.getParentFile().mkdirs();
                }
                file.createNewFile();
                System.out.println("Created carts file: " + dataFilePath);
                return;
            } catch (IOException e) {
                System.err.println("Error creating carts file: " + e.getMessage());
                e.printStackTrace();
                return;
            }
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            String currentUserId = null;
            Map<String, Integer> currentCart = null;

            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                if (line.startsWith("USER:")) {
                    // Start of a new user's cart
                    if (currentUserId != null && currentCart != null) {
                        userCarts.put(currentUserId, currentCart);
                    }
                    currentUserId = line.substring(5).trim();
                    currentCart = new HashMap<>();
                } else if (line.startsWith("ITEM:") && currentCart != null) {
                    // Cart item
                    String[] parts = line.substring(5).trim().split(",");
                    if (parts.length >= 2) {
                        String bookId = parts[0].trim();
                        int quantity = Integer.parseInt(parts[1].trim());
                        currentCart.put(bookId, quantity);
                    }
                }
            }

            // Add the last cart
            if (currentUserId != null && currentCart != null) {
                userCarts.put(currentUserId, currentCart);
            }

            System.out.println("Loaded " + userCarts.size() + " carts");
        } catch (IOException e) {
            System.err.println("Error loading carts: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Save carts to file
     */
    private boolean saveCarts() {
        try {
            // Ensure directory exists
            File file = new File(dataFilePath);
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                boolean created = file.getParentFile().mkdirs();
                System.out.println("Created directory: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
                for (Map.Entry<String, Map<String, Integer>> entry : userCarts.entrySet()) {
                    String userId = entry.getKey();
                    Map<String, Integer> cart = entry.getValue();

                    // Write user ID
                    writer.write("USER: " + userId);
                    writer.newLine();

                    // Write cart items
                    for (Map.Entry<String, Integer> itemEntry : cart.entrySet()) {
                        String bookId = itemEntry.getKey();
                        int quantity = itemEntry.getValue();
                        writer.write("ITEM: " + bookId + "," + quantity);
                        writer.newLine();
                    }

                    // Add a blank line between users
                    writer.newLine();
                }
            }
            System.out.println("Carts saved successfully to: " + dataFilePath);
            return true;
        } catch (IOException e) {
            System.err.println("Error saving carts: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get a user's cart
     * @param userId the user ID
     * @return the user's cart (bookId -> quantity)
     */
    public Map<String, Integer> getUserCart(String userId) {
        Map<String, Integer> cart = userCarts.get(userId);
        if (cart == null) {
            cart = new HashMap<>();
            userCarts.put(userId, cart);
        }
        return new HashMap<>(cart); // Return a copy to prevent modification
    }

    /**
     * Add an item to a user's cart
     * @param userId the user ID
     * @param bookId the book ID
     * @param quantity the quantity to add
     * @return true if successful, false otherwise
     */
    public boolean addToCart(String userId, String bookId, int quantity) {
        if (quantity <= 0) {
            return false;
        }

        // Get the book to ensure it exists and check quantity
        Book book = bookManager.getBookById(bookId);
        if (book == null) {
            return false;
        }

        // Get or create the user's cart
        Map<String, Integer> cart = userCarts.get(userId);
        if (cart == null) {
            cart = new HashMap<>();
            userCarts.put(userId, cart);
        }

        // Add or update the quantity
        int currentQuantity = cart.getOrDefault(bookId, 0);
        cart.put(bookId, currentQuantity + quantity);

        return saveCarts();
    }

    /**
     * Update the quantity of an item in a user's cart
     * @param userId the user ID
     * @param bookId the book ID
     * @param quantity the new quantity
     * @return true if successful, false otherwise
     */
    public boolean updateCartItem(String userId, String bookId, int quantity) {
        if (quantity <= 0) {
            return removeFromCart(userId, bookId);
        }

        // Get the book to ensure it exists
        Book book = bookManager.getBookById(bookId);
        if (book == null) {
            return false;
        }

        // Get the user's cart
        Map<String, Integer> cart = userCarts.get(userId);
        if (cart == null) {
            return false;
        }

        // Update the quantity
        cart.put(bookId, quantity);
        return saveCarts();
    }

    /**
     * Remove an item from a user's cart
     * @param userId the user ID
     * @param bookId the book ID
     * @return true if successful, false otherwise
     */
    public boolean removeFromCart(String userId, String bookId) {
        // Get the user's cart
        Map<String, Integer> cart = userCarts.get(userId);
        if (cart == null) {
            return false;
        }

        // Remove the item
        cart.remove(bookId);
        return saveCarts();
    }

    /**
     * Clear a user's cart
     * @param userId the user ID
     * @return true if successful, false otherwise
     */
    public boolean clearCart(String userId) {
        // Get the user's cart
        Map<String, Integer> cart = userCarts.get(userId);
        if (cart == null) {
            return false;
        }

        // Clear the cart
        cart.clear();
        return saveCarts();
    }

    /**
     * Calculate the total items in a user's cart
     * @param userId the user ID
     * @return the total number of items
     */
    public int getCartItemCount(String userId) {
        Map<String, Integer> cart = userCarts.get(userId);
        if (cart == null) {
            return 0;
        }

        int count = 0;
        for (int quantity : cart.values()) {
            count += quantity;
        }
        return count;
    }

    /**
     * Calculate the total price of a user's cart
     * @param userId the user ID
     * @return the total price
     */
    public double getCartTotal(String userId) {
        Map<String, Integer> cart = userCarts.get(userId);
        if (cart == null) {
            return 0.0;
        }

        double total = 0.0;
        for (Map.Entry<String, Integer> entry : cart.entrySet()) {
            String bookId = entry.getKey();
            int quantity = entry.getValue();

            Book book = bookManager.getBookById(bookId);
            if (book != null) {
                total += book.getDiscountedPrice() * quantity;
            }
        }
        return total;
    }

    /**
     * Get details of books in the cart
     * @param userId the user ID
     * @return map of book ID to book object
     */
    public Map<String, Book> getCartBookDetails(String userId) {
        Map<String, Integer> cart = userCarts.get(userId);
        if (cart == null) {
            return new HashMap<>();
        }

        Map<String, Book> bookDetails = new HashMap<>();
        for (String bookId : cart.keySet()) {
            Book book = bookManager.getBookById(bookId);
            if (book != null) {
                bookDetails.put(bookId, book);
            }
        }
        return bookDetails;
    }

    /**
     * Generate a cart ID for anonymous users
     * @return a unique cart ID
     */
    public static String generateCartId() {
        return "cart_" + UUID.randomUUID().toString();
    }
}