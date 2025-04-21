package com.bookstore.model.user;

import java.util.Date;

/**
 * Base User class representing common user attributes and behaviors
 */
public class User {
    private String userId;
    private String username;
    private String password;
    private String email;
    private String fullName;
    private Date registrationDate;
    private Date lastLoginDate;

    // Constructor with all fields
    public User(String userId, String username, String password, String email, String fullName,
                Date registrationDate, Date lastLoginDate) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.registrationDate = registrationDate;
        this.lastLoginDate = lastLoginDate;
    }

    // Constructor with essential fields
    public User(String userId, String username, String password, String email, String fullName) {
        this(userId, username, password, email, fullName, new Date(), null);
    }

    // Default constructor
    public User() {
        this.userId = "";
        this.username = "";
        this.password = "";
        this.email = "";
        this.fullName = "";
        this.registrationDate = new Date();
        this.lastLoginDate = null;
    }

    // Getters and setters
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Date getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }

    public Date getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Date lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    // Method to authenticate user
    public boolean authenticate(String inputPassword) {
        return this.password.equals(inputPassword);
    }

    // Method to get order limit (to be overridden by subclasses)
    public int getOrderLimit() {
        return 5; // Default order limit
    }

    // Convert user to string representation for file storage
    public String toFileString() {
        return userId + "," + username + "," + password + "," + email + "," + fullName + "," +
                registrationDate.getTime() + "," + (lastLoginDate != null ? lastLoginDate.getTime() : "0");
    }

    // Create user from string representation (from file)
    public static User fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 7) {
            User user = new User();
            user.setUserId(parts[0]);
            user.setUsername(parts[1]);
            user.setPassword(parts[2]);
            user.setEmail(parts[3]);
            user.setFullName(parts[4]);
            user.setRegistrationDate(new Date(Long.parseLong(parts[5])));

            long lastLoginTime = Long.parseLong(parts[6]);
            if (lastLoginTime > 0) {
                user.setLastLoginDate(new Date(lastLoginTime));
            }

            return user;
        }
        return null;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId='" + userId + '\'' +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", registrationDate=" + registrationDate +
                ", lastLoginDate=" + lastLoginDate +
                '}';
    }
}