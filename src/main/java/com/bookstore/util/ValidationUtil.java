package com.bookstore.util;

import java.util.regex.Pattern;

/**
 * Utility class for input validation
 */
public class ValidationUtil {
    // Email validation regex pattern
    private static final String EMAIL_REGEX =
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";

    // Username validation regex pattern
    private static final String USERNAME_REGEX = "^[a-zA-Z0-9_]{3,20}$";

    // Password validation regex pattern
    private static final String PASSWORD_REGEX = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,20}$";

    // ISBN validation regex pattern
    private static final String ISBN_REGEX = "^(?:ISBN(?:-1[03])?:? )?(?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]$";

    // Price validation regex pattern (positive number with up to 2 decimal places)
    private static final String PRICE_REGEX = "^\\d+(\\.\\d{1,2})?$";

    /**
     * Validate email address
     * @param email Email to validate
     * @return True if email is valid, false otherwise
     */
    public static boolean isValidEmail(String email) {
        return email != null && Pattern.matches(EMAIL_REGEX, email);
    }

    /**
     * Validate username
     * @param username Username to validate
     * @return True if username is valid, false otherwise
     */
    public static boolean isValidUsername(String username) {
        return username != null && Pattern.matches(USERNAME_REGEX, username);
    }

    /**
     * Validate password
     * @param password Password to validate
     * @return True if password is valid, false otherwise
     */
    public static boolean isValidPassword(String password) {
        return password != null && Pattern.matches(PASSWORD_REGEX, password);
    }

    /**
     * Validate ISBN
     * @param isbn ISBN to validate
     * @return True if ISBN is valid, false otherwise
     */
    public static boolean isValidISBN(String isbn) {
        return isbn != null && Pattern.matches(ISBN_REGEX, isbn);
    }

    /**
     * Validate price
     * @param price Price to validate
     * @return True if price is valid, false otherwise
     */
    public static boolean isValidPrice(String price) {
        return price != null && Pattern.matches(PRICE_REGEX, price);
    }

    /**
     * Check if string is null or empty
     * @param str String to check
     * @return True if string is null or empty, false otherwise
     */
    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Validate integer within a range
     * @param value Value to validate
     * @param min Minimum value (inclusive)
     * @param max Maximum value (inclusive)
     * @return True if value is within range, false otherwise
     */
    public static boolean isValidIntegerRange(int value, int min, int max) {
        return value >= min && value <= max;
    }

    /**
     * Trim and clean input string
     * @param input Input string
     * @return Trimmed and cleaned string, or empty string if input is null
     */
    public static String cleanInput(String input) {
        return input != null ? input.trim() : "";
    }

    /**
     * Sanitize HTML input to prevent XSS attacks
     * @param input Input string that might contain HTML
     * @return Sanitized string
     */
    public static String sanitizeHtml(String input) {
        if (input == null) {
            return "";
        }

        // Replace HTML special characters with their entity equivalents
        String sanitized = input
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;")
                .replace("/", "&#x2F;");

        return sanitized;
    }

    /**
     * Convert string to double safely
     * @param input Input string
     * @param defaultValue Default value to return if conversion fails
     * @return Converted double or default value
     */
    public static double parseDoubleOrDefault(String input, double defaultValue) {
        if (input == null || input.trim().isEmpty()) {
            return defaultValue;
        }

        try {
            return Double.parseDouble(input);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Convert string to integer safely
     * @param input Input string
     * @param defaultValue Default value to return if conversion fails
     * @return Converted integer or default value
     */
    public static int parseIntOrDefault(String input, int defaultValue) {
        if (input == null || input.trim().isEmpty()) {
            return defaultValue;
        }

        try {
            return Integer.parseInt(input);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Limit string length
     * @param input Input string
     * @param maxLength Maximum length
     * @return Truncated string if longer than maxLength
     */
    public static String truncateString(String input, int maxLength) {
        if (input == null) {
            return "";
        }

        return input.length() <= maxLength ? input : input.substring(0, maxLength);
    }
}