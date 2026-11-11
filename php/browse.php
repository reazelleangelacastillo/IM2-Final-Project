<?php
$host = "localhost";
$user = "root";
$password = "";
$database = "queryshelf";

$conn = mysqli_connect($host, $user, $password, $database);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$sql = "SELECT
            pub_id,
            title,
            subtitle,
            language_used,
            shelf_location,
            pages
        FROM publication
        ORDER BY pub_id ASC";

$result = mysqli_query($conn, $sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Books | BookTrace</title>

    <link rel="stylesheet" href="../css/browse.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>

<header class="topbar">
    <div class="logo-section">
        <p class="eyebrow">Browse Library Books</p>
        <h1>BookTrace</h1>
    </div>

    <div class="header-actions">
        <a href="../index.php" class="back-btn">
            <i class="bi bi-arrow-left"></i>
            Back
        </a>
    </div>
</header>

<main class="container">

    <div class="search-box">
        <input type="text" id="searchInput" placeholder="Search books by title...">
        <i class="bi bi-search"></i>
    </div>

    <div class="book-grid" id="bookGrid">

        <?php
        if (mysqli_num_rows($result) > 0) {
            while ($row = mysqli_fetch_assoc($result)) {
        ?>

        <div class="book-card">

            <div class="book-icon">
                <i class="bi bi-book-half"></i>
            </div>

            <h2>
                <?php echo htmlspecialchars($row['title']); ?>
            </h2>

            <p class="subtitle">
                <?php echo htmlspecialchars($row['subtitle']); ?>
            </p>

            <div class="book-info">
                <span>
                    <strong>Book ID:</strong>
                    <?php echo htmlspecialchars($row['pub_id']); ?>
                </span>

                <span>
                    <strong>Language:</strong>
                    <?php echo htmlspecialchars($row['language_used']); ?>
                </span>

                <span>
                    <strong>Shelf:</strong>
                    <?php echo htmlspecialchars($row['shelf_location']); ?>
                </span>

                <span>
                    <strong>Pages:</strong>
                    <?php echo htmlspecialchars($row['pages']); ?>
                </span>
            </div>

        </div>

        <?php
            }
        } else {
            echo "<p>No books found.</p>";
        }
        ?>

    </div>

</main>

<script>
const searchInput = document.getElementById('searchInput');
const cards = document.querySelectorAll('.book-card');

searchInput.addEventListener('keyup', function () {

    const value = searchInput.value.toLowerCase();

    cards.forEach(card => {

        const title = card.querySelector('h2').textContent.toLowerCase();

        if (title.includes(value)) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
});
</script>

</body>
</html>