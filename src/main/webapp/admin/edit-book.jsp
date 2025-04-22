<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.bookstore.model.book.Book" %>
<%@ page import="com.bookstore.model.book.EBook" %>
<%@ page import="com.bookstore.model.book.PhysicalBook" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book - BookVerse Admin</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS - using similar styling as the main site -->
    <style>
        :root {
            --primary-dark: #121212;
            --secondary-dark: #1e1e1e;
            --accent-color: #8a5cf5;
            --accent-hover: #6e46c9;
            --text-primary: #f5f5f5;
            --text-secondary: #b0b0b0;
            --danger-color: #d64045;
            --success-color: #4caf50;
            --warning-color: #ff9800;
            --card-bg: #252525;
            --border-color: #333333;
        }

        body {
            background-color: var(--primary-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar {
            background-color: var(--secondary-dark);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-weight: bold;
            color: var(--accent-color) !important;
        }

        .nav-link {
            color: var(--text-primary) !important;
            margin: 0 10px;
        }

        .nav-link.active {
            color: var(--accent-color) !important;
            font-weight: 500;
        }

        .btn-accent {
            background-color: var(--accent-color);
            color: white;
            border: none;
            transition: all 0.3s;
        }

        .btn-accent:hover {
            background-color: var(--accent-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(138, 92, 245, 0.3);
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .card-header {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            font-weight: 600;
        }

        .form-control, .form-select {
            background-color: var(--secondary-dark);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        .form-control:focus, .form-select:focus {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.25rem rgba(138, 92, 245, 0.25);
        }

        .form-label {
            color: var(--text-primary);
        }

        .required-field::after {
            content: " *";
            color: var(--danger-color);
        }

        .alert-custom {
            background-color: var(--secondary-dark);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .alert-success {
            border-left: 4px solid var(--success-color);
        }

        .alert-danger {
            border-left: 4px solid var(--danger-color);
        }

        .preview-container {
            width: 200px;
            height: 300px;
            border: 2px dashed var(--border-color);
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .preview-container img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .book-type-container {
            display: none;
        }
    </style>
</head>
<body>
    <%
        // Get the book from request attribute
        Book book = (Book)request.getAttribute("book");
        String bookType = (String)request.getAttribute("bookType");

        if (book == null) {
            // Redirect to book management if no book is provided
            response.sendRedirect(request.getContextPath() + "/admin/manage-books.jsp");
            return;
        }

        // Extract specific book type details
        PhysicalBook physicalBook = null;
        EBook ebook = null;

        if (book instanceof PhysicalBook) {
            physicalBook = (PhysicalBook)book;
        } else if (book instanceof EBook) {
            ebook = (EBook)book;
        }

        // Format publication date for input field
        String publicationDateStr = "";
        if (book.getPublicationDate() != null) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            publicationDateStr = dateFormat.format(book.getPublicationDate());
        }

        // Get cover image URL
        String coverPath = request.getContextPath() + "/book-covers/" + book.getCoverImagePath();
        if (book.getCoverImagePath() == null || book.getCoverImagePath().equals("default_cover.jpg")) {
            coverPath = request.getContextPath() + "/book-covers/default_cover.jpg";
        }
    %>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/">
                <i class="fas fa-book-open me-2"></i>BookVerse Admin
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/dashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=request.getContextPath()%>/admin/manage-books.jsp">Books</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/manage-users.jsp">Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/manage-orders.jsp">Orders</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/logout">
                            <i class="fas fa-sign-out-alt me-1"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-custom alert-success alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-custom alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Page Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-edit me-2"></i> Edit Book</h2>
            <a href="<%=request.getContextPath()%>/admin/manage-books.jsp" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-1"></i> Back to Book List
            </a>
        </div>

        <!-- Edit Book Form -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Book Information</h5>
            </div>
            <div class="card-body">
                <form action="<%=request.getContextPath()%>/admin/update-book" method="post" enctype="multipart/form-data" id="editBookForm">
                    <!-- Hidden book ID -->
                    <input type="hidden" name="bookId" value="<%= book.getId() %>">

                    <div class="row">
                        <!-- Book Type Selection -->
                        <div class="col-md-12 mb-3">
                            <label for="bookType" class="form-label required-field">Book Type</label>
                            <select class="form-select" id="bookType" name="bookType" required>
                                <option value="regular" <%= "regular".equals(bookType) ? "selected" : "" %>>Regular Book</option>
                                <option value="physical" <%= "physical".equals(bookType) ? "selected" : "" %>>Physical Book</option>
                                <option value="ebook" <%= "ebook".equals(bookType) ? "selected" : "" %>>E-Book</option>
                            </select>
                        </div>

                        <!-- Left Column - Basic Info -->
                        <div class="col-md-8">
                            <div class="row">
                                <!-- Title -->
                                <div class="col-md-12 mb-3">
                                    <label for="title" class="form-label required-field">Title</label>
                                    <input type="text" class="form-control" id="title" name="title" value="<%= book.getTitle() %>" required>
                                </div>

                                <!-- Author -->
                                <div class="col-md-6 mb-3">
                                    <label for="author" class="form-label required-field">Author</label>
                                    <input type="text" class="form-control" id="author" name="author" value="<%= book.getAuthor() %>" required>
                                </div>

                                <!-- ISBN -->
                                <div class="col-md-6 mb-3">
                                    <label for="isbn" class="form-label required-field">ISBN</label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" value="<%= book.getIsbn() %>" required>
                                    <small class="text-muted">Enter ISBN-10 or ISBN-13 format</small>
                                </div>

                                <!-- Publisher -->
                                <div class="col-md-6 mb-3">
                                    <label for="publisher" class="form-label">Publisher</label>
                                    <input type="text" class="form-control" id="publisher" name="publisher" value="<%= book.getPublisher() != null ? book.getPublisher() : "" %>">
                                </div>

                                <!-- Publication Date -->
                                <div class="col-md-6 mb-3">
                                    <label for="publicationDate" class="form-label">Publication Date</label>
                                    <input type="date" class="form-control" id="publicationDate" name="publicationDate" value="<%= publicationDateStr %>">
                                </div>

                                <!-- Genre -->
                                <div class="col-md-6 mb-3">
                                    <label for="genre" class="form-label">Genre</label>
                                    <input type="text" class="form-control" id="genre" name="genre" value="<%= book.getGenre() != null ? book.getGenre() : "" %>">
                                </div>

                                <!-- Price -->
                                <div class="col-md-3 mb-3">
                                    <label for="price" class="form-label required-field">Price</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" value="<%= book.getPrice() %>" required>
                                    </div>
                                </div>

                                <!-- Quantity -->
                                <div class="col-md-3 mb-3">
                                    <label for="quantity" class="form-label required-field">Quantity</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" min="0" value="<%= book.getQuantity() %>" required>
                                </div>

                                <!-- Featured -->
                                <div class="col-md-12 mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="featured" name="featured" <%= book.isFeatured() ? "checked" : "" %>>
                                        <label class="form-check-label" for="featured">
                                            Feature this book on the homepage
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column - Cover Image Preview -->
                        <div class="col-md-4 mb-4">
                            <div class="mb-3">
                                <label for="coverImage" class="form-label">Cover Image</label>
                                <input type="file" class="form-control" id="coverImage" name="coverImage" accept="image/*" onchange="previewImage(this)">
                                <small class="text-muted">Max size: 5MB. Accepted formats: JPG, PNG, GIF</small>
                                <small class="d-block mt-1 text-muted">Leave empty to keep the current image</small>
                            </div>
                            <div class="preview-container" id="imagePreview">
                                <img src="<%= coverPath %>" alt="<%= book.getTitle() %> Cover">
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="col-md-12 mb-4">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="5"><%= book.getDescription() != null ? book.getDescription() : "" %></textarea>
                        </div>

                        <!-- Physical Book Specific Fields -->
                        <div class="book-type-container" id="physicalBookFields" style="<%= "physical".equals(bookType) ? "display: block;" : "" %>">
                            <hr>
                            <h5 class="mb-3">Physical Book Details</h5>
                            <div class="row">
                                <div class="col-md-3 mb-3">
                                    <label for="pageCount" class="form-label">Page Count</label>
                                    <input type="number" class="form-control" id="pageCount" name="pageCount" min="1"
                                        value="<%= physicalBook != null ? physicalBook.getPageCount() : "" %>">
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label for="dimensions" class="form-label">Dimensions</label>
                                    <input type="text" class="form-control" id="dimensions" name="dimensions" placeholder="6 x 9 inches"
                                        value="<%= physicalBook != null ? physicalBook.getDimensions() : "" %>">
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label for="weight" class="form-label">Weight (kg)</label>
                                    <input type="number" class="form-control" id="weight" name="weight" step="0.01" min="0"
                                        value="<%= physicalBook != null ? physicalBook.getWeightKg() : "" %>">
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label for="binding" class="form-label">Binding</label>
                                    <select class="form-select" id="binding" name="binding">
                                        <option value="">Select Binding</option>
                                        <option value="Hardcover" <%= physicalBook != null && "Hardcover".equals(physicalBook.getBinding()) ? "selected" : "" %>>Hardcover</option>
                                        <option value="Paperback" <%= physicalBook != null && "Paperback".equals(physicalBook.getBinding()) ? "selected" : "" %>>Paperback</option>
                                        <option value="Spiral-bound" <%= physicalBook != null && "Spiral-bound".equals(physicalBook.getBinding()) ? "selected" : "" %>>Spiral-bound</option>
                                        <option value="Leather-bound" <%= physicalBook != null && "Leather-bound".equals(physicalBook.getBinding()) ? "selected" : "" %>>Leather-bound</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="edition" class="form-label">Edition</label>
                                    <input type="text" class="form-control" id="edition" name="edition" placeholder="1st Edition"
                                        value="<%= physicalBook != null ? physicalBook.getEdition() : "" %>">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="condition" class="form-label">Condition</label>
                                    <select class="form-select" id="condition" name="condition">
                                        <option value="New" <%= physicalBook != null && "New".equals(physicalBook.getCondition()) ? "selected" : "" %>>New</option>
                                        <option value="Used - Like New" <%= physicalBook != null && "Used - Like New".equals(physicalBook.getCondition()) ? "selected" : "" %>>Used - Like New</option>
                                        <option value="Used - Very Good" <%= physicalBook != null && "Used - Very Good".equals(physicalBook.getCondition()) ? "selected" : "" %>>Used - Very Good</option>
                                        <option value="Used - Good" <%= physicalBook != null && "Used - Good".equals(physicalBook.getCondition()) ? "selected" : "" %>>Used - Good</option>
                                        <option value="Used - Acceptable" <%= physicalBook != null && "Used - Acceptable".equals(physicalBook.getCondition()) ? "selected" : "" %>>Used - Acceptable</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="language" class="form-label">Language</label>
                                    <input type="text" class="form-control" id="language" name="language"
                                        value="<%= physicalBook != null ? physicalBook.getLanguage() : "English" %>">
                                </div>
                            </div>
                        </div>

                        <!-- E-Book Specific Fields -->
                        <div class="book-type-container" id="ebookFields" style="<%= "ebook".equals(bookType) ? "display: block;" : "" %>">
                            <hr>
                            <h5 class="mb-3">E-Book Details</h5>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="fileFormat" class="form-label">File Format</label>
                                    <select class="form-select" id="fileFormat" name="fileFormat">
                                        <option value="PDF" <%= ebook != null && "PDF".equals(ebook.getFileFormat()) ? "selected" : "" %>>PDF</option>
                                        <option value="EPUB" <%= ebook != null && "EPUB".equals(ebook.getFileFormat()) ? "selected" : "" %>>EPUB</option>
                                        <option value="MOBI" <%= ebook != null && "MOBI".equals(ebook.getFileFormat()) ? "selected" : "" %>>MOBI</option>
                                        <option value="AZW" <%= ebook != null && "AZW".equals(ebook.getFileFormat()) ? "selected" : "" %>>AZW (Kindle)</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="fileSize" class="form-label">File Size (MB)</label>
                                    <input type="number" class="form-control" id="fileSize" name="fileSize" step="0.1" min="0"
                                        value="<%= ebook != null ? ebook.getFileSizeMB() : "" %>">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <div class="form-check mt-4">
                                        <input class="form-check-input" type="checkbox" id="drmProtected" name="drmProtected"
                                            <%= ebook != null && ebook.isDrm() ? "checked" : "" %>>
                                        <label class="form-check-label" for="drmProtected">
                                            DRM Protected
                                        </label>
                                    </div>
                                </div>
                                <div class="col-md-8 mb-3">
                                    <label for="downloadLink" class="form-label">Download Link</label>
                                    <input type="text" class="form-control" id="downloadLink" name="downloadLink"
                                        value="<%= ebook != null ? ebook.getDownloadLink() : "" %>">
                                    <small class="text-muted">Internal link for file download</small>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <div class="form-check mt-4">
                                        <input class="form-check-input" type="checkbox" id="watermarked" name="watermarked"
                                            <%= ebook != null && ebook.isWatermarked() ? "checked" : "" %>>
                                        <label class="form-check-label" for="watermarked">
                                            Watermarked
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <div class="col-12 mt-4">
                            <hr>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-accent btn-lg">
                                    <i class="fas fa-save me-2"></i> Update Book
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JavaScript -->
    <script>
        // Toggle book type specific fields
        document.getElementById('bookType').addEventListener('change', function() {
            const bookType = this.value;
            const physicalFields = document.getElementById('physicalBookFields');
            const ebookFields = document.getElementById('ebookFields');

            // Hide all type-specific fields first
            physicalFields.style.display = 'none';
            ebookFields.style.display = 'none';

            // Show fields based on selected book type
            if (bookType === 'physical') {
                physicalFields.style.display = 'block';
            } else if (bookType === 'ebook') {
                ebookFields.style.display = 'block';
            }
        });

        // Image preview function
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');

            if (input.files && input.files[0]) {
                const reader = new FileReader();

                reader.onload = function(e) {
                    preview.innerHTML = `<img src="${e.target.result}" alt="Book Cover Preview">`;
                };

                reader.readAsDataURL(input.files[0]);
            }
        }

        // Form validation
        document.getElementById('editBookForm').addEventListener('submit', function(event) {
            const bookType = document.getElementById('bookType').value;
            const isValid = validateForm(bookType);

            if (!isValid) {
                event.preventDefault();
            }
        });

        function validateForm(bookType) {
            let isValid = true;

            // Validate ISBN format
            const isbn = document.getElementById('isbn').value;
            const isbnRegex = /^(?:ISBN(?:-1[03])?:?\s*)?(?=[0-9X]{10}$|(?=(?:[0-9]+[-\s]){3})[-\s0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[-\s]){4})[-\s0-9]{17}$)(?:97[89][-\s]?)?[0-9]{1,5}[-\s]?[0-9]+[-\s]?[0-9]+[-\s]?[0-9X]$/;

            if (!isbnRegex.test(isbn)) {
                alert('Please enter a valid ISBN format');
                isValid = false;
            }

            // Validate file size if a new file is selected
            const coverImage = document.getElementById('coverImage');
            if (coverImage.files.length > 0) {
                const fileSize = coverImage.files[0].size / 1024 / 1024; // in MB
                if (fileSize > 5) {
                    alert('Cover image size should not exceed 5MB');
                    isValid = false;
                }
            }

            return isValid;
        }
    </script>
</body>
</html>