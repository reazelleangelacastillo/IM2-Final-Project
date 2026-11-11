<?php
$host = "localhost";
$user = "root";
$password = "";
$database = "queryshelf";

$conn = mysqli_connect($host, $user, $password, $database);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$add_message = "";
$add_message_class = "";
$publication_message = "";
$publication_message_class = "";

/* POST METHOD ACTIONS */
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pub_id = $_POST['pub_id'] ?? '';
    $title = $_POST['title'] ?? '';
    $series = $_POST['series'] ?? ''; 
    $edition = $_POST['edition'] ?? '';
    $date_published = $_POST['date_published'] ?? '';
    $shelf_location = $_POST['shelf_location'] ?? '';
    $language_used = $_POST['language_used'] ?? '';
    $publisher_id = $_POST['publisher_id'] ?? ''; 
    $subtitle = $_POST['subtitle'] ?? '';
    $pages = $_POST['pages'] ?? '';
    $copyright_date = $_POST['copyright_date'] ?? '';
    $book_status = $_POST['book_status'] ?? 'Available';

    // --- ACTION 1: ADD BOOK ---
    if (isset($_POST['add_book'])) {
        if (!in_array($book_status, ['Available', 'Borrowed'], true)) {
            $add_message = "Error: Please choose a valid book status.";
            $add_message_class = "alert-danger";
        } else {
            $check_duplicate = "SELECT pub_id FROM publication WHERE pub_id = ?";
            $stmt_check = mysqli_prepare($conn, $check_duplicate);
            mysqli_stmt_bind_param($stmt_check, "s", $pub_id);
            mysqli_stmt_execute($stmt_check);
            mysqli_stmt_store_result($stmt_check);
            
            if (mysqli_stmt_num_rows($stmt_check) > 0) {
                $add_message = "Error: The Publication ID ($pub_id) already exists. Please use a unique ID!";
                $add_message_class = "alert-danger";
                mysqli_stmt_close($stmt_check);
            } else {
                mysqli_stmt_close($stmt_check);
                mysqli_query($conn, "SET FOREIGN_KEY_CHECKS = 0");

                $insert = "INSERT INTO publication 
                (pub_id, title, series, edition, date_published, shelf_location, language_used, publisher_id, subtitle, pages, copyright_date)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                $stmt = mysqli_prepare($conn, $insert);
                mysqli_stmt_bind_param($stmt, "sssssssssis", 
                    $pub_id, $title, $series, $edition, $date_published, 
                    $shelf_location, $language_used, $publisher_id, $subtitle, $pages, $copyright_date
                );

                if (mysqli_stmt_execute($stmt)) {
                    $add_message = "Success: New book has been successfully added!";
                    $add_message_class = "alert-success";
                } else {
                    $add_message = "Error while saving: " . mysqli_error($conn);
                    $add_message_class = "alert-danger";
                }
                mysqli_stmt_close($stmt);
                mysqli_query($conn, "SET FOREIGN_KEY_CHECKS = 1");
            }
        }
    }

    // --- ACTION 2: UPDATE BOOK ---
    if (isset($_POST['update_book'])) {
        if (!in_array($book_status, ['Available', 'Borrowed'], true)) {
            $publication_message = "Error: Please choose a valid book status.";
            $publication_message_class = "alert-danger";
        } elseif (empty($pub_id)) {
            $publication_message = "Error: Please select a publication from the table first to update.";
            $publication_message_class = "alert-danger";
        } else {
            mysqli_query($conn, "SET FOREIGN_KEY_CHECKS = 0");
            $update = "UPDATE publication SET title=?, series=?, edition=?, date_published=?, shelf_location=?, language_used=?, publisher_id=?, subtitle=?, pages=?, copyright_date=? WHERE pub_id=?";
            $stmt = mysqli_prepare($conn, $update);
            mysqli_stmt_bind_param($stmt, "ssssssssiss", $title, $series, $edition, $date_published, $shelf_location, $language_used, $publisher_id, $subtitle, $pages, $copyright_date, $pub_id);
            
            if (mysqli_stmt_execute($stmt)) {
                $copy_count_stmt = mysqli_prepare($conn, "SELECT COUNT(*) FROM books WHERE pub_id = ?");
                mysqli_stmt_bind_param($copy_count_stmt, "s", $pub_id);
                mysqli_stmt_execute($copy_count_stmt);
                mysqli_stmt_bind_result($copy_count_stmt, $copy_count);
                mysqli_stmt_fetch($copy_count_stmt);
                mysqli_stmt_close($copy_count_stmt);

                if ($copy_count > 0) {
                    $status_update = mysqli_prepare($conn, "UPDATE books SET status = ? WHERE pub_id = ?");
                    mysqli_stmt_bind_param($status_update, "ss", $book_status, $pub_id);
                    if (mysqli_stmt_execute($status_update)) {
                        $publication_message = "Success: Publication ID ($pub_id) and its book copies have been successfully updated!";
                        $publication_message_class = "alert-success";
                    } else {
                        $publication_message = "Error while updating book status: " . mysqli_stmt_error($status_update);
                        $publication_message_class = "alert-danger";
                    }
                    mysqli_stmt_close($status_update);
                } else {
                    $publication_message = "Publication ID ($pub_id) was updated, but it has no book copies whose status can be changed.";
                    $publication_message_class = "alert-danger";
                }
            } else {
                $publication_message = "Error while updating: " . mysqli_error($conn);
                $publication_message_class = "alert-danger";
            }
            mysqli_stmt_close($stmt);
            mysqli_query($conn, "SET FOREIGN_KEY_CHECKS = 1");
        }
    }

    // --- ACTION 3: DELETE BOOK ---
    if (isset($_POST['delete_book'])) {
        if (empty($pub_id)) {
            $publication_message = "Error: Please select a publication from the table first to delete.";
            $publication_message_class = "alert-danger";
        } else {
            mysqli_query($conn, "SET FOREIGN_KEY_CHECKS = 0");
            $delete = "DELETE FROM publication WHERE pub_id = ?";
            $stmt = mysqli_prepare($conn, $delete);
            mysqli_stmt_bind_param($stmt, "s", $pub_id);
            
            if (mysqli_stmt_execute($stmt)) {
                $publication_message = "";
                $publication_message_class = "";
            } else {
                $publication_message = "Error while deleting: " . mysqli_error($conn);
                $publication_message_class = "alert-danger";
            }
            mysqli_stmt_close($stmt);
            mysqli_query($conn, "SET FOREIGN_KEY_CHECKS = 1");
        }
    }
}

