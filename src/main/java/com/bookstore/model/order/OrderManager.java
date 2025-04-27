package com.bookstore.model.order;

import java.io.*;
import java.util.*;
import javax.servlet.ServletContext;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.book.EBook;
import com.bookstore.model.book.PhysicalBook;
import com.bookstore.model.cart.CartManager;
import com.bookstore.util.QuickSort;

/**
 * Manages all order-related operations
 */
public class OrderManager {
    private static final String ORDERS_FILE_NAME = "orders.txt";
    private static final String ORDER_ITEMS_FILE_NAME = "order_items.txt";
    private static final String PAYMENTS_FILE_NAME = "payments.txt";

    private Map<String, Order> orders; // orderId -> Order
    private ServletContext servletContext;
    private String dataFolderPath;
    private BookManager bookManager;

    /**
     * Constructor with ServletContext
     */
    public OrderManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        this.orders = new HashMap<>();
        this.bookManager = new BookManager(servletContext);
        initializeFilePath();
        loadOrders();
    }

    /**
     * Constructor without ServletContext (for testing)
     */
    public OrderManager() {
        this(null);
    }

    /**
     * Initialize file paths
     */
    private void initializeFilePath() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            dataFolderPath = servletContext.getRealPath("/WEB-INF/data");

            // Make sure directory exists
            File dataDir = new File(dataFolderPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            dataFolderPath = "data";

            // Make sure directory exists
            File dataDir = new File(dataFolderPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        }

        System.out.println("OrderManager: Using data folder path: " + dataFolderPath);
    }

    /**
     * Get the full path to a file
     */
    private String getFilePath(String fileName) {
        return dataFolderPath + File.separator + fileName;
    }

    /**
     * Load orders from file
     */
    private void loadOrders() {
        // Load orders
        loadOrdersFromFile();

        // Load order items
        loadOrderItemsFromFile();

        // Load payments
        loadPaymentsFromFile();

        System.out.println("Total orders loaded: " + orders.size());
    }

    /**
     * Load orders from the orders file
     */
    private void loadOrdersFromFile() {
        File file = new File(getFilePath(ORDERS_FILE_NAME));
        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created orders file: " + file.getAbsolutePath());
            } catch (IOException e) {
                System.err.println("Error creating orders file: " + e.getMessage());
                e.printStackTrace();
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                try {
                    Order order = Order.fromFileString(line);
                    if (order != null) {
                        orders.put(order.getOrderId(), order);
                        System.out.println("Loaded order: " + order.getOrderId());
                    } else {
                        System.err.println("Failed to parse order from line: " + line);
                    }
                } catch (Exception e) {
                    System.err.println("Error parsing order from line: " + line);
                    e.printStackTrace();
                }
            }
            System.out.println("Orders loaded from file: " + orders.size());
        } catch (IOException e) {
            System.err.println("Error loading orders: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Load order items from the items file
     */
    private void loadOrderItemsFromFile() {
        File file = new File(getFilePath(ORDER_ITEMS_FILE_NAME));
        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created order items file: " + file.getAbsolutePath());
            } catch (IOException e) {
                System.err.println("Error creating order items file: " + e.getMessage());
                e.printStackTrace();
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            int lineCount = 0;
            int processedItems = 0;

            while ((line = reader.readLine()) != null) {
                lineCount++;
                if (line.trim().isEmpty()) continue;

                try {
                    // Format should be: orderId,bookId,title,author,price,discountedPrice,quantity,bookType
                    int firstCommaIndex = line.indexOf(',');
                    if (firstCommaIndex > 0) {
                        String orderId = line.substring(0, firstCommaIndex).trim();
                        String itemData = line.substring(firstCommaIndex + 1);

                        System.out.println("Processing order item - Order ID: " + orderId);

                        // Find the order first
                        Order order = orders.get(orderId);
                        if (order != null) {
                            // Create the item from the remaining data
                            OrderItem item = OrderItem.fromFileString(itemData);
                            if (item != null) {
                                // Initialize the items list if needed
                                if (order.getItems() == null) {
                                    order.setItems(new ArrayList<>());
                                }
                                order.getItems().add(item);
                                processedItems++;
                                System.out.println("Added item to order: " + orderId);
                            } else {
                                System.err.println("Failed to parse order item from line: " + line);
                            }
                        } else {
                            System.err.println("Order not found for item: " + orderId);
                        }
                    } else {
                        System.err.println("Invalid order item format (missing first comma): " + line);
                    }
                } catch (Exception e) {
                    System.err.println("Error processing order item line: " + line);
                    e.printStackTrace();
                }
            }

            System.out.println("Read " + lineCount + " lines from order items file");
            System.out.println("Successfully processed " + processedItems + " order items");

            // Now recalculate totals for all orders
            for (Order order : orders.values()) {
                if (order.getItems() != null && !order.getItems().isEmpty()) {
                    order.calculateTotals();
                    System.out.println("Recalculated totals for order: " + order.getOrderId() +
                            ", Total: " + order.getTotal());
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading order items: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Load payments from the payments file
     */
    private void loadPaymentsFromFile() {
        File file = new File(getFilePath(PAYMENTS_FILE_NAME));
        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created payments file: " + file.getAbsolutePath());
            } catch (IOException e) {
                System.err.println("Error creating payments file: " + e.getMessage());
                e.printStackTrace();
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                try {
                    Payment payment = Payment.fromFileString(line);
                    if (payment != null && payment.getOrderId() != null) {
                        Order order = orders.get(payment.getOrderId());
                        if (order != null) {
                            order.setPayment(payment);
                            System.out.println("Added payment to order: " + payment.getOrderId());
                        } else {
                            System.err.println("Order not found for payment: " + payment.getOrderId());
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error parsing payment from line: " + line);
                    e.printStackTrace();
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading payments: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Save all data to files
     */
    private boolean saveData() {
        boolean ordersSaved = saveOrdersToFile();
        boolean itemsSaved = saveOrderItemsToFile();
        boolean paymentsSaved = savePaymentsToFile();

        return ordersSaved && itemsSaved && paymentsSaved;
    }

    /**
     * Save orders to file
     */
    private boolean saveOrdersToFile() {
        try {
            File file = new File(getFilePath(ORDERS_FILE_NAME));
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Order order : orders.values()) {
                    writer.write(order.toFileString());
                    writer.newLine();
                }
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error saving orders: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Save order items to file
     */
    private boolean saveOrderItemsToFile() {
        try {
            File file = new File(getFilePath(ORDER_ITEMS_FILE_NAME));
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Order order : orders.values()) {
                    writer.write(order.itemsToFileString());
                }
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error saving order items: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Save payments to file
     */
    private boolean savePaymentsToFile() {
        try {
            File file = new File(getFilePath(PAYMENTS_FILE_NAME));
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Order order : orders.values()) {
                    Payment payment = order.getPayment();
                    if (payment != null) {
                        writer.write(payment.toFileString());
                        writer.newLine();
                    }
                }
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error saving payments: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Create a new order
     */
    public Order createOrder(String userId, Map<String, Integer> cartItems,
                             String shippingAddress, String billingAddress,
                             String contactEmail, String contactPhone) {

        // Create order items from cart
        List<OrderItem> orderItems = new ArrayList<>();

        for (Map.Entry<String, Integer> entry : cartItems.entrySet()) {
            String bookId = entry.getKey();
            int quantity = entry.getValue();

            Book book = bookManager.getBookById(bookId);
            if (book != null) {
                // Create order item
                OrderItem item = new OrderItem();
                item.setBookId(bookId);
                item.setTitle(book.getTitle());
                item.setAuthor(book.getAuthor());
                item.setPrice(book.getPrice());
                item.setDiscountedPrice(book.getDiscountedPrice());
                item.setQuantity(quantity);

                // Set book type
                if (book instanceof EBook) {
                    item.setBookType("EBOOK");
                } else if (book instanceof PhysicalBook) {
                    item.setBookType("PHYSICAL");
                } else {
                    item.setBookType("BOOK");
                }

                orderItems.add(item);

                // Decrease book quantity (for physical books)
                if (!(book instanceof EBook)) {
                    book.decreaseQuantity(quantity);
                    bookManager.updateBook(book);
                }
            }
        }

        // Create new order
        Order order = new Order(userId, orderItems, shippingAddress,
                billingAddress, contactEmail, contactPhone);

        // Calculate shipping cost based on total and user type
        // For simplicity, we'll use a flat rate of $4.99 for orders under $35
        if (order.getSubtotal() < 35.0) {
            order.setShippingCost(4.99);
        } else {
            order.setShippingCost(0.0); // Free shipping for orders $35+
        }

        // Recalculate totals with shipping
        order.calculateTotals();

        // Save the order
        orders.put(order.getOrderId(), order);
        saveData();

        return order;
    }

    /**
     * Add payment to an order
     */
    public boolean addPayment(String orderId, Payment payment) {
        Order order = getOrderById(orderId);
        if (order == null) {
            return false;
        }

        // Set payment and update order status
        order.setPayment(payment);

        if (payment.isSuccessful()) {
            order.setStatus(OrderStatus.PROCESSING);
        }

        // Save changes
        return saveData();
    }

    /**
     * Update order status
     */
    public boolean updateOrderStatus(String orderId, OrderStatus newStatus) {
        Order order = getOrderById(orderId);
        if (order == null) {
            return false;
        }

        // Update status
        order.setStatus(newStatus);

        // Update additional fields based on status
        if (newStatus == OrderStatus.SHIPPED) {
            order.setShippedDate(new Date());

            // Generate a tracking number if one doesn't exist
            if (order.getTrackingNumber() == null || order.getTrackingNumber().isEmpty()) {
                order.setTrackingNumber("TRK" + System.currentTimeMillis());
            }
        } else if (newStatus == OrderStatus.DELIVERED) {
            order.setDeliveredDate(new Date());
        }

        // Save changes
        return saveData();
    }

    /**
     * Cancel an order
     */
    public boolean cancelOrder(String orderId) {
        Order order = getOrderById(orderId);
        if (order == null || !order.canCancel()) {
            return false;
        }

        // Update status
        order.setStatus(OrderStatus.CANCELLED);

        // Return items to inventory (for physical books)
        for (OrderItem item : order.getItems()) {
            if ("PHYSICAL".equals(item.getBookType()) || "BOOK".equals(item.getBookType())) {
                Book book = bookManager.getBookById(item.getBookId());
                if (book != null) {
                    book.increaseQuantity(item.getQuantity());
                    bookManager.updateBook(book);
                }
            }
        }

        // Save changes
        return saveData();
    }

    /**
     * Delete an order (admin function)
     */
    public boolean deleteOrder(String orderId) {
        Order order = orders.remove(orderId);
        return order != null && saveData();
    }

    /**
     * Get an order by ID
     */
    public Order getOrderById(String orderId) {
        return orders.get(orderId);
    }

    /**
     * Get all orders for a user
     */
    public List<Order> getOrdersByUser(String userId) {
        List<Order> userOrders = new ArrayList<>();

        for (Order order : orders.values()) {
            if (order.getUserId() != null && order.getUserId().equals(userId)) {
                userOrders.add(order);
            }
        }

        // Sort by date (newest first)
        if (!userOrders.isEmpty()) {
            QuickSort.sort(userOrders.toArray(new Order[0]), (o1, o2) ->
                    o2.getOrderDate().compareTo(o1.getOrderDate())
            );
        }

        return userOrders;
    }

    /**
     * Get all orders
     */
    public List<Order> getAllOrders() {
        List<Order> allOrders = new ArrayList<>(orders.values());

        // Sort by date (newest first)
        if (!allOrders.isEmpty()) {
            QuickSort.sort(allOrders.toArray(new Order[0]), (o1, o2) ->
                    o2.getOrderDate().compareTo(o1.getOrderDate())
            );
        }

        return allOrders;
    }

    /**
     * Get orders by status
     */
    public List<Order> getOrdersByStatus(OrderStatus status) {
        List<Order> filteredOrders = new ArrayList<>();

        for (Order order : orders.values()) {
            if (order.getStatus() == status) {
                filteredOrders.add(order);
            }
        }

        // Sort by date (newest first)
        if (!filteredOrders.isEmpty()) {
            QuickSort.sort(filteredOrders.toArray(new Order[0]), (o1, o2) ->
                    o2.getOrderDate().compareTo(o1.getOrderDate())
            );
        }

        return filteredOrders;
    }

    /**
     * Update tracking number
     */
    public boolean updateTrackingNumber(String orderId, String trackingNumber) {
        Order order = getOrderById(orderId);
        if (order == null) {
            return false;
        }

        order.setTrackingNumber(trackingNumber);

        // If adding tracking number and status is PROCESSING, update to SHIPPED
        if (order.getStatus() == OrderStatus.PROCESSING && trackingNumber != null && !trackingNumber.isEmpty()) {
            order.setStatus(OrderStatus.SHIPPED);
            order.setShippedDate(new Date());
        }

        return saveData();
    }

    /**
     * Update order notes
     */
    public boolean updateOrderNotes(String orderId, String notes) {
        Order order = getOrderById(orderId);
        if (order == null) {
            return false;
        }

        order.setNotes(notes);
        return saveData();
    }

    /**
     * Get count of orders by status
     */
    public Map<OrderStatus, Integer> getOrderCountsByStatus() {
        Map<OrderStatus, Integer> counts = new HashMap<>();

        for (OrderStatus status : OrderStatus.values()) {
            counts.put(status, 0);
        }

        for (Order order : orders.values()) {
            OrderStatus status = order.getStatus();
            counts.put(status, counts.get(status) + 1);
        }

        return counts;
    }

    /**
     * Get the total sales amount
     */
    public double getTotalSales() {
        double total = 0;

        for (Order order : orders.values()) {
            if (order.getStatus() != OrderStatus.CANCELLED) {
                total += order.getTotal();
            }
        }

        return total;
    }

    /**
     * Search orders (for admin)
     */
    public List<Order> searchOrders(String query) {
        List<Order> results = new ArrayList<>();

        if (query == null || query.trim().isEmpty()) {
            return getAllOrders();
        }

        String searchQuery = query.toLowerCase();

        for (Order order : orders.values()) {
            // Check if the order ID contains the query
            if (order.getOrderId().toLowerCase().contains(searchQuery)) {
                results.add(order);
                continue;
            }

            // Check if user ID contains the query
            if (order.getUserId().toLowerCase().contains(searchQuery)) {
                results.add(order);
                continue;
            }

            // Check if shipping address contains the query
            if (order.getShippingAddress() != null &&
                    order.getShippingAddress().toLowerCase().contains(searchQuery)) {
                results.add(order);
                continue;
            }

            // Check if email contains the query
            if (order.getContactEmail() != null &&
                    order.getContactEmail().toLowerCase().contains(searchQuery)) {
                results.add(order);
                continue;
            }

            // Check if tracking number contains the query
            if (order.getTrackingNumber() != null &&
                    order.getTrackingNumber().toLowerCase().contains(searchQuery)) {
                results.add(order);
                continue;
            }

            // Check if any book title or author contains the query
            for (OrderItem item : order.getItems()) {
                if ((item.getTitle() != null && item.getTitle().toLowerCase().contains(searchQuery)) ||
                        (item.getAuthor() != null && item.getAuthor().toLowerCase().contains(searchQuery))) {
                    results.add(order);
                    break;
                }
            }
        }

        // Sort by date (newest first)
        if (!results.isEmpty()) {
            QuickSort.sort(results.toArray(new Order[0]), (o1, o2) ->
                    o2.getOrderDate().compareTo(o1.getOrderDate())
            );
        }

        return results;
    }
}