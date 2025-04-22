package com.bookstore.servlet.book;

import java.io.IOException;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.book.EBook;
import com.bookstore.model.book.PhysicalBook;
import com.bookstore.util.QuickSort;

/**
 * Servlet to handle book listing with filtering, sorting, and pagination.
 * Maps to /books URL
 */
@WebServlet("/books")
public class BookListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - displays the book catalog with filters, sorting, and pagination
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get parameters for filtering and sorting
        String searchQuery = request.getParameter("search");
        String genreFilter = request.getParameter("genre");
        String typeFilter = request.getParameter("type");
        String sortBy = request.getParameter("sort");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String pageStr = request.getParameter("page");

        // Get BookManager
        BookManager bookManager = new BookManager(getServletContext());

        // Start with all books
        Book[] allBooks = bookManager.getAllBooks();
        Book[] filteredBooks = allBooks;

        // Apply search filter if provided
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            Book[] titleResults = bookManager.searchByTitle(searchQuery);
            Book[] authorResults = bookManager.searchByAuthor(searchQuery);

            // Combine results from title and author searches, removing duplicates
            Map<String, Book> resultMap = new HashMap<>();

            if (titleResults != null) {
                for (Book book : titleResults) {
                    resultMap.put(book.getId(), book);
                }
            }

            if (authorResults != null) {
                for (Book book : authorResults) {
                    resultMap.put(book.getId(), book);
                }
            }

            filteredBooks = resultMap.values().toArray(new Book[0]);
        }

        // Apply genre filter
        if (genreFilter != null && !genreFilter.trim().isEmpty()) {
            filteredBooks = bookManager.searchByGenre(genreFilter);
        }

        // Apply type filter
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            java.util.List<Book> typeFiltered = new java.util.ArrayList<>();

            for (Book book : filteredBooks) {
                if ("ebook".equals(typeFilter) && book instanceof EBook) {
                    typeFiltered.add(book);
                } else if ("physical".equals(typeFilter) && book instanceof PhysicalBook) {
                    typeFiltered.add(book);
                }
            }

            filteredBooks = typeFiltered.toArray(new Book[0]);
        }

        // Apply price range filter
        if ((minPriceStr != null && !minPriceStr.trim().isEmpty()) ||
                (maxPriceStr != null && !maxPriceStr.trim().isEmpty())) {

            double minPrice = 0.0;
            double maxPrice = Double.MAX_VALUE;

            if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                try {
                    minPrice = Double.parseDouble(minPriceStr);
                } catch (NumberFormatException e) {
                    // Use default
                }
            }

            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                try {
                    maxPrice = Double.parseDouble(maxPriceStr);
                } catch (NumberFormatException e) {
                    // Use default
                }
            }

            filteredBooks = bookManager.getBooksByPriceRange(minPrice, maxPrice);
        }

        // Apply sorting using QuickSort
        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy = "titleAsc"; // Default sort
        }

        Comparator<Book> comparator = null;

        switch (sortBy) {
            case "titleAsc":
                comparator = (b1, b2) -> b1.getTitle().compareToIgnoreCase(b2.getTitle());
                break;
            case "titleDesc":
                comparator = (b1, b2) -> b2.getTitle().compareToIgnoreCase(b1.getTitle());
                break;
            case "priceAsc":
                comparator = (b1, b2) -> Double.compare(b1.getPrice(), b2.getPrice());
                break;
            case "priceDesc":
                comparator = (b1, b2) -> Double.compare(b2.getPrice(), b1.getPrice());
                break;
            case "ratingDesc":
                comparator = (b1, b2) -> Double.compare(b2.getAverageRating(), b1.getAverageRating());
                break;
            case "newest":
                comparator = (b1, b2) -> b2.getAddedDate().compareTo(b1.getAddedDate());
                break;
            default:
                comparator = (b1, b2) -> b1.getTitle().compareToIgnoreCase(b2.getTitle());
        }

        // Use QuickSort for efficient sorting
        QuickSort.sort(filteredBooks, comparator);

        // Apply pagination
        int booksPerPage = 12;
        int totalBooks = filteredBooks.length;
        int totalPages = (int) Math.ceil((double) totalBooks / booksPerPage);

        int currentPage = 1;
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) {
                    currentPage = 1;
                }
                if (currentPage > totalPages && totalPages > 0) {
                    currentPage = totalPages;
                }
            } catch (NumberFormatException e) {
                // Use default
            }
        }

        // Calculate start and end indices for current page
        int startIndex = (currentPage - 1) * booksPerPage;
        int endIndex = Math.min(startIndex + booksPerPage, totalBooks);

        // Get books for current page
        Book[] currentPageBooks = new Book[0];
        if (totalBooks > 0) {
            currentPageBooks = Arrays.copyOfRange(filteredBooks, startIndex, endIndex);
        }

        // Collect all genres for the filter sidebar
        java.util.Set<String> genres = new java.util.TreeSet<>();
        for (Book book : allBooks) {
            if (book.getGenre() != null && !book.getGenre().isEmpty()) {
                genres.add(book.getGenre());
            }
        }

        // Set attributes in request
        request.setAttribute("allBooks", allBooks);
        request.setAttribute("filteredBooks", filteredBooks);
        request.setAttribute("currentPageBooks", currentPageBooks);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("genres", genres.toArray(new String[0]));

        // Set filter parameters in request
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("genreFilter", genreFilter);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("minPrice", minPriceStr);
        request.setAttribute("maxPrice", maxPriceStr);

        // Forward to the book catalog page
        request.getRequestDispatcher("/book/book-catalog.jsp").forward(request, response);
    }
}