/* SEARCH & FETCH LOGIC FOR THE TABLE */
$search_query = $_GET['search'] ?? '';
$publication_status_query = "
    SELECT publication.*, COALESCE(book_status_summary.book_status, 'Available') AS book_status
    FROM publication
    LEFT JOIN (
        SELECT pub_id,
               CASE WHEN SUM(status = 'Borrowed') > 0 THEN 'Borrowed' ELSE 'Available' END AS book_status
        FROM books
        GROUP BY pub_id
    ) AS book_status_summary ON book_status_summary.pub_id = publication.pub_id
";

if (!empty($search_query)) {
    $sql = $publication_status_query . "
            WHERE publication.pub_id LIKE ? 
               OR publication.title LIKE ? 
               OR publication.subtitle LIKE ? 
               OR publication.language_used LIKE ?
               OR book_status_summary.book_status LIKE ?
            ORDER BY publication.pub_id ASC";
    
    $stmt_search = mysqli_prepare($conn, $sql);
    $search_param = "%" . $search_query . "%";
    mysqli_stmt_bind_param($stmt_search, "sssss", $search_param, $search_param, $search_param, $search_param, $search_param);
    mysqli_stmt_execute($stmt_search);
    $result = mysqli_stmt_get_result($stmt_search);
} else {
    $sql = $publication_status_query . " ORDER BY publication.pub_id ASC";
    $result = mysqli_query($conn, $sql);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Librarian Dashboard | QueryShelf</title>
    <link rel="stylesheet" href="../css/librarian_dashboard.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
        
</head>
<body>

<form method="POST" id="main-publication-form">

<header class="topbar">
    <div class="logo-section">
        <h1>BookTrace</h1>
        <p class="eyebrow">Librarian Panel</p>
    </div>

    <div class="header-actions">
        <a href="../index.php" class="back-btn">
            <i class="bi bi-arrow-left"></i>
            Back
        </a>
        <a href="reports.php" class="back-btn reports-btn">
            <i class="bi bi-file-earmark-bar-graph"></i>
            Reports
        </a>
        <a href="add_transaction.php" class="back-btn">
            <i class="bi bi-arrow-left-right"></i>
            Add Transactions
        </a>
    </div>
</header>

<main class="dashboard-container">

    <section class="form-section">
        <h2 class="section-title">
            <i class="bi bi-plus-circle"></i> Publication Form
        </h2>

        <?php if (!empty($add_message)): ?>
            <div class="<?php echo $add_message_class; ?><?php echo $add_message_class === 'alert-success' ? ' auto-dismiss-message' : ''; ?>">
                <i class="bi bi-info-circle-fill"></i> <?php echo htmlspecialchars($add_message); ?>
            </div>
        <?php endif; ?>

        <div class="book-form">
            <input type="text" name="pub_id" id="form_pub_id" placeholder="Publication ID" required>
            <input type="text" name="title" id="form_title" placeholder="Book Title" required>
            <input type="text" name="subtitle" id="form_subtitle" placeholder="Subtitle">
            <input type="text" name="language_used" id="form_language" placeholder="Language Used" required>
            <input type="text" name="shelf_location" id="form_shelf" placeholder="Shelf Location" required>
            <input type="number" name="pages" id="form_pages" placeholder="Pages" required>
            <input type="text" name="series" id="form_series" placeholder="Series">
            <input type="text" name="edition" id="form_edition" placeholder="Edition (e.g. 1st)">
            <input type="text" name="publisher_id" id="form_publisher" placeholder="Publisher ID" required>
            
            <div class="date-group">
                <label>Date Published</label>
                <input type="date" name="date_published" id="form_date_published" required>
            </div>
            
            <div class="date-group">
                <label>Copyright Year</label>
                <input type="number" name="copyright_date" id="form_copyright" placeholder="YYYY" min="1000" max="2099" required>
            </div>

            <fieldset class="status-toggle">
                <legend>Book Status</legend>
                <input type="hidden" name="book_status" id="form_book_status" value="Available">
                <button type="button" class="status-switch" id="book_status_toggle" role="switch" aria-checked="true">
                    <span class="status-switch-indicator" aria-hidden="true"></span>
                    <span id="book_status_label">Available</span>
                </button>
            </fieldset>

            <button type="submit" name="add_book" class="submit-btn">
                <i class="bi bi-plus-lg"></i> Add Publication
            </button>
        </div>
    </section>

</form>

    <div class="modal-overlay" id="update-modal" aria-hidden="true">
        <section class="update-modal" role="dialog" aria-modal="true" aria-labelledby="update-modal-title">
            <div class="modal-header">
                <div>
                    <h2 id="update-modal-title">Update Publication</h2>
                    <p>Edit the selected publication details.</p>
                </div>
                <button type="button" class="modal-close" id="close-update-modal" aria-label="Close">&times;</button>
            </div>

            <form method="POST" class="book-form modal-form">
                <input type="text" name="pub_id" id="modal_pub_id" placeholder="Publication ID" readonly required>
                <input type="text" name="title" id="modal_title" placeholder="Book Title" required>
                <input type="text" name="subtitle" id="modal_subtitle" placeholder="Subtitle">
                <input type="text" name="language_used" id="modal_language" placeholder="Language Used" required>
                <input type="text" name="shelf_location" id="modal_shelf" placeholder="Shelf Location" required>
                <input type="number" name="pages" id="modal_pages" placeholder="Pages" required>
                <input type="text" name="series" id="modal_series" placeholder="Series">
                <input type="text" name="edition" id="modal_edition" placeholder="Edition (e.g. 1st)">
                <input type="text" name="publisher_id" id="modal_publisher" placeholder="Publisher ID" required>

                <div class="date-group">
                    <label for="modal_date_published">Date Published</label>
                    <input type="date" name="date_published" id="modal_date_published" required>
                </div>

                <div class="date-group">
                    <label for="modal_copyright">Copyright Year</label>
                    <input type="number" name="copyright_date" id="modal_copyright" placeholder="YYYY" min="1000" max="2099" required>
                </div>

                <fieldset class="status-toggle">
                    <legend>Book Status</legend>
                    <input type="hidden" name="book_status" id="modal_book_status" value="Available">
                    <button type="button" class="status-switch" id="modal_status_toggle" role="switch" aria-checked="true">
                        <span class="status-switch-indicator" aria-hidden="true"></span>
                        <span id="modal_status_label">Available</span>
                    </button>
                </fieldset>

                <div class="modal-actions">
                    <button type="button" class="modal-cancel" id="cancel-update-modal">Cancel</button>
                    <button type="submit" name="update_book" class="submit-btn">
                        <i class="bi bi-check-lg"></i> Save Changes
                    </button>
                </div>
            </form>
        </section>
    </div>

    <div class="modal-overlay" id="selection-warning-modal" aria-hidden="true">
        <section class="selection-warning" role="alertdialog" aria-modal="true" aria-labelledby="selection-warning-title" aria-describedby="selection-warning-message">
            <div class="warning-icon"><i class="bi bi-exclamation-lg"></i></div>
            <h2 id="selection-warning-title">No publication selected</h2>
<p id="selection-warning-message">Please select a publication from the Library Publications table before updating.</p>
<button type="button" class="submit-btn" id="close-selection-warning">OK</button>
</section>
    </div>

    <section class="table-section">
        
        <div class="section-header-inline">
            
            <h2 class="section-title">
                <i class="bi bi-book-half"></i> Library Publications
            </h2>
            
            <div class="header-actions-group">
                
                <form method="GET" action="" class="search-form-container">
                    <input type="text" name="search" placeholder="Search Title, ID, Subtitle, or Language..." value="<?php echo htmlspecialchars($search_query); ?>" class="search-input-box">
                    <button type="submit" class="search-submit-btn">
                        <i class="bi bi-search"></i> Search
                    </button>
                    <?php if (!empty($search_query)): ?>
                        <a href="librarian_dashboard.php" class="search-clear-btn">Clear</a>
                    <?php endif; ?>
                </form>

                <button type="button" id="open-update-modal" class="btn-header-action btn-header-update">
                    <i class="bi bi-pencil-square"></i> Update
                </button>
                
                <button type="submit" form="main-publication-form" name="delete_book" class="btn-header-action btn-header-delete" onclick="return confirm('Are you sure you want to delete the selected publication?');">
                    <i class="bi bi-trash3-fill"></i> Delete
                </button>
            </div>
        </div>

        <?php if (!empty($publication_message)): ?>
            <div class="<?php echo $publication_message_class; ?><?php echo $publication_message_class === 'alert-success' ? ' auto-dismiss-message' : ''; ?>">
                <i class="bi bi-info-circle-fill"></i> <?php echo htmlspecialchars($publication_message); ?>
            </div>
        <?php endif; ?>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Publication ID</th>
                        <th>Title</th>
                        <th>Subtitle</th>
                        <th>Language</th>
                        <th>Shelf</th>
                        <th>Pages</th>
                        <th>Series</th>
                        <th>Edition</th>
                        <th>Publisher ID</th>
                        <th>Date Published</th>
                        <th>Copyright</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    if (mysqli_num_rows($result) > 0) {
                        while ($row = mysqli_fetch_assoc($result)) {
                    ?>
                    <tr class="clickable-row" 
                        data-pubid="<?php echo htmlspecialchars($row['pub_id']); ?>"
                        data-title="<?php echo htmlspecialchars($row['title']); ?>"
                        data-subtitle="<?php echo htmlspecialchars($row['subtitle']); ?>"
                        data-language="<?php echo htmlspecialchars($row['language_used']); ?>"
                        data-shelf="<?php echo htmlspecialchars($row['shelf_location']); ?>"
                        data-pages="<?php echo htmlspecialchars($row['pages']); ?>"
                        data-series="<?php echo htmlspecialchars($row['series']); ?>"
                        data-edition="<?php echo htmlspecialchars($row['edition']); ?>"
                        data-publisher="<?php echo htmlspecialchars($row['publisher_id']); ?>"
                        data-datepub="<?php echo htmlspecialchars($row['date_published']); ?>"
                        data-copyright="<?php echo htmlspecialchars($row['copyright_date']); ?>"
                        data-status="<?php echo htmlspecialchars($row['book_status']); ?>">
                        
                        <td><strong><?php echo htmlspecialchars($row['pub_id']); ?></strong></td>
                        <td><?php echo htmlspecialchars($row['title']); ?></td>
                        <td><?php echo htmlspecialchars($row['subtitle']); ?></td>
                        <td><?php echo htmlspecialchars($row['language_used']); ?></td>
                        <td><?php echo htmlspecialchars($row['shelf_location']); ?></td>
                        <td><?php echo htmlspecialchars($row['pages']); ?></td>
                        <td><?php echo htmlspecialchars($row['series']); ?></td>
                        <td><?php echo htmlspecialchars($row['edition']); ?></td>
                        <td><?php echo htmlspecialchars($row['publisher_id']); ?></td>
                        <td><?php echo htmlspecialchars($row['date_published']); ?></td>
                        <td><?php echo htmlspecialchars($row['copyright_date']); ?></td>
                        <td><?php echo htmlspecialchars($row['book_status']); ?></td>
                    </tr>
                    <?php
                        }
                    } else {
                        echo "<tr><td colspan='12' style='text-align:center;'>No publications found.</td></tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>
    </section>

</main>

<script>
document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll(".auto-dismiss-message").forEach(function(message) {
        window.setTimeout(function() {
            message.remove();
        }, 10000);
    });

    const rows = document.querySelectorAll(".clickable-row");
    const updateButton = document.getElementById("open-update-modal");
    const updateModal = document.getElementById("update-modal");
    const closeModalButton = document.getElementById("close-update-modal");
    const cancelModalButton = document.getElementById("cancel-update-modal");
    const selectionWarningModal = document.getElementById("selection-warning-modal");
    const closeSelectionWarning = document.getElementById("close-selection-warning");
    let selectedRow = null;
    const statusInput = document.getElementById("form_book_status");
    const statusToggle = document.getElementById("book_status_toggle");
    const statusLabel = document.getElementById("book_status_label");
    const modalStatusInput = document.getElementById("modal_book_status");
    const modalStatusToggle = document.getElementById("modal_status_toggle");
    const modalStatusLabel = document.getElementById("modal_status_label");

    function setBookStatus(status, input, toggle, label) {
        const isAvailable = status === "Available";
        input.value = isAvailable ? "Available" : "Borrowed";
        label.textContent = input.value;
        toggle.setAttribute("aria-checked", isAvailable ? "true" : "false");
        toggle.classList.toggle("is-borrowed", !isAvailable);
    }

    statusToggle.addEventListener("click", function() {
        setBookStatus(statusInput.value === "Available" ? "Borrowed" : "Available", statusInput, statusToggle, statusLabel);
    });

    modalStatusToggle.addEventListener("click", function() {
        setBookStatus(modalStatusInput.value === "Available" ? "Borrowed" : "Available", modalStatusInput, modalStatusToggle, modalStatusLabel);
    });

    function closeUpdateModal() {
        updateModal.classList.remove("is-open");
        updateModal.setAttribute("aria-hidden", "true");
    }

    function closeSelectionWarningModal() {
        selectionWarningModal.classList.remove("is-open");
        selectionWarningModal.setAttribute("aria-hidden", "true");
    }

    updateButton.addEventListener("click", function() {
        if (!selectedRow) {
            selectionWarningModal.classList.add("is-open");
            selectionWarningModal.setAttribute("aria-hidden", "false");
            closeSelectionWarning.focus();
            return;
        }

        const fields = {
            modal_pub_id: "pubid",
            modal_title: "title",
            modal_subtitle: "subtitle",
            modal_language: "language",
            modal_shelf: "shelf",
            modal_pages: "pages",
            modal_series: "series",
            modal_edition: "edition",
            modal_publisher: "publisher",
            modal_date_published: "datepub"
        };

        Object.entries(fields).forEach(([id, dataKey]) => {
            document.getElementById(id).value = selectedRow.dataset[dataKey];
        });

        const copyrightValue = selectedRow.dataset.copyright;
        document.getElementById("modal_copyright").value = copyrightValue.includes("-")
            ? copyrightValue.split("-")[0]
            : copyrightValue;
        setBookStatus(selectedRow.dataset.status, modalStatusInput, modalStatusToggle, modalStatusLabel);

        updateModal.classList.add("is-open");
        updateModal.setAttribute("aria-hidden", "false");
        document.getElementById("modal_title").focus();
    });

    closeModalButton.addEventListener("click", closeUpdateModal);
    cancelModalButton.addEventListener("click", closeUpdateModal);
    closeSelectionWarning.addEventListener("click", closeSelectionWarningModal);
    updateModal.addEventListener("click", function(event) {
        if (event.target === updateModal) {
            closeUpdateModal();
        }
    });
    selectionWarningModal.addEventListener("click", function(event) {
        if (event.target === selectionWarningModal) {
            closeSelectionWarningModal();
        }
    });
    document.addEventListener("keydown", function(event) {
        if (event.key === "Escape" && updateModal.classList.contains("is-open")) {
            closeUpdateModal();
        }
        if (event.key === "Escape" && selectionWarningModal.classList.contains("is-open")) {
            closeSelectionWarningModal();
        }
    });

    rows.forEach(row => {
        row.addEventListener("click", function() {
            rows.forEach(r => r.classList.remove("selected-row"));
            this.classList.add("selected-row");
            selectedRow = this;
            closeSelectionWarningModal();
        });
    });
});
</script>

</body>
</html>