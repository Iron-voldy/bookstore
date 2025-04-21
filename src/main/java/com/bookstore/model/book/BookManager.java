package com.bookstore.model.book;

import java.io.*;
import java.util.*;
import javax.servlet.ServletContext;
import com.bookstore.util.QuickSort;

/**
 * BookManager class handles all book-related operations
 */
public class BookManager {
    private static final String BOOK_FILE_NAME = "books.txt";
    private BookLinkedList books;
    private ServletContext servletContext;
    private String dataFilePath;

    /**
     * Constructor without ServletContext
     */
    public BookManager() {
        this(null);
    }

    /**
     * Constructor with ServletContext
     */
    public BookManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        this.books = new BookLinkedList();
        initializeFilePath();
        loadBooks();
    }

    /**
     * Initialize the file path
     */
    private void initializeFilePath() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + BOOK_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + BOOK_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("BookManager: Using data file path: " + dataFilePath);
    }

    /**
     * Load books from file
     */
    private void loadBooks() {
        File file = new File(dataFilePath);

        // If file doesn't exist, create it
        if (!file.exists()) {
            try {
                // Ensure parent directory exists
                if (file.getParentFile() != null) {
                    file.getParentFile().mkdirs();
                }
                file.createNewFile();
                System.out.println("Created books file: " + dataFilePath);

                // Add some sample books initially
                addSampleBooks();

                return;
            } catch (IOException e) {
                System.err.println("Error creating books file: " + e.getMessage());
                e.printStackTrace();
                return;
            }
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                Book book = null;
                if (line.startsWith("BOOK,")) {
                    book = Book.fromFileString(line);
                } else if (line.startsWith("EBOOK,")) {
                    book = EBook.fromFileString(line);
                } else if (line.startsWith("PHYSICAL,")) {
                    book = PhysicalBook.fromFileString(line);
                }

                if (book != null) {
                    books.add(book);
                    System.out.println("Loaded book: " + book.getTitle());
                }
            }
            System.out.println("Total books loaded: " + books.size());
        } catch (IOException e) {
            System.err.println("Error loading books: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Save books to file
     */
    private boolean saveBooks() {
        try {
            // Ensure directory exists
            File file = new File(dataFilePath);
            if (!file.getParentFile().exists()) {
                boolean created = file.getParentFile().mkdirs();
                System.out.println("Created directory: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
                Book[] bookArray = books.toArray();
                for (Book book : bookArray) {
                    writer.write(book.toFileString());
                    writer.newLine();
                }
            }
            System.out.println("Books saved successfully to: " + dataFilePath);
            return true;
        } catch (IOException e) {
            System.err.println("Error saving books: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Add a new book
     */
    public boolean addBook(Book book) {
        try {
            // Check if ISBN already exists
            if (book.getIsbn() != null && !book.getIsbn().isEmpty()) {
                Book existingBook = getBookByIsbn(book.getIsbn());
                if (existingBook != null) {
                    System.out.println("Book with ISBN already exists: " + book.getIsbn());
                    return false;
                }
            }

            // Generate a unique ID if not provided
            if (book.getId() == null || book.getId().isEmpty()) {
                book.setId(UUID.randomUUID().toString());
            }

            // Set added date if not set
            if (book.getAddedDate() == null) {
                book.setAddedDate(new Date());
            }

            books.add(book);
            boolean saved = saveBooks();
            System.out.println("Book saved successfully: " + saved);
            return saved;
        } catch (Exception e) {
            System.err.println("Exception occurred when adding book:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Add sample books (for initial setup)
     */
    private void addSampleBooks() {
        // Sample physical books
        PhysicalBook book1 = new PhysicalBook();
        book1.setTitle("The Great Gatsby");
        book1.setAuthor("F. Scott Fitzgerald");
        book1.setIsbn("9780743273565");
        book1.setPublisher("Scribner");
        book1.setPublicationDate(new Date(70, 3, 10)); // April 10, 1970
        book1.setGenre("Fiction");
        book1.setDescription("A classic novel about the American Dream set in the Jazz Age.");
        book1.setPrice(14.99);
        book1.setQuantity(50);
        book1.setCoverImagePath("the_great_gatsby.jpg");
        book1.setPageCount(180);
        book1.setBinding("Paperback");
        book1.setWeightKg(0.3);
        book1.setDimensions("5.25 x 8 inches");
        book1.setFeatured(true);

        PhysicalBook book2 = new PhysicalBook();
        book2.setTitle("To Kill a Mockingbird");
        book2.setAuthor("Harper Lee");
        book2.setIsbn("9780061120084");
        book2.setPublisher("Harper Perennial");
        book2.setPublicationDate(new Date(60, 6, 11)); // July 11, 1960
        book2.setGenre("Fiction");
        book2.setDescription("A powerful story of racial injustice and moral growth in the American South.");
        book2.setPrice(15.99);
        book2.setQuantity(35);
        book2.setCoverImagePath("to_kill_a_mockingbird.jpg");
        book2.setPageCount(336);
        book2.setBinding("Paperback");
        book2.setWeightKg(0.4);
        book2.setDimensions("5.31 x 8 inches");

        // Sample e-books
        EBook ebook1 = new EBook();
        ebook1.setTitle("Dune");
        ebook1.setAuthor("Frank Herbert");
        ebook1.setIsbn("9780441172719");
        ebook1.setPublisher("Ace Books");
        ebook1.setPublicationDate(new Date(65, 7, 1)); // August 1, 1965
        ebook1.setGenre("Science Fiction");
        ebook1.setDescription("A science fiction masterpiece about politics, religion, and ecology on a desert planet.");
        ebook1.setPrice(12.99);
        ebook1.setQuantity(999);
        ebook1.setCoverImagePath("dune.jpg");
        ebook1.setFileFormat("EPUB");
        ebook1.setFileSizeMB(3.5);
        ebook1.setDownloadLink("/download/ebooks/dune.epub");
        ebook1.setFeatured(true);

        EBook ebook2 = new EBook();
        ebook2.setTitle("The Hobbit");
        ebook2.setAuthor("J.R.R. Tolkien");
        ebook2.setIsbn("9780547951973");
        ebook2.setPublisher("Houghton Mifflin");
        ebook2.setPublicationDate(new Date(37, 8, 21)); // September 21, 1937
        ebook2.setGenre("Fantasy");
        ebook2.setDescription("A fantasy adventure about a hobbit who embarks on a quest to reclaim a treasure guarded by a dragon.");
        ebook2.setPrice(9.99);
        ebook2.setQuantity(999);
        ebook2.setCoverImagePath("the_hobbit.jpg");
        ebook2.setFileFormat("PDF");
        ebook2.setFileSizeMB(5.2);
        ebook2.setDownloadLink("/download/ebooks/hobbit.pdf");

        // Add books to collection
        addBook(book1);
        addBook(book2);
        addBook(ebook1);
        addBook(ebook2);
    }

    /**
     * Get book by ID
     */
    public Book getBookById(String bookId) {
        return books.findById(bookId);
    }

    /**
     * Get book by ISBN
     */
    public Book getBookByIsbn(String isbn) {
        Book[] allBooks = books.toArray();
        for (Book book : allBooks) {
            if (book.getIsbn() != null && book.getIsbn().equals(isbn)) {
                return book;
            }
        }
        return null;
    }

    /**
     * Update book details
     */
    public boolean updateBook(Book updatedBook) {
        // Find the book index
        Book current = getBookById(updatedBook.getId());
        if (current != null) {
            // First, check if updated ISBN conflicts with another book
            if (updatedBook.getIsbn() != null && !updatedBook.getIsbn().equals(current.getIsbn())) {
                Book existingWithIsbn = getBookByIsbn(updatedBook.getIsbn());
                if (existingWithIsbn != null && !existingWithIsbn.getId().equals(updatedBook.getId())) {
                    System.out.println("Cannot update: Another book already has ISBN: " + updatedBook.getIsbn());
                    return false;
                }
            }

            // Remove old book and add updated one
            books.remove(current);
            books.add(updatedBook);

            return saveBooks();
        }
        return false;
    }

    /**
     * Delete book
     */
    public boolean deleteBook(String bookId) {
        Book book = getBookById(bookId);
        if (book != null) {
            boolean removed = books.remove(book);
            if (removed) {
                return saveBooks();
            }
        }
        return false;
    }

    /**
     * Get all books
     */
    public Book[] getAllBooks() {
        return books.toArray();
    }

    /**
     * Search books by title
     */
    public Book[] searchByTitle(String title) {
        return books.findByTitle(title);
    }

    /**
     * Search books by author
     */
    public Book[] searchByAuthor(String author) {
        return books.findByAuthor(author);
    }

    /**
     * Search books by genre
     */
    public Book[] searchByGenre(String genre) {
        if (genre == null || genre.trim().isEmpty()) {
            return new Book[0];
        }

        List<Book> result = new ArrayList<>();
        Book[] allBooks = books.toArray();

        for (Book book : allBooks) {
            if (book.getGenre() != null &&
                    book.getGenre().toLowerCase().contains(genre.toLowerCase())) {
                result.add(book);
            }
        }

        return result.toArray(new Book[0]);
    }

    /**
     * Get books by price range
     */
    public Book[] getBooksByPriceRange(double minPrice, double maxPrice) {
        List<Book> result = new ArrayList<>();
        Book[] allBooks = books.toArray();

        for (Book book : allBooks) {
            double price = book.getPrice();
            if (price >= minPrice && price <= maxPrice) {
                result.add(book);
            }
        }

        return result.toArray(new Book[0]);
    }

    /**
     * Get featured books
     */
    public Book[] getFeaturedBooks() {
        List<Book> result = new ArrayList<>();
        Book[] allBooks = books.toArray();

        for (Book book : allBooks) {
            if (book.isFeatured()) {
                result.add(book);
            }
        }

        return result.toArray(new Book[0]);
    }

    /**
     * Get top rated books
     */
    public Book[] getTopRatedBooks(int limit) {
        Book[] allBooks = books.toArray();

        // Sort books by average rating (descending)
        QuickSort.sort(allBooks, (b1, b2) ->
                Double.compare(b2.getAverageRating(), b1.getAverageRating()));

        // Return top N books or all if less than N
        int resultSize = Math.min(limit, allBooks.length);
        Book[] result = new Book[resultSize];
        System.arraycopy(allBooks, 0, result, 0, resultSize);

        return result;
    }

    /**
     * Get new releases (books added in the last 30 days)
     */
    public Book[] getNewReleases() {
        List<Book> result = new ArrayList<>();
        Book[] allBooks = books.toArray();

        // Calculate cutoff date (30 days ago)
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_YEAR, -30);
        Date cutoffDate = cal.getTime();

        for (Book book : allBooks) {
            if (book.getAddedDate() != null && book.getAddedDate().after(cutoffDate)) {
                result.add(book);
            }
        }

        return result.toArray(new Book[0]);
    }

    /**
     * Get all physical books
     */
    public PhysicalBook[] getPhysicalBooks() {
        List<PhysicalBook> result = new ArrayList<>();
        Book[] allBooks = books.toArray();

        for (Book book : allBooks) {
            if (book instanceof PhysicalBook) {
                result.add((PhysicalBook) book);
            }
        }

        return result.toArray(new PhysicalBook[0]);
    }

    /**
     * Get all e-books
     */
    public EBook[] getEBooks() {
        List<EBook> result = new ArrayList<>();
        Book[] allBooks = books.toArray();

        for (Book book : allBooks) {
            if (book instanceof EBook) {
                result.add((EBook) book);
            }
        }

        return result.toArray(new EBook[0]);
    }

    /**
     * Get books count
     */
    public int getBooksCount() {
        return books.size();
    }

    /**
     * Set ServletContext (can be used to update the context after initialization)
     */
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePath();
        // Reload books with the new file path
        books.clear();
        loadBooks();
    }
}