package com.bookstore.model.user;

import java.io.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletContext;

/**
 * UserManager class that handles all user-related operations using a custom LinkedList
 */
public class UserManager {
    private static final String USER_FILE_NAME = "users.txt";
    private UserLinkedList users;
    private ServletContext servletContext;
    private String dataFilePath;

    // Constructor without ServletContext (for backward compatibility)
    public UserManager() {
        this(null);
    }

    // Constructor with ServletContext
    public UserManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        users = new UserLinkedList();
        initializeFilePath();
        loadUsers();
    }

    // Initialize the file path
    private void initializeFilePath() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + USER_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + USER_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("UserManager: Using data file path: " + dataFilePath);
    }

    // Load users from file
    private void loadUsers() {
        File file = new File(dataFilePath);

        // If file doesn't exist, create it
        if (!file.exists()) {
            try {
                // Ensure parent directory exists
                if (file.getParentFile() != null) {
                    file.getParentFile().mkdirs();
                }
                file.createNewFile();
                System.out.println("Created users file: " + dataFilePath);
            } catch (IOException e) {
                System.err.println("Error creating users file: " + e.getMessage());
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

                User user = null;
                if (line.startsWith("REGULAR,")) {
                    user = RegularUser.fromFileString(line);
                } else if (line.startsWith("PREMIUM,")) {
                    user = PremiumUser.fromFileString(line);
                } else {
                    user = User.fromFileString(line);
                }

                if (user != null) {
                    users.add(user);
                    System.out.println("Loaded user: " + user.getUsername());
                }
            }
            System.out.println("Total users loaded: " + users.size());
        } catch (IOException e) {
            System.err.println("Error loading users: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Save users to file
    private boolean saveUsers() {
        try {
            // Ensure directory exists
            File file = new File(dataFilePath);
            if (!file.getParentFile().exists()) {
                boolean created = file.getParentFile().mkdirs();
                System.out.println("Created directory: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
                User[] userArray = users.toArray();
                for (User user : userArray) {
                    writer.write(user.toFileString());
                    writer.newLine();
                }
            }
            System.out.println("Users saved successfully to: " + dataFilePath);
            return true;
        } catch (IOException e) {
            System.err.println("Error saving users: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Add a new user
    public boolean addUser(User user) {
        try {
            // Check if username already exists
            System.out.println("Adding new user: " + user.getUsername());

            if (getUserByUsername(user.getUsername()) != null) {
                System.out.println("Username already exists: " + user.getUsername());
                return false;
            }

            // Generate a unique ID if not provided
            if (user.getUserId() == null || user.getUserId().isEmpty()) {
                user.setUserId(UUID.randomUUID().toString());
            }

            // Set registration date if not set
            if (user.getRegistrationDate() == null) {
                user.setRegistrationDate(new Date());
            }

            users.add(user);
            boolean saved = saveUsers();
            System.out.println("User saved successfully: " + saved);
            return saved;
        } catch (Exception e) {
            System.err.println("Exception occurred when adding user:");
            e.printStackTrace();
            return false;
        }
    }

    // Get user by ID
    public User getUserById(String userId) {
        return users.findById(userId);
    }

    // Get user by username
    public User getUserByUsername(String username) {
        return users.findByUsername(username);
    }

    // Update user details
    public boolean updateUser(User updatedUser) {
        boolean updated = users.update(updatedUser);
        if (updated) {
            return saveUsers();
        }
        return false;
    }

    // Delete user
    public boolean deleteUser(String userId) {
        User user = getUserById(userId);
        if (user != null) {
            boolean removed = users.remove(user);
            if (removed) {
                return saveUsers();
            }
        }
        return false;
    }

    // Get all users
    public List<User> getAllUsers() {
        User[] userArray = users.toArray();
        List<User> userList = new ArrayList<>();
        for (User user : userArray) {
            userList.add(user);
        }
        return userList;
    }

    // Authenticate user
    public User authenticateUser(String username, String password) {
        User user = getUserByUsername(username);
        if (user != null && user.authenticate(password)) {
            // Update last login date
            user.setLastLoginDate(new Date());
            updateUser(user);
            return user;
        }
        return null;
    }

    // Upgrade regular user to premium
    public boolean upgradeToPremium(String userId) {
        User user = getUserById(userId);
        if (user != null && user instanceof RegularUser) {
            RegularUser regularUser = (RegularUser) user;

            // Create a new premium user with the same details
            PremiumUser premiumUser = new PremiumUser(
                    regularUser.getUserId(),
                    regularUser.getUsername(),
                    regularUser.getPassword(),
                    regularUser.getEmail(),
                    regularUser.getFullName(),
                    regularUser.getRegistrationDate(),
                    regularUser.getLastLoginDate(),
                    new Date(System.currentTimeMillis() + 365L * 24 * 60 * 60 * 1000), // One year subscription
                    "SILVER", // Default tier
                    regularUser.getLoyaltyPoints() * 2 // Convert loyalty points to reward points
            );

            // Update the user
            return updateUser(premiumUser);
        }
        return false;
    }

    // Change user password
    public boolean changePassword(String userId, String oldPassword, String newPassword) {
        User user = getUserById(userId);
        if (user != null && user.authenticate(oldPassword)) {
            user.setPassword(newPassword);
            return updateUser(user);
        }
        return false;
    }

    // Reset password (admin function)
    public boolean resetPassword(String userId, String newPassword) {
        User user = getUserById(userId);
        if (user != null) {
            user.setPassword(newPassword);
            return updateUser(user);
        }
        return false;
    }

    // Count total number of users
    public int getUserCount() {
        return users.size();
    }

    // Count premium users
    public int getPremiumUserCount() {
        User[] userArray = users.toArray();
        int count = 0;
        for (User user : userArray) {
            if (user instanceof PremiumUser) {
                count++;
            }
        }
        return count;
    }

    // Set ServletContext (can be used to update the context after initialization)
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePath();
        // Reload users with the new file path
        users.clear();
        loadUsers();
    }
}