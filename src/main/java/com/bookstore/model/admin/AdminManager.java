package com.bookstore.model.admin;

import java.io.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletContext;

import com.bookstore.util.PasswordUtil;

/**
 * AdminManager handles all administrator-related operations
 */
public class AdminManager {
    private static final String ADMIN_FILE_NAME = "admins.txt";
    private List<Admin> admins;
    private ServletContext servletContext;
    private String dataFilePath;

    /**
     * Constructor without ServletContext
     */
    public AdminManager() {
        this(null);
    }

    /**
     * Constructor with ServletContext
     */
    public AdminManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        this.admins = new ArrayList<>();
        initializeFilePath();
        loadAdmins();
        createSuperAdminIfNeeded();
    }

    /**
     * Initialize the file path
     */
    private void initializeFilePath() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + ADMIN_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + ADMIN_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("AdminManager: Using data file path: " + dataFilePath);
    }

    /**
     * Load admins from file
     */
    private void loadAdmins() {
        File file = new File(dataFilePath);

        // If file doesn't exist, create it
        if (!file.exists()) {
            try {
                // Ensure parent directory exists
                if (file.getParentFile() != null) {
                    file.getParentFile().mkdirs();
                }
                file.createNewFile();
                System.out.println("Created admins file: " + dataFilePath);
            } catch (IOException e) {
                System.err.println("Error creating admins file: " + e.getMessage());
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

                Admin admin = Admin.fromFileString(line);
                if (admin != null) {
                    admins.add(admin);
                    System.out.println("Loaded admin: " + admin.getUsername());
                }
            }
            System.out.println("Total admins loaded: " + admins.size());
        } catch (IOException e) {
            System.err.println("Error loading admins: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Create super admin account if no admins exist
     */
    private void createSuperAdminIfNeeded() {
        if (admins.isEmpty()) {
            // Create default super admin
            String adminId = UUID.randomUUID().toString();
            String username = "admin";
            // Generate a secure password
            String password = "admin123"; // In production, use a more secure password

            // For security, hash the password in a real production environment
            // Here we're just storing it plainly for demonstration

            Admin superAdmin = new Admin(
                    adminId,
                    username,
                    password,
                    "System Administrator",
                    "admin@bookverse.com",
                    "SUPER_ADMIN"
            );

            admins.add(superAdmin);
            saveAdmins();

            System.out.println("Created default Super Admin account:");
            System.out.println("Username: " + username);
            System.out.println("Password: " + password);
            System.out.println("Please change this password after first login!");
        }
    }

    /**
     * Save admins to file
     */
    private boolean saveAdmins() {
        try {
            // Ensure directory exists
            File file = new File(dataFilePath);
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                boolean created = file.getParentFile().mkdirs();
                System.out.println("Created directory: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
                for (Admin admin : admins) {
                    writer.write(admin.toFileString());
                    writer.newLine();
                }
            }
            System.out.println("Admins saved successfully to: " + dataFilePath);
            return true;
        } catch (IOException e) {
            System.err.println("Error saving admins: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Add a new admin
     */
    public boolean addAdmin(Admin admin) {
        try {
            // Check if username already exists
            System.out.println("Adding new admin: " + admin.getUsername());

            if (getAdminByUsername(admin.getUsername()) != null) {
                System.out.println("Username already exists: " + admin.getUsername());
                return false;
            }

            // Generate a unique ID if not provided
            if (admin.getAdminId() == null || admin.getAdminId().isEmpty()) {
                admin.setAdminId(UUID.randomUUID().toString());
            }

            // Set creation date if not set
            if (admin.getCreatedDate() == null) {
                admin.setCreatedDate(new Date());
            }

            admins.add(admin);
            boolean saved = saveAdmins();
            System.out.println("Admin saved successfully: " + saved);
            return saved;
        } catch (Exception e) {
            System.err.println("Exception occurred when adding admin:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get admin by ID
     */
    public Admin getAdminById(String adminId) {
        for (Admin admin : admins) {
            if (admin.getAdminId().equals(adminId)) {
                return admin;
            }
        }
        return null;
    }

    /**
     * Get admin by username
     */
    public Admin getAdminByUsername(String username) {
        for (Admin admin : admins) {
            if (admin.getUsername().equals(username)) {
                return admin;
            }
        }
        return null;
    }

    /**
     * Update admin details
     */
    public boolean updateAdmin(Admin updatedAdmin) {
        for (int i = 0; i < admins.size(); i++) {
            if (admins.get(i).getAdminId().equals(updatedAdmin.getAdminId())) {
                admins.set(i, updatedAdmin);
                return saveAdmins();
            }
        }
        return false;
    }

    /**
     * Delete admin
     */
    public boolean deleteAdmin(String adminId) {
        // Prevent deleting the last super admin
        int superAdminCount = 0;
        Admin adminToDelete = null;

        // Count super admins and find the admin to delete
        for (Admin admin : admins) {
            if (admin.isSuperAdmin()) {
                superAdminCount++;
            }
            if (admin.getAdminId().equals(adminId)) {
                adminToDelete = admin;
            }
        }

        // Don't allow deleting the last super admin
        if (adminToDelete != null && adminToDelete.isSuperAdmin() && superAdminCount <= 1) {
            System.out.println("Cannot delete the last super admin");
            return false;
        }

        // Remove the admin
        boolean removed = admins.removeIf(admin -> admin.getAdminId().equals(adminId));
        if (removed) {
            return saveAdmins();
        }
        return false;
    }

    /**
     * Get all admins
     */
    public List<Admin> getAllAdmins() {
        return new ArrayList<>(admins);
    }

    /**
     * Authenticate admin
     */
    public Admin authenticateAdmin(String username, String password) {
        Admin admin = getAdminByUsername(username);
        if (admin != null && admin.authenticate(password) && admin.isActive()) {
            // Update last login date
            admin.setLastLoginDate(new Date());
            updateAdmin(admin);
            return admin;
        }
        return null;
    }

    /**
     * Change admin password
     */
    public boolean changePassword(String adminId, String oldPassword, String newPassword) {
        Admin admin = getAdminById(adminId);
        if (admin != null && admin.authenticate(oldPassword)) {
            admin.setPassword(newPassword);
            return updateAdmin(admin);
        }
        return false;
    }

    /**
     * Reset admin password (super admin function)
     */
    public boolean resetPassword(String adminId, String newPassword) {
        Admin admin = getAdminById(adminId);
        if (admin != null) {
            admin.setPassword(newPassword);
            return updateAdmin(admin);
        }
        return false;
    }

    /**
     * Deactivate admin account
     */
    public boolean deactivateAdmin(String adminId) {
        // Cannot deactivate the last super admin
        int superAdminCount = 0;
        Admin adminToDeactivate = null;

        for (Admin admin : admins) {
            if (admin.isSuperAdmin() && admin.isActive()) {
                superAdminCount++;
            }
            if (admin.getAdminId().equals(adminId)) {
                adminToDeactivate = admin;
            }
        }

        if (adminToDeactivate != null && adminToDeactivate.isSuperAdmin() && superAdminCount <= 1) {
            System.out.println("Cannot deactivate the last super admin");
            return false;
        }

        if (adminToDeactivate != null) {
            adminToDeactivate.setActive(false);
            return updateAdmin(adminToDeactivate);
        }

        return false;
    }

    /**
     * Activate admin account
     */
    public boolean activateAdmin(String adminId) {
        Admin admin = getAdminById(adminId);
        if (admin != null) {
            admin.setActive(true);
            return updateAdmin(admin);
        }
        return false;
    }

    /**
     * Count total admins
     */
    public int getAdminCount() {
        return admins.size();
    }

    /**
     * Count super admins
     */
    public int getSuperAdminCount() {
        int count = 0;
        for (Admin admin : admins) {
            if (admin.isSuperAdmin()) {
                count++;
            }
        }
        return count;
    }

    /**
     * Set ServletContext (can be used to update the context after initialization)
     */
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePath();
        // Reload admins with the new file path
        admins.clear();
        loadAdmins();
        createSuperAdminIfNeeded();
    }
}