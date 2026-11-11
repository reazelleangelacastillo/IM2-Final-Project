<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookTrace</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="split-container">
        <div class="left-panel">
            <div class="brand-content">
                <h1><b>BookTrace</b></h1>
                <p>A LIBRARY DATABASE MANAGEMENT SYSTEM</p>
                <div class="form-box">
                    <h2>Welcome Back!</h2>
                    <p>Please select an option below to continue:</p>

                    <div class="action-button-group">
                        <a href="php/login.php" class="continue-btn primary-btn">Staff Login</a>
                        <a href="php/browse.php" class="continue-btn secondary-btn">Borrower</a>
                    </div>

                    <footer class="about-footer">
                        <hr class="footer-divider">
                        <a href="html/about.html" class="about-link-heading">
                            <i class="bi bi-info-circle"></i> About BookTrace
                        </a>
                    </footer>
                </div>
            </div>
        </div>

        <div class="right-panel">
            <div class="diagonal-images" aria-hidden="true">
                <div class="image-strip"><img src="assets/books.jpg" alt=""></div>
                <div class="image-strip"><img src="assets/books.jpg" alt=""></div>
                <div class="image-strip"><img src="assets/books.jpg" alt=""></div>
            </div>
        </div>
    </div>

</body>
</html>