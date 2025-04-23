<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Footer -->
<footer class="bg-dark text-light py-4 mt-5">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-3">
                <h5>BookVerse</h5>
                <p>Your one-stop destination for all your literary needs. Discover new worlds, one page at a time.</p>
            </div>
            <div class="col-md-4 mb-3">
                <h5>Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="<%=request.getContextPath()%>/" class="text-decoration-none text-light">Home</a></li>
                    <li><a href="<%=request.getContextPath()%>/books" class="text-decoration-none text-light">Books</a></li>
                    <li><a href="<%=request.getContextPath()%>/contact" class="text-decoration-none text-light">Contact Us</a></li>
                </ul>
            </div>
            <div class="col-md-4 mb-3">
                <h5>Contact Information</h5>
                <address>
                    <i class="fas fa-map-marker-alt me-2"></i> 123 Book Street, Reading City<br>
                    <i class="fas fa-phone me-2"></i> (123) 456-7890<br>
                    <i class="fas fa-envelope me-2"></i> info@bookverse.com
                </address>
            </div>
        </div>
        <hr>
        <div class="text-center">
            <p class="mb-0">&copy; 2023 BookVerse. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>