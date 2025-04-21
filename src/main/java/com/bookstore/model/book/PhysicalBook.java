package com.bookstore.model.book;

import java.util.Date;

/**
 * PhysicalBook class representing physical books with additional attributes
 */
public class PhysicalBook extends Book {
    private int pageCount;
    private String dimensions; // e.g. "6 x 9 inches"
    private String binding; // Hardcover, Paperback, etc.
    private double weightKg;
    private String edition;
    private String condition; // New, Used, etc.
    private String language;

    /**
     * Constructor with all fields
     */
    public PhysicalBook(String id, String title, String author, String isbn, String publisher,
                        Date publicationDate, String genre, String description, double price,
                        int quantity, String coverImagePath, double averageRating,
                        int numberOfRatings, boolean featured, Date addedDate,
                        int pageCount, String dimensions, String binding, double weightKg,
                        String edition, String condition, String language) {
        super(id, title, author, isbn, publisher, publicationDate, genre, description,
                price, quantity, coverImagePath, averageRating, numberOfRatings, featured, addedDate);
        this.pageCount = pageCount;
        this.dimensions = dimensions;
        this.binding = binding;
        this.weightKg = weightKg;
        this.edition = edition;
        this.condition = condition;
        this.language = language;
    }

    /**
     * Constructor with essential fields
     */
    public PhysicalBook(String title, String author, String isbn, String publisher,
                        Date publicationDate, String genre, String description, double price,
                        int quantity, int pageCount, String binding, String condition) {
        super(title, author, isbn, publisher, publicationDate, genre, description, price, quantity);
        this.pageCount = pageCount;
        this.binding = binding;
        this.condition = condition;
        this.dimensions = "";
        this.weightKg = 0.0;
        this.edition = "1st";
        this.language = "English";
    }

    /**
     * Default constructor
     */
    public PhysicalBook() {
        super();
        this.pageCount = 0;
        this.dimensions = "";
        this.binding = "Paperback";
        this.weightKg = 0.0;
        this.edition = "1st";
        this.condition = "New";
        this.language = "English";
    }

    // Getters and Setters
    public int getPageCount() {
        return pageCount;
    }

    public void setPageCount(int pageCount) {
        this.pageCount = pageCount;
    }

    public String getDimensions() {
        return dimensions;
    }

    public void setDimensions(String dimensions) {
        this.dimensions = dimensions;
    }

    public String getBinding() {
        return binding;
    }

    public void setBinding(String binding) {
        this.binding = binding;
    }

    public double getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(double weightKg) {
        this.weightKg = weightKg;
    }

    public String getEdition() {
        return edition;
    }

    public void setEdition(String edition) {
        this.edition = edition;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    /**
     * Calculate shipping weight (book weight plus packaging)
     * @return shipping weight in kg
     */
    public double getShippingWeight() {
        return weightKg + 0.2; // Add 200g for packaging
    }

    /**
     * Calculate discount based on condition
     */
    @Override
    public double getDiscountedPrice() {
        // Apply different discounts based on condition
        if ("Used - Like New".equals(condition)) {
            return getPrice() * 0.9; // 10% discount
        } else if ("Used - Very Good".equals(condition)) {
            return getPrice() * 0.85; // 15% discount
        } else if ("Used - Good".equals(condition)) {
            return getPrice() * 0.8; // 20% discount
        } else if ("Used - Acceptable".equals(condition)) {
            return getPrice() * 0.7; // 30% discount
        }

        // No discount for new books
        return getPrice();
    }

    /**
     * Calculate shipping cost based on weight and dimensions
     * @return shipping cost
     */
    public double calculateShippingCost() {
        // Base shipping cost
        double baseCost = 3.99;

        // Add cost based on weight
        if (weightKg > 0.5) {
            baseCost += (weightKg - 0.5) * 2.0; // $2 per kg above 500g
        }

        return baseCost;
    }

    /**
     * Convert physical book to string representation for file storage
     */
    @Override
    public String toFileString() {
        StringBuilder sb = new StringBuilder();
        sb.append("PHYSICAL,");
        sb.append(super.toFileString().substring(5)); // Remove "BOOK," prefix
        sb.append(",").append(pageCount);
        sb.append(",").append(dimensions);
        sb.append(",").append(binding);
        sb.append(",").append(weightKg);
        sb.append(",").append(edition);
        sb.append(",").append(condition);
        sb.append(",").append(language);
        return sb.toString();
    }

    /**
     * Create physical book from string representation (from file)
     */
    public static PhysicalBook fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 22 && parts[0].equals("PHYSICAL")) {
            PhysicalBook physicalBook = new PhysicalBook();

            // Set base Book properties
            physicalBook.setId(parts[1]);
            physicalBook.setTitle(parts[2]);
            physicalBook.setAuthor(parts[3]);
            physicalBook.setIsbn(parts[4]);
            physicalBook.setPublisher(parts[5]);

            long pubDateLong = Long.parseLong(parts[6]);
            if (pubDateLong > 0) {
                physicalBook.setPublicationDate(new Date(pubDateLong));
            }

            physicalBook.setGenre(parts[7]);
            physicalBook.setDescription(parts[8].replace("{{COMMA}}", ","));
            physicalBook.setPrice(Double.parseDouble(parts[9]));
            physicalBook.setQuantity(Integer.parseInt(parts[10]));
            physicalBook.setCoverImagePath(parts[11]);
            physicalBook.setAverageRating(Double.parseDouble(parts[12]));
            physicalBook.setNumberOfRatings(Integer.parseInt(parts[13]));
            physicalBook.setFeatured(Boolean.parseBoolean(parts[14]));

            long addedDateLong = Long.parseLong(parts[15]);
            if (addedDateLong > 0) {
                physicalBook.setAddedDate(new Date(addedDateLong));
            }

            // Set PhysicalBook specific properties
            physicalBook.setPageCount(Integer.parseInt(parts[16]));
            physicalBook.setDimensions(parts[17]);
            physicalBook.setBinding(parts[18]);
            physicalBook.setWeightKg(Double.parseDouble(parts[19]));
            physicalBook.setEdition(parts[20]);
            physicalBook.setCondition(parts[21]);

            if (parts.length > 22) {
                physicalBook.setLanguage(parts[22]);
            }

            return physicalBook;
        }
        return null;
    }

    @Override
    public String toString() {
        return "PhysicalBook{" +
                "id='" + getId() + '\'' +
                ", title='" + getTitle() + '\'' +
                ", author='" + getAuthor() + '\'' +
                ", binding='" + binding + '\'' +
                ", pages=" + pageCount +
                ", condition='" + condition + '\'' +
                ", price=" + getPrice() +
                ", discounted=" + getDiscountedPrice() +
                '}';
    }
}