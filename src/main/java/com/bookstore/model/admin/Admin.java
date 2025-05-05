package com.bookstore.model.admin;

import java.util.Date;

public class Admin {
    private String adminId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role; // "SUPER_ADMIN" or "ADMIN"
    private Date createdDate;
    private Date lastLoginDate;
    private boolean active;

    /**
     * Constructor with all fields
     */
    public Admin(String adminId, String username, String password, String fullName,
                 String email, String role, Date createdDate, Date lastLoginDate, boolean active) {
        this.adminId = adminId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.createdDate = createdDate;
        this.lastLoginDate = lastLoginDate;
        this.active = active;
    }

    /**
     * Constructor with essential fields
     */
    public Admin(String adminId, String username, String password, String fullName, String email, String role) {
        this.adminId = adminId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.createdDate = new Date();
        this.active = true;
    }

    /**
     * Default constructor
     */
    public Admin() {
        this.createdDate = new Date();
        this.active = true;
    }

    // Getters and Setters
    public String getAdminId() {
        return adminId;
    }

    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Date lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    /**
     * Check if this admin is a super admin
     */
    public boolean isSuperAdmin() {
        return "SUPER_ADMIN".equals(role);
    }

    /**
     * Authenticate admin with provided password
     */
    public boolean authenticate(String inputPassword) {
        return this.password.equals(inputPassword);
    }

    /**
     * Convert admin to string representation for file storage
     */
    public String toFileString() {
        return adminId + "," +
                username + "," +
                password + "," +
                fullName + "," +
                email + "," +
                role + "," +
                createdDate.getTime() + "," +
                (lastLoginDate != null ? lastLoginDate.getTime() : "0") + "," +
                active;
    }

    /**
     * Create admin from string representation (from file)
     */
    public static Admin fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 9) {
            Admin admin = new Admin();
            admin.setAdminId(parts[0]);
            admin.setUsername(parts[1]);
            admin.setPassword(parts[2]);
            admin.setFullName(parts[3]);
            admin.setEmail(parts[4]);
            admin.setRole(parts[5]);
            admin.setCreatedDate(new Date(Long.parseLong(parts[6])));

            long lastLoginTime = Long.parseLong(parts[7]);
            if (lastLoginTime > 0) {
                admin.setLastLoginDate(new Date(lastLoginTime));
            }

            admin.setActive(Boolean.parseBoolean(parts[8]));

            return admin;
        }
        return null;
    }

    @Override
    public String toString() {
        return "Admin{" +
                "adminId='" + adminId + '\'' +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", active=" + active +
                '}';
    }
}