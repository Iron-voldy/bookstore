package com.bookstore.model.book;

import java.util.Date;

/**
 * EBook class representing electronic books with additional attributes
 */
public class EBook extends Book {
    private String fileFormat; // PDF, EPUB, MOBI, etc.
    private double fileSizeMB;
    private boolean drm; // Digital Rights Management
    private String downloadLink;
    private boolean watermarked;

    /**
     * Constructor with all fields
     */
    public EBook(String id, String title, String author, String isbn, String publisher,
                 Date publicationDate, String genre, String description, double price,
                 int quantity, String coverImagePath, double averageRating,
                 int numberOfRatings, boolean featured, Date addedDate,
                 String fileFormat, double fileSizeMB, boolean drm, String downloadLink,
                 boolean watermarked) {
        super(id, title, author, isbn, publisher, publicationDate, genre, description,
                price, quantity, coverImagePath, averageRating, numberOfRatings, featured, addedDate);
        this.fileFormat = fileFormat;
        this.fileSizeMB = fileSizeMB;
        this.drm = drm;
        this.downloadLink = downloadLink;
        this.watermarked = watermarked;
    }

    /**
     * Constructor with essential fields
     */
    public EBook(String title, String author, String isbn, String publisher,
                 Date publicationDate, String genre, String description, double price,
                 int quantity, String fileFormat, double fileSizeMB) {
        super(title, author, isbn, publisher, publicationDate, genre, description, price, quantity);
        this.fileFormat = fileFormat;
        this.fileSizeMB = fileSizeMB;
        this.drm = false;
        this.downloadLink = "";
        this.watermarked = false;
    }

    /**
     * Default constructor
     */
    public EBook() {
        super();
        this.fileFormat = "PDF";
        this.fileSizeMB = 0.0;
        this.drm = false;
        this.downloadLink = "";
        this.watermarked = false;
    }

    // Getters and Setters
    public String getFileFormat() {
        return fileFormat;
    }

    public void setFileFormat(String fileFormat) {
        this.fileFormat = fileFormat;
    }

    public double getFileSizeMB() {
        return fileSizeMB;
    }

    public void setFileSizeMB(double fileSizeMB) {
        this.fileSizeMB = fileSizeMB;
    }

    public boolean isDrm() {
        return drm;
    }

    public void setDrm(boolean drm) {
        this.drm = drm;
    }

    public String getDownloadLink() {
        return downloadLink;
    }

    public void setDownloadLink(String downloadLink) {
        this.downloadLink = downloadLink;
    }

    public boolean isWatermarked() {
        return watermarked;
    }

    public void setWatermarked(boolean watermarked) {
        this.watermarked = watermarked;
    }

    /**
     * EBooks often have a 15% discount compared to physical books
     */
    @Override
    public double getDiscountedPrice() {
        return getPrice() * 0.85; // 15% discount
    }

    /**
     * EBooks are always in stock since they can be downloaded infinitely
     */
    @Override
    public boolean isInStock() {
        return true;
    }

    /**
     * Generate download link with user information for watermarking/tracking
     * @param userId the user ID
     * @return personalized download link
     */
    public String generatePersonalizedDownloadLink(String userId) {
        if (downloadLink == null || downloadLink.isEmpty()) {
            return "";
        }

        return downloadLink + "?uid=" + userId + "&book=" + getId() + "&ts=" + System.currentTimeMillis();
    }

    /**
     * Convert eBook to string representation for file storage
     */
    @Override
    public String toFileString() {
        StringBuilder sb = new StringBuilder();
        sb.append("EBOOK,");
        sb.append(super.toFileString().substring(5)); // Remove "BOOK," prefix
        sb.append(",").append(fileFormat);
        sb.append(",").append(fileSizeMB);
        sb.append(",").append(drm);
        sb.append(",").append(downloadLink);
        sb.append(",").append(watermarked);
        return sb.toString();
    }

    /**
     * Create eBook from string representation (from file)
     */
    public static EBook fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 20 && parts[0].equals("EBOOK")) {
            EBook ebook = new EBook();

            // Set base Book properties
            ebook.setId(parts[1]);
            ebook.setTitle(parts[2]);
            ebook.setAuthor(parts[3]);
            ebook.setIsbn(parts[4]);
            ebook.setPublisher(parts[5]);

            long pubDateLong = Long.parseLong(parts[6]);
            if (pubDateLong > 0) {
                ebook.setPublicationDate(new Date(pubDateLong));
            }

            ebook.setGenre(parts[7]);
            ebook.setDescription(parts[8].replace("{{COMMA}}", ","));
            ebook.setPrice(Double.parseDouble(parts[9]));
            ebook.setQuantity(Integer.parseInt(parts[10]));
            ebook.setCoverImagePath(parts[11]);
            ebook.setAverageRating(Double.parseDouble(parts[12]));
            ebook.setNumberOfRatings(Integer.parseInt(parts[13]));
            ebook.setFeatured(Boolean.parseBoolean(parts[14]));

            long addedDateLong = Long.parseLong(parts[15]);
            if (addedDateLong > 0) {
                ebook.setAddedDate(new Date(addedDateLong));
            }

            // Set EBook specific properties
            ebook.setFileFormat(parts[16]);
            ebook.setFileSizeMB(Double.parseDouble(parts[17]));
            ebook.setDrm(Boolean.parseBoolean(parts[18]));
            ebook.setDownloadLink(parts[19]);

            if (parts.length > 20) {
                ebook.setWatermarked(Boolean.parseBoolean(parts[20]));
            }

            return ebook;
        }
        return null;
    }

    @Override
    public String toString() {
        return "EBook{" +
                "id='" + getId() + '\'' +
                ", title='" + getTitle() + '\'' +
                ", author='" + getAuthor() + '\'' +
                ", format='" + fileFormat + '\'' +
                ", size=" + fileSizeMB + "MB" +
                ", price=" + getPrice() +
                ", discounted=" + getDiscountedPrice() +
                '}';
    }
}