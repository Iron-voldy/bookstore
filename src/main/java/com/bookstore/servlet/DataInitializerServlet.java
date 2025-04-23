package com.bookstore.servlet;

import java.io.IOException;
import java.util.Date;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookstore.model.book.Book;
import com.bookstore.model.book.BookManager;
import com.bookstore.model.book.EBook;
import com.bookstore.model.book.PhysicalBook;

/**
 * Servlet that initializes sample data on application startup
 */
@WebServlet(urlPatterns = "/init-data", loadOnStartup = 1)
public class DataInitializerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        System.out.println("Initializing sample data...");

        // Initialize BookManager
        BookManager bookManager = new BookManager(getServletContext());

        // Check if books already exist
        if (bookManager.getBooksCount() > 0) {
            System.out.println("Sample data already exists. Skipping initialization.");
            return;
        }

        try {
            // Add sample books
            // 1. Physical Books
            PhysicalBook book1 = new PhysicalBook();
            book1.setId(UUID.randomUUID().toString());
            book1.setTitle("The Silent Patient");
            book1.setAuthor("Alex Michaelides");
            book1.setIsbn("9781250301697");
            book1.setPublisher("Celadon Books");
            book1.setPublicationDate(new Date());
            book1.setGenre("Thriller");
            book1.setDescription("Alicia Berenson's life is seemingly perfect. A famous painter married to an in-demand fashion photographer, she lives in a grand house with big windows overlooking a park in one of London's most desirable areas. One evening her husband Gabriel returns home late from a fashion shoot, and Alicia shoots him five times in the face, and then never speaks another word.");
            book1.setPrice(14.99);
            book1.setQuantity(15);
            book1.setCoverImagePath("default_cover.jpg");
            book1.setFeatured(true);
            book1.setAverageRating(4.5);
            book1.setNumberOfRatings(120);
            book1.setPageCount(325);
            book1.setDimensions("6 x 9 inches");
            book1.setBinding("Hardcover");
            book1.setWeightKg(0.5);
            book1.setEdition("1st Edition");
            book1.setCondition("New");
            book1.setLanguage("English");
            bookManager.addBook(book1);

            PhysicalBook book2 = new PhysicalBook();
            book2.setId(UUID.randomUUID().toString());
            book2.setTitle("Educated");
            book2.setAuthor("Tara Westover");
            book2.setIsbn("9780399590504");
            book2.setPublisher("Random House");
            book2.setPublicationDate(new Date());
            book2.setGenre("Memoir");
            book2.setDescription("Tara Westover was seventeen the first time she set foot in a classroom. Born to survivalists in the mountains of Idaho, she prepared for the end of the world by stockpiling home-canned peaches and sleeping with her 'head-for-the-hills' bag. The family was so isolated from mainstream society that there was no one to ensure the children received an education, and no one to intervene when one of Tara's older brothers became violent.");
            book2.setPrice(12.99);
            book2.setQuantity(8);
            book2.setCoverImagePath("default_cover.jpg");
            book2.setFeatured(true);
            book2.setAverageRating(4.9);
            book2.setNumberOfRatings(200);
            book2.setPageCount(352);
            book2.setDimensions("5.5 x 8.5 inches");
            book2.setBinding("Paperback");
            book2.setWeightKg(0.4);
            book2.setEdition("1st Edition");
            book2.setCondition("New");
            book2.setLanguage("English");
            bookManager.addBook(book2);

            // 2. E-Books
            EBook ebook1 = new EBook();
            ebook1.setId(UUID.randomUUID().toString());
            ebook1.setTitle("Where the Crawdads Sing");
            ebook1.setAuthor("Delia Owens");
            ebook1.setIsbn("9780735219113");
            ebook1.setPublisher("G.P. Putnam's Sons");
            ebook1.setPublicationDate(new Date());
            ebook1.setGenre("Fiction");
            ebook1.setDescription("For years, rumors of the 'Marsh Girl' have haunted Barkley Cove, a quiet town on the North Carolina coast. So in late 1969, when handsome Chase Andrews is found dead, the locals immediately suspect Kya Clark, the so-called Marsh Girl. But Kya is not what they say. Sensitive and intelligent, she has survived for years alone in the marsh that she calls home, finding friends in the gulls and lessons in the sand.");
            ebook1.setPrice(15.99);
            ebook1.setQuantity(1000);
            ebook1.setCoverImagePath("default_cover.jpg");
            ebook1.setFeatured(true);
            ebook1.setAverageRating(4.0);
            ebook1.setNumberOfRatings(150);
            ebook1.setFileFormat("EPUB");
            ebook1.setFileSizeMB(2.5);
            ebook1.setDrm(true);
            ebook1.setDownloadLink("/downloads/ebooks/crawdads.epub");
            ebook1.setWatermarked(true);
            bookManager.addBook(ebook1);

            EBook ebook2 = new EBook();
            ebook2.setId(UUID.randomUUID().toString());
            ebook2.setTitle("Project Hail Mary");
            ebook2.setAuthor("Andy Weir");
            ebook2.setIsbn("9780593135204");
            ebook2.setPublisher("Ballantine Books");
            ebook2.setPublicationDate(new Date());
            ebook2.setGenre("Science Fiction");
            ebook2.setDescription("Ryland Grace is the sole survivor on a desperate, last-chance mission—and if he fails, humanity and the Earth itself will perish. Except that right now, he doesn't know that. He can't even remember his own name, let alone the nature of his assignment or how to complete it.");
            ebook2.setPrice(13.99);
            ebook2.setQuantity(1000);
            ebook2.setCoverImagePath("default_cover.jpg");
            ebook2.setFeatured(false);
            ebook2.setAverageRating(4.8);
            ebook2.setNumberOfRatings(90);
            ebook2.setFileFormat("PDF");
            ebook2.setFileSizeMB(3.2);
            ebook2.setDrm(true);
            ebook2.setDownloadLink("/downloads/ebooks/hailmary.pdf");
            ebook2.setWatermarked(true);
            bookManager.addBook(ebook2);

            // 3. Regular Books
            Book book3 = new Book();
            book3.setId(UUID.randomUUID().toString());
            book3.setTitle("The Midnight Library");
            book3.setAuthor("Matt Haig");
            book3.setIsbn("9780525559474");
            book3.setPublisher("Viking");
            book3.setPublicationDate(new Date());
            book3.setGenre("Fiction");
            book3.setDescription("Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived. To see how things would be if you had made other choices... Would you have done anything different, if you had the chance to undo your regrets?");
            book3.setPrice(11.99);
            book3.setQuantity(20);
            book3.setCoverImagePath("default_cover.jpg");
            book3.setFeatured(false);
            book3.setAverageRating(4.2);
            book3.setNumberOfRatings(110);
            bookManager.addBook(book3);

            Book book4 = new Book();
            book4.setId(UUID.randomUUID().toString());
            book4.setTitle("Atomic Habits");
            book4.setAuthor("James Clear");
            book4.setIsbn("9780735211292");
            book4.setPublisher("Avery");
            book4.setPublicationDate(new Date());
            book4.setGenre("Self-Help");
            book4.setDescription("No matter your goals, Atomic Habits offers a proven framework for improving--every day. James Clear, one of the world's leading experts on habit formation, reveals practical strategies that will teach you exactly how to form good habits, break bad ones, and master the tiny behaviors that lead to remarkable results.");
            book4.setPrice(16.99);
            book4.setQuantity(12);
            book4.setCoverImagePath("default_cover.jpg");
            book4.setFeatured(false);
            book4.setAverageRating(4.7);
            book4.setNumberOfRatings(180);
            bookManager.addBook(book4);

            // Add a few more books with different genres
            PhysicalBook book5 = new PhysicalBook();
            book5.setId(UUID.randomUUID().toString());
            book5.setTitle("The Great Gatsby");
            book5.setAuthor("F. Scott Fitzgerald");
            book5.setIsbn("9780743273565");
            book5.setPublisher("Scribner");
            book5.setPublicationDate(new Date());
            book5.setGenre("Classic");
            book5.setDescription("The Great Gatsby, F. Scott Fitzgerald's third book, stands as the supreme achievement of his career. This exemplary novel of the Jazz Age has been acclaimed by generations of readers.");
            book5.setPrice(9.99);
            book5.setQuantity(30);
            book5.setCoverImagePath("default_cover.jpg");
            book5.setFeatured(false);
            book5.setAverageRating(4.3);
            book5.setNumberOfRatings(300);
            book5.setPageCount(180);
            book5.setDimensions("5 x 8 inches");
            book5.setBinding("Paperback");
            book5.setWeightKg(0.3);
            book5.setEdition("Classic Edition");
            book5.setCondition("New");
            book5.setLanguage("English");
            bookManager.addBook(book5);

            EBook ebook3 = new EBook();
            ebook3.setId(UUID.randomUUID().toString());
            ebook3.setTitle("To Kill a Mockingbird");
            ebook3.setAuthor("Harper Lee");
            ebook3.setIsbn("9780061120084");
            ebook3.setPublisher("Harper Perennial");
            ebook3.setPublicationDate(new Date());
            ebook3.setGenre("Classic");
            ebook3.setDescription("The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it. 'To Kill A Mockingbird' became both an instant bestseller and a critical success when it was first published in 1960.");
            ebook3.setPrice(8.99);
            ebook3.setQuantity(1000);
            ebook3.setCoverImagePath("default_cover.jpg");
            ebook3.setFeatured(false);
            ebook3.setAverageRating(4.8);
            ebook3.setNumberOfRatings(500);
            ebook3.setFileFormat("EPUB");
            ebook3.setFileSizeMB(1.8);
            ebook3.setDrm(false);
            ebook3.setDownloadLink("/downloads/ebooks/mockingbird.epub");
            ebook3.setWatermarked(false);
            bookManager.addBook(ebook3);

            System.out.println("Sample data initialized successfully!");

        } catch (Exception e) {
            System.err.println("Error initializing sample data: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // This servlet doesn't handle GET requests directly
        // but we'll provide some feedback if someone navigates to it
        response.setContentType("text/html");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h2>Data Initialization Servlet</h2>");
        response.getWriter().println("<p>The sample data has been initialized during application startup.</p>");
        response.getWriter().println("<p><a href='" + request.getContextPath() + "/'>Go to Home Page</a></p>");
        response.getWriter().println("</body></html>");
    }
}