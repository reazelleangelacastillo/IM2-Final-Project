<?php
require_once __DIR__ . '/includes/auth.php';
$host = "localhost";
$user = "root";
$password = "";
$database = "booktrace";

$conn = mysqli_connect($host, $user, $password, $database);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

function dashboardDateIsValid(string $value): bool
{
    $date = DateTime::createFromFormat('!Y-m-d', $value);
    $errors = DateTime::getLastErrors();

    return $date !== false
        && $date->format('Y-m-d') === $value
        && ($errors === false || ($errors['warning_count'] === 0 && $errors['error_count'] === 0));
}

function dashboardPostValue(string $key): string
{
    $value = $_POST[$key] ?? '';

    return is_string($value) || is_numeric($value) ? trim((string)$value) : '';
}

function dashboardIdentifierFormatIsValid(string $value): bool
{
    return preg_match('/^PUB[0-9]+$/D', $value) === 1;
}

function dashboardValueExists(mysqli $conn, string $sql, string $value, ?string $excludeValue = null): bool
{
    $stmt = mysqli_prepare($conn, $sql);
    if ($excludeValue === null) {
        mysqli_stmt_bind_param($stmt, "s", $value);
    } else {
        mysqli_stmt_bind_param($stmt, "ss", $value, $excludeValue);
    }
    mysqli_stmt_execute($stmt);
    mysqli_stmt_store_result($stmt);
    $exists = mysqli_stmt_num_rows($stmt) > 0;
    mysqli_stmt_close($stmt);

    return $exists;
}

function dashboardIdentifierIsInUse(
    mysqli $conn,
    string $identifier,
    ?string $excludeBookPubId = null,
    ?string $excludePeriodicalIssn = null,
    ?string $excludePublicationId = null
): bool {
    $bookSql = "SELECT 1 FROM books WHERE ISBN = ?";
    if ($excludeBookPubId !== null) {
        $bookSql .= " AND pub_id <> ?";
    }

    $periodicalSql = "SELECT 1 FROM periodicals WHERE ISSN = ?";
    if ($excludePeriodicalIssn !== null) {
        $periodicalSql .= " AND ISSN <> ?";
    }

    $publicationSql = "SELECT 1 FROM publication WHERE pub_id = ?";
    if ($excludePublicationId !== null) {
        $publicationSql .= " AND pub_id <> ?";
    }

    return dashboardValueExists($conn, $bookSql, $identifier, $excludeBookPubId)
        || dashboardValueExists($conn, $periodicalSql, $identifier, $excludePeriodicalIssn)
        || dashboardValueExists($conn, $publicationSql, $identifier, $excludePublicationId);
}

function dashboardIsbnFormatIsValid(string $value): bool
{
    return preg_match('/^ISBN-[A-Za-z0-9][A-Za-z0-9 .\/-]*$/D', $value) === 1;
}

function dashboardIssnFormatIsValid(string $value): bool
{
    return preg_match('/^ISSN-[A-Za-z0-9][A-Za-z0-9 .\/-]*$/D', $value) === 1;
}

function dashboardPublicationIsAssigned(
    mysqli $conn,
    string $pubId,
    ?string $excludePeriodicalIssn = null
): bool {
    $periodicalSql = "SELECT 1 FROM periodicals WHERE pub_id = ?";
    if ($excludePeriodicalIssn !== null) {
        $periodicalSql .= " AND ISSN <> ?";
    }

    return dashboardValueExists($conn, "SELECT 1 FROM books WHERE pub_id = ?", $pubId)
        || dashboardValueExists($conn, $periodicalSql, $pubId, $excludePeriodicalIssn);
}

function dashboardBookFormError(array $fields): ?string
{
    $requiredFields = [
        'Book title' => $fields['title'],
        'Date published' => $fields['date_published'],
        'Shelf location' => $fields['shelf_location'],
        'Language' => $fields['language_used'],
        'Pages' => $fields['pages'],
        'Class number' => $fields['class_no'],
        'Call number' => $fields['call_no']
    ];

    foreach ($requiredFields as $label => $value) {
        if (trim((string)$value) === '') {
            return "$label is required. Please fill it in and try again.";
        }
    }

    if (!in_array($fields['category'], ['Academic', 'Non-Academic'], true)) {
        return 'Please choose a valid category: Academic or Non-Academic.';
    }

    $lengthLimits = [
        'Publication ID' => [$fields['pub_id'], 20],
        'Book title' => [$fields['title'], 100],
        'Series' => [$fields['series'], 100],
        'Edition' => [$fields['edition'], 30],
        'Shelf location' => [$fields['shelf_location'], 30],
        'Language' => [$fields['language_used'], 50],
        'Publisher ID' => [$fields['publisher_id'], 30],
        'Subtitle' => [$fields['subtitle'], 255],
        'Publisher name' => [$fields['publisher'], 100],
        'Place of publication' => [$fields['place_of_publication'], 100],
        'Class number' => [$fields['class_no'], 50],
        'Call number' => [$fields['call_no'], 50],
        'ISBN' => [$fields['ISBN'] ?? '', 25],
        'Audience type' => [$fields['audience_type'] ?? '', 50]
    ];

    foreach ($lengthLimits as $label => [$value, $maximumLength]) {
        $length = function_exists('mb_strlen') ? mb_strlen($value, 'UTF-8') : strlen($value);
        if ($length > $maximumLength) {
            return "$label is too long. Use no more than $maximumLength characters.";
        }
    }

    if (preg_match('/^[1-9][0-9]*$/', (string)$fields['pages']) !== 1 || (float)$fields['pages'] > 2147483647) {
        return 'Pages must be a whole number greater than zero.';
    }

    if (preg_match('/^[0-9]{4}$/', (string)$fields['copyright_date']) !== 1
        || (int)$fields['copyright_date'] < 1000
        || (int)$fields['copyright_date'] > 2099
    ) {
        return 'Enter a valid copyright year from 1000 to 2099.';
    }

    if (!dashboardDateIsValid((string)$fields['date_published'])) {
        return 'Enter a valid publication date.';
    }

    return null;
}

function dashboardPeriodicalFormError(string $issn, string $pubId, string $type): ?string
{
    if (trim($type) === '') {
        return 'Choose a periodical type from the list.';
    }

    foreach ([
        'ISSN' => [$issn, 20],
        'Publication ID' => [$pubId, 20]
    ] as $label => [$value, $maximumLength]) {
        $length = function_exists('mb_strlen') ? mb_strlen($value, 'UTF-8') : strlen($value);
        if ($length > $maximumLength) {
            return "$label is too long. Use no more than $maximumLength characters.";
        }
    }

    if (!in_array($type, dashboardPeriodicalTypes(), true)) {
        return 'Choose a periodical type from the list of available options.';
    }

    return null;
}

function dashboardPeriodicalTypes(): array
{
    return [
        'Newspaper',
        'Magazine',
        'Journal',
        'Newsletter',
        'Bulletin',
        'Annual Report',
        'Proceedings',
        'Trade Publications',
        'Academic Publications',
        'Government Publications',
        'Professional Publications',
        'Statistical Publications',
        'Yearbook',
        'Directory',
        'Almanac',
        'Review Publications',
        'Digest',
        'Conference Publications',
        'Research Publications',
        'Electronic Periodicals (E-Journals / E-Magazines)'
    ];
}

$add_message = "";
$add_message_class = "";
$publication_message = "";
$publication_message_class = "";
$periodical_message = "";
$periodical_message_class = "";

/* POST METHOD ACTIONS */
if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
    $pub_id = dashboardPostValue('pub_id');
    $original_pub_id = dashboardPostValue('original_pub_id');
    $title = dashboardPostValue('title');
    $series = dashboardPostValue('series');
    $edition = dashboardPostValue('edition');
    $date_published = dashboardPostValue('date_published');
    $shelf_location = dashboardPostValue('shelf_location');
    $language_used = dashboardPostValue('language_used');
    $publisher_id = dashboardPostValue('publisher_id');
    $subtitle = dashboardPostValue('subtitle');
    $pages = dashboardPostValue('pages');
    $copyright_date = dashboardPostValue('copyright_date');
    $publisher = dashboardPostValue('publisher');
    $place_of_publication = dashboardPostValue('place_of_publication');
    $class_no = dashboardPostValue('class_no');
    $call_no = dashboardPostValue('call_no');
    $isbn = dashboardPostValue('ISBN');
    $isbn = $isbn !== '' ? $isbn : null;
    $category = dashboardPostValue('category');
    $audience_type_choice = dashboardPostValue('audience_type_choice');
    $audience_type_custom = dashboardPostValue('audience_type_custom');
    $audience_type_options = ['Students', 'Teachers', 'Researchers', 'Professionals', 'General Public'];
    if (in_array($audience_type_choice, $audience_type_options, true)) {
        $audience_type = $audience_type_choice;
    } elseif ($audience_type_choice === 'Other') {
        $audience_type = $audience_type_custom !== '' ? $audience_type_custom : null;
    } else {
        $audience_type = null;
    }

    if (isset($_POST['add_publication'])) {
        $bookFields = compact(
            'pub_id',
            'title',
            'series',
            'edition',
            'date_published',
            'shelf_location',
            'language_used',
            'publisher_id',
            'subtitle',
            'pages',
            'copyright_date',
            'publisher',
            'place_of_publication',
            'class_no',
            'call_no',
            'category',
            'audience_type'
        );
        $bookFields['ISBN'] = $isbn;
        $book_form_error = dashboardBookFormError($bookFields);
        $audience_type_error = $audience_type_choice === 'Other' && $audience_type === null
            ? 'Enter an audience type in the Other field.'
            : ($audience_type_choice !== '' && !in_array($audience_type_choice, array_merge($audience_type_options, ['Other']), true)
                ? 'Choose an audience type from the list.'
                : null);

        if (!dashboardIdentifierFormatIsValid($pub_id)) {
            $add_message = "Publication ID is invalid. Enter PUB followed by digits, for example PUB131.";
            $add_message_class = "alert-danger";
        } elseif (!dashboardIsbnFormatIsValid((string)$isbn)) {
            $add_message = "ISBN is invalid. Enter the ISBN- prefix followed by the identifier, for example ISBN-978-621-12-3456-7.";
            $add_message_class = "alert-danger";
        } elseif ($book_form_error !== null) {
            $add_message = $book_form_error;
            $add_message_class = "alert-danger";
        } elseif ($audience_type_error !== null) {
            $add_message = $audience_type_error;
            $add_message_class = "alert-danger";
        } elseif (dashboardValueExists($conn, "SELECT 1 FROM publication WHERE pub_id = ?", $pub_id)) {
            $add_message = "Publication ID ($pub_id) is already in use. Enter a different ID.";
            $add_message_class = "alert-danger";
        } elseif (dashboardIdentifierIsInUse($conn, $pub_id)) {
            $add_message = "Publication ID ($pub_id) is already in use as another identifier. Enter a different ID.";
            $add_message_class = "alert-danger";
        } elseif ($isbn !== null && dashboardIdentifierIsInUse($conn, $isbn)) {
            $add_message = "ISBN ($isbn) is already in use. Enter a unique ISBN.";
            $add_message_class = "alert-danger";
        } else {
            mysqli_begin_transaction($conn);
            $insert = mysqli_prepare($conn, "
                INSERT INTO publication
                    (pub_id, title, series, edition, date_published, shelf_location, language_used, publisher_id, subtitle, pages, copyright_date, publisher, place_of_publication)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            mysqli_stmt_bind_param(
                $insert,
                "sssssssss" . "iiss",
                $pub_id,
                $title,
                $series,
                $edition,
                $date_published,
                $shelf_location,
                $language_used,
                $publisher_id,
                $subtitle,
                $pages,
                $copyright_date,
                $publisher,
                $place_of_publication
            );

            if (mysqli_stmt_execute($insert)) {
                $insert_book = mysqli_prepare($conn, "
                    INSERT INTO books (pub_id, class_no, call_no, ISBN, category, audience_type)
                    VALUES (?, ?, ?, ?, ?, ?)
                ");
                mysqli_stmt_bind_param($insert_book, "ssssss", $pub_id, $class_no, $call_no, $isbn, $category, $audience_type);

                if (mysqli_stmt_execute($insert_book)) {
                    mysqli_commit($conn);
                    $add_message = "Book added successfully.";
                    $add_message_class = "alert-success";
                } else {
                    mysqli_rollback($conn);
                    $add_message = "Error while saving book details: " . mysqli_stmt_error($insert_book);
                    $add_message_class = "alert-danger";
                }
                mysqli_stmt_close($insert_book);
            } else {
                mysqli_rollback($conn);
                $add_message = "Error while saving publication: " . mysqli_stmt_error($insert);
                $add_message_class = "alert-danger";
            }
            mysqli_stmt_close($insert);
        }
    }

    if (isset($_POST['add_periodical'])) {
        $issn = dashboardPostValue('ISSN');
        $periodical_type = dashboardPostValue('peridodic_type');
        $periodical_form_error = dashboardPeriodicalFormError($issn, $pub_id, $periodical_type);

        if (!dashboardIssnFormatIsValid($issn)) {
            $periodical_message = "ISSN is invalid. Enter the ISSN- prefix followed by the identifier, for example ISSN-2094-1011.";
            $periodical_message_class = "alert-danger";
        } elseif (!dashboardIdentifierFormatIsValid($pub_id)) {
            $periodical_message = "Publication ID is invalid. Enter PUB followed by digits, for example PUB131.";
            $periodical_message_class = "alert-danger";
        } elseif ($periodical_form_error !== null) {
            $periodical_message = $periodical_form_error;
            $periodical_message_class = "alert-danger";
        } elseif (!dashboardValueExists($conn, "SELECT 1 FROM publication WHERE pub_id = ?", $pub_id)) {
            $periodical_message = "Publication ID ($pub_id) was not found. Check the ID and try again.";
            $periodical_message_class = "alert-danger";
        } elseif (dashboardPublicationIsAssigned($conn, $pub_id)) {
            $periodical_message = "Publication ID ($pub_id) is already assigned to a book or periodical. Choose an unassigned publication.";
            $periodical_message_class = "alert-danger";
        } elseif (dashboardIdentifierIsInUse($conn, $pub_id, null, null, $pub_id)) {
            $periodical_message = "Publication ID ($pub_id) is already in use as an ISBN or ISSN. Enter a different ID.";
            $periodical_message_class = "alert-danger";
        } elseif (dashboardIdentifierIsInUse($conn, $issn)) {
            $periodical_message = "ISSN ($issn) is already in use. Enter a unique ISSN.";
            $periodical_message_class = "alert-danger";
        } else {
            $insert_periodical = mysqli_prepare($conn, "
                INSERT INTO periodicals (ISSN, pub_id, peridodic_type)
                VALUES (?, ?, ?)
            ");
            mysqli_stmt_bind_param($insert_periodical, "sss", $issn, $pub_id, $periodical_type);

            if (mysqli_stmt_execute($insert_periodical)) {
                $periodical_message = "Periodical added successfully.";
                $periodical_message_class = "alert-success";
            } else {
                $periodical_message = "Error while saving periodical: " . mysqli_stmt_error($insert_periodical);
                $periodical_message_class = "alert-danger";
            }
            mysqli_stmt_close($insert_periodical);
        }
    }

    if (isset($_POST['update_periodical'])) {
        $original_issn = dashboardPostValue('original_issn');
        $issn = dashboardPostValue('ISSN');
        $periodical_type = dashboardPostValue('peridodic_type');
        $periodical_form_error = dashboardPeriodicalFormError($issn, $pub_id, $periodical_type);

        if (!dashboardIssnFormatIsValid($issn)) {
            $periodical_message = "ISSN is invalid. Enter the ISSN- prefix followed by the identifier, for example ISSN-2094-1011.";
            $periodical_message_class = "alert-danger";
        } elseif (!dashboardIdentifierFormatIsValid($pub_id)) {
            $periodical_message = "Publication ID is invalid. Enter PUB followed by digits, for example PUB131.";
            $periodical_message_class = "alert-danger";
        } elseif ($original_issn === '') {
            $periodical_message = "Select a periodical from the table before saving changes.";
            $periodical_message_class = "alert-danger";
        } elseif ($periodical_form_error !== null) {
            $periodical_message = $periodical_form_error;
            $periodical_message_class = "alert-danger";
        } elseif (!dashboardValueExists($conn, "SELECT 1 FROM periodicals WHERE ISSN = ?", $original_issn)) {
            $periodical_message = "The selected periodical could not be found. Refresh the page and select it again.";
            $periodical_message_class = "alert-danger";
        } elseif (!dashboardValueExists($conn, "SELECT 1 FROM publication WHERE pub_id = ?", $pub_id)) {
            $periodical_message = "Publication ID ($pub_id) was not found. Check the ID and try again.";
            $periodical_message_class = "alert-danger";
        } elseif (dashboardPublicationIsAssigned($conn, $pub_id, $original_issn)) {
            $periodical_message = "Publication ID ($pub_id) is already assigned to a book or another periodical. Choose an unassigned publication.";
            $periodical_message_class = "alert-danger";
        } elseif (dashboardIdentifierIsInUse($conn, $pub_id, null, null, $pub_id)) {
            $periodical_message = "Publication ID ($pub_id) is already in use as an ISBN or ISSN. Enter a different ID.";
            $periodical_message_class = "alert-danger";
        } elseif (dashboardIdentifierIsInUse($conn, $issn, null, $original_issn)) {
            $periodical_message = "ISSN ($issn) is already in use. Enter a unique ISSN.";
            $periodical_message_class = "alert-danger";
        } else {
            $update_periodical = mysqli_prepare($conn, "
                UPDATE periodicals
                SET ISSN = ?, pub_id = ?, peridodic_type = ?, updated_at = CURRENT_TIMESTAMP
                WHERE ISSN = ?
            ");
            mysqli_stmt_bind_param($update_periodical, "ssss", $issn, $pub_id, $periodical_type, $original_issn);

            if (mysqli_stmt_execute($update_periodical)) {
                $periodical_message = "Periodical updated successfully.";
                $periodical_message_class = "alert-success";
            } else {
                $periodical_message = "Error while updating periodical: " . mysqli_stmt_error($update_periodical);
                $periodical_message_class = "alert-danger";
            }
            mysqli_stmt_close($update_periodical);
        }
    }

    if (isset($_POST['delete_periodical'])) {
        $issn = trim($_POST['ISSN'] ?? '');
        if ($issn === '') {
            $periodical_message = "Select a periodical from the table before deleting it.";
            $periodical_message_class = "alert-danger";
        } else {
            $delete_periodical = mysqli_prepare($conn, "DELETE FROM periodicals WHERE ISSN = ?");
            mysqli_stmt_bind_param($delete_periodical, "s", $issn);

            if (mysqli_stmt_execute($delete_periodical)) {
                $periodical_message = "Periodical deleted successfully.";
                $periodical_message_class = "alert-success";
            } else {
                $periodical_message = "Error while deleting periodical: " . mysqli_stmt_error($delete_periodical);
                $periodical_message_class = "alert-danger";
            }
            mysqli_stmt_close($delete_periodical);
        }
    }

    if (isset($_POST['update_publication'])) {
        $bookFields = compact(
            'pub_id',
            'title',
            'series',
            'edition',
            'date_published',
            'shelf_location',
            'language_used',
            'publisher_id',
            'subtitle',
            'pages',
            'copyright_date',
            'publisher',
            'place_of_publication',
            'class_no',
            'call_no',
            'category',
            'audience_type'
        );
        $bookFields['ISBN'] = $isbn;
        $book_form_error = dashboardBookFormError($bookFields);
        $audience_type_error = $audience_type_choice === 'Other' && $audience_type === null
            ? 'Enter an audience type in the Other field.'
            : ($audience_type_choice !== '' && !in_array($audience_type_choice, array_merge($audience_type_options, ['Other']), true)
                ? 'Choose an audience type from the list.'
                : null);

        if (!dashboardIdentifierFormatIsValid($pub_id)) {
            $publication_message = "Publication ID is invalid. Enter PUB followed by digits, for example PUB131.";
            $publication_message_class = "alert-danger";
        } elseif (!dashboardIsbnFormatIsValid((string)$isbn)) {
            $publication_message = "ISBN is invalid. Enter the ISBN- prefix followed by the identifier, for example ISBN-978-621-12-3456-7.";
            $publication_message_class = "alert-danger";
        } elseif ($original_pub_id === '') {
            $publication_message = "Select a book from the table before saving changes.";
            $publication_message_class = "alert-danger";
        } elseif ($book_form_error !== null) {
            $publication_message = $book_form_error;
            $publication_message_class = "alert-danger";
        } elseif ($audience_type_error !== null) {
            $publication_message = $audience_type_error;
            $publication_message_class = "alert-danger";
        } elseif (!dashboardValueExists($conn, "SELECT 1 FROM books WHERE pub_id = ?", $original_pub_id)) {
            $publication_message = "The selected book could not be found. Refresh the page and select it again.";
            $publication_message_class = "alert-danger";
        } elseif (dashboardValueExists($conn, "SELECT 1 FROM publication WHERE pub_id = ? AND pub_id <> ?", $pub_id, $original_pub_id)) {
            $publication_message = "Publication ID ($pub_id) is already in use. Enter a different ID.";
            $publication_message_class = "alert-danger";
        } elseif (dashboardIdentifierIsInUse($conn, $pub_id, null, null, $original_pub_id)) {
            $publication_message = "Publication ID ($pub_id) is already in use as another identifier. Enter a different ID.";
            $publication_message_class = "alert-danger";
        } elseif (dashboardIdentifierIsInUse($conn, $isbn, $original_pub_id)) {
            $publication_message = "ISBN ($isbn) is already in use. Enter a unique ISBN.";
            $publication_message_class = "alert-danger";
        } else {
            mysqli_begin_transaction($conn);
            $update = mysqli_prepare($conn, "
                UPDATE publication
                SET pub_id=?, title=?, series=?, edition=?, date_published=?, shelf_location=?, language_used=?, publisher_id=?, subtitle=?, pages=?, copyright_date=?, publisher=?, place_of_publication=?
                WHERE pub_id=?
            ");
            mysqli_stmt_bind_param($update, "sssssssss" . "iisss", $pub_id, $title, $series, $edition, $date_published, $shelf_location, $language_used, $publisher_id, $subtitle, $pages, $copyright_date, $publisher, $place_of_publication, $original_pub_id);

            if (mysqli_stmt_execute($update)) {
                $update_book = mysqli_prepare($conn, "
                    UPDATE books
                    SET class_no = ?, call_no = ?, ISBN = ?, category = ?, audience_type = ?, updated_at = CURRENT_TIMESTAMP
                    WHERE pub_id = ?
                ");
                mysqli_stmt_bind_param($update_book, "ssssss", $class_no, $call_no, $isbn, $category, $audience_type, $pub_id);

                if (mysqli_stmt_execute($update_book)) {
                    mysqli_commit($conn);
                    $publication_message = "Book updated successfully.";
                    $publication_message_class = "alert-success";
                } else {
                    mysqli_rollback($conn);
                    $publication_message = "Error while updating book details: " . mysqli_stmt_error($update_book);
                    $publication_message_class = "alert-danger";
                }
                mysqli_stmt_close($update_book);
            } else {
                mysqli_rollback($conn);
                $publication_message = "Error while updating publication: " . mysqli_stmt_error($update);
                $publication_message_class = "alert-danger";
            }
            mysqli_stmt_close($update);
        }
    }

    if (isset($_POST['delete_publication'])) {
        if (empty($pub_id)) {
            $publication_message = "Select a book from the table before deleting it.";
            $publication_message_class = "alert-danger";
        } else {
            $linked_records = mysqli_prepare($conn, "
                SELECT
                    (SELECT COUNT(*) FROM books WHERE pub_id = ?) +
                    (SELECT COUNT(*) FROM periodicals WHERE pub_id = ?) +
                    (SELECT COUNT(*) FROM `pub author` WHERE pub_id = ?) +
                    (SELECT COUNT(*) FROM `pub copies` WHERE pub_id = ?)
            ");
            mysqli_stmt_bind_param($linked_records, "ssss", $pub_id, $pub_id, $pub_id, $pub_id);
            mysqli_stmt_execute($linked_records);
            mysqli_stmt_bind_result($linked_records, $linked_record_count);
            mysqli_stmt_fetch($linked_records);
            mysqli_stmt_close($linked_records);

            if ($linked_record_count > 0) {
                $publication_message = "Unable to delete publication while linked book, copy, author, periodical, or fine records exist.";
                $publication_message_class = "alert-danger";
            } else {
                $delete = mysqli_prepare($conn, "DELETE FROM publication WHERE pub_id = ?");
                mysqli_stmt_bind_param($delete, "s", $pub_id);

                if (mysqli_stmt_execute($delete)) {
                    $publication_message = "Publication deleted successfully.";
                    $publication_message_class = "alert-success";
                } else {
                    $publication_message = "Error while deleting publication: " . mysqli_stmt_error($delete);
                    $publication_message_class = "alert-danger";
                }
                mysqli_stmt_close($delete);
            }
        }
    }
}

/* SEARCH & FETCH LOGIC FOR THE TABLE */
$search_query = $_GET['search'] ?? '';
$view = ($_GET['view'] ?? '') === 'periodicals' ? 'periodicals' : 'books';
$sort_options = [
    'recently_added' => 'Recently Added',
    'recently_updated' => 'Recently Updated',
    'oldest_added' => 'Oldest Added',
    'oldest_updated' => 'Oldest Updated',
    'newest_published' => 'Newest Published',
    'oldest_published' => 'Oldest Published',
    'recently_acquired' => 'Recently Acquired',
    'az' => 'A–Z',
    'za' => 'Z–A'
];
$book_sort_orders = [
    'recently_added' => 'books.created_at DESC',
    'recently_updated' => 'books.updated_at DESC',
    'oldest_added' => 'books.created_at ASC',
    'oldest_updated' => 'books.updated_at ASC',
    'newest_published' => 'publication.date_published DESC',
    'oldest_published' => 'publication.date_published ASC',
    'recently_acquired' => 'books.acquired_at DESC',
    'az' => 'publication.title ASC',
    'za' => 'publication.title DESC'
];
$periodical_sort_orders = [
    'recently_added' => 'periodicals.created_at DESC',
    'recently_updated' => 'periodicals.updated_at DESC',
    'oldest_added' => 'periodicals.created_at ASC',
    'oldest_updated' => 'periodicals.updated_at ASC',
    'newest_published' => 'publication.date_published DESC',
    'oldest_published' => 'publication.date_published ASC',
    'recently_acquired' => 'periodicals.acquired_at DESC',
    'az' => 'publication.title ASC',
    'za' => 'publication.title DESC'
];
$book_sort = $_GET['book_sort'] ?? 'recently_added';
$book_sort = is_string($book_sort) && isset($book_sort_orders[$book_sort]) ? $book_sort : 'recently_added';
$periodical_sort = $_GET['periodical_sort'] ?? 'recently_added';
$periodical_sort = is_string($periodical_sort) && isset($periodical_sort_orders[$periodical_sort]) ? $periodical_sort : 'recently_added';
$book_order_by = $book_sort_orders[$book_sort] . ', publication.pub_id ASC';
$periodical_order_by = $periodical_sort_orders[$periodical_sort] . ', periodicals.ISSN ASC';
$publication_status_query = "
    SELECT
        publication.*,
        COALESCE(book_status_summary.book_status, 'Available') AS book_status,
        books.class_no,
        books.call_no,
        books.ISBN,
        books.category,
        books.audience_type,
        books.created_at,
        books.updated_at,
        books.acquired_at
    FROM publication
    INNER JOIN books ON books.pub_id = publication.pub_id
    LEFT JOIN periodicals ON periodicals.pub_id = publication.pub_id
    LEFT JOIN (
        SELECT pc.pub_id,
               CASE WHEN SUM(s.status_type = 'Borrowed') > 0 THEN 'Borrowed' ELSE 'Available' END AS book_status
        FROM `pub copies` pc
        LEFT JOIN status s ON s.status_id = pc.status_id
        GROUP BY pc.pub_id
    ) AS book_status_summary ON book_status_summary.pub_id = publication.pub_id
    WHERE periodicals.pub_id IS NULL
";

if (!empty($search_query)) {
    $sql = $publication_status_query . "
            AND (
                   publication.pub_id LIKE ?
                OR publication.title LIKE ?
                OR publication.subtitle LIKE ?
                OR publication.language_used LIKE ?
                OR book_status_summary.book_status LIKE ?
                OR books.class_no LIKE ?
                OR books.call_no LIKE ?
                OR books.ISBN LIKE ?
                OR books.category LIKE ?
                OR books.audience_type LIKE ?
            )
            ORDER BY $book_order_by";
    
    $stmt_search = mysqli_prepare($conn, $sql);
    $search_param = "%" . $search_query . "%";
    mysqli_stmt_bind_param($stmt_search, "ssssssssss", $search_param, $search_param, $search_param, $search_param, $search_param, $search_param, $search_param, $search_param, $search_param, $search_param);
    mysqli_stmt_execute($stmt_search);
    $result = mysqli_stmt_get_result($stmt_search);
} else {
    $sql = $publication_status_query . " ORDER BY $book_order_by";
    $result = mysqli_query($conn, $sql);
}

$periodical_search_query = trim($_GET['periodical_search'] ?? '');
$periodicals_sql = "
    SELECT
        periodicals.ISSN,
        periodicals.peridodic_type,
        publication.pub_id,
        publication.title,
        publication.series,
        publication.edition,
        publication.date_published,
        publication.shelf_location,
        publication.language_used,
        publication.publisher_id,
        publication.subtitle,
        publication.pages,
        publication.copyright_date,
        publication.publisher,
        publication.place_of_publication,
        periodicals.created_at,
        periodicals.updated_at,
        periodicals.acquired_at,
        COALESCE(book_status_summary.book_status, 'Available') AS book_status
    FROM periodicals
    INNER JOIN publication ON publication.pub_id = periodicals.pub_id
    LEFT JOIN (
        SELECT pc.pub_id,
               CASE WHEN SUM(s.status_type = 'Borrowed') > 0 THEN 'Borrowed' ELSE 'Available' END AS book_status
        FROM `pub copies` pc
        LEFT JOIN status s ON s.status_id = pc.status_id
        GROUP BY pc.pub_id
    ) AS book_status_summary ON book_status_summary.pub_id = publication.pub_id
";

if ($periodical_search_query !== '') {
    $periodicals_stmt = mysqli_prepare($conn, $periodicals_sql . "
        WHERE periodicals.ISSN LIKE ?
           OR periodicals.pub_id LIKE ?
           OR publication.title LIKE ?
           OR publication.subtitle LIKE ?
           OR publication.language_used LIKE ?
           OR publication.publisher_id LIKE ?
           OR publication.publisher LIKE ?
           OR publication.place_of_publication LIKE ?
           OR periodicals.peridodic_type LIKE ?
        ORDER BY $periodical_order_by
    ");
    $periodical_search_param = "%" . $periodical_search_query . "%";
    mysqli_stmt_bind_param(
        $periodicals_stmt,
        "sssssssss",
        $periodical_search_param,
        $periodical_search_param,
        $periodical_search_param,
        $periodical_search_param,
        $periodical_search_param,
        $periodical_search_param,
        $periodical_search_param,
        $periodical_search_param,
        $periodical_search_param
    );
    mysqli_stmt_execute($periodicals_stmt);
    $periodicals_result = mysqli_stmt_get_result($periodicals_stmt);
} else {
    $periodicals_result = mysqli_query($conn, $periodicals_sql . " ORDER BY $periodical_order_by");
}
$publication_options_sql = "
    SELECT
        publication.pub_id,
        publication.title,
        publication.subtitle,
        publication.language_used,
        publication.shelf_location,
        publication.pages,
        publication.series,
        publication.edition,
        publication.publisher_id,
        publication.publisher,
        publication.place_of_publication,
        publication.date_published,
        publication.copyright_date,
        COALESCE(book_status_summary.book_status, 'Available') AS book_status
    FROM publication
    LEFT JOIN (
        SELECT pc.pub_id,
               CASE WHEN SUM(s.status_type = 'Borrowed') > 0 THEN 'Borrowed' ELSE 'Available' END AS book_status
        FROM `pub copies` pc
        LEFT JOIN status s ON s.status_id = pc.status_id
        GROUP BY pc.pub_id
    ) AS book_status_summary ON book_status_summary.pub_id = publication.pub_id
";
$publication_options_result = mysqli_query($conn, $publication_options_sql);
$publication_details = [];
while ($publication_option = mysqli_fetch_assoc($publication_options_result)) {
    $publication_details[$publication_option['pub_id']] = $publication_option;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $view === 'periodicals' ? 'Periodicals' : 'Books'; ?> | BookTrace</title>
    <link rel="stylesheet" href="../css/librarian_dashboard.css?v=20261121-1">
    <link rel="stylesheet" href="../css/header.css">
    <link rel="stylesheet" href="../css/dialog.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
        
</head>
<body>

<?php require __DIR__ . '/includes/header.php'; ?>

<main class="dashboard-container">

    <div class="modal-overlay" id="add-publication-modal" aria-hidden="true">
        <section class="update-modal" role="dialog" aria-modal="true" aria-labelledby="add-publication-modal-title">
            <div class="modal-header">
                <div>
                    <h2 id="add-publication-modal-title">Add Book</h2>
                    <p>Enter the book and publication details.</p>
                </div>
                <button type="button" class="modal-close" id="close-add-publication-modal" aria-label="Close">&times;</button>
            </div>
            <form method="POST" class="book-form modal-form" novalidate>
                <div class="form-field">
                    <input type="text" name="pub_id" placeholder="Publication ID (PUB...)" maxlength="20" pattern="PUB[0-9]+" aria-describedby="add-book-pub-id-hint" required>
                    <small class="field-hint" id="add-book-pub-id-hint">Format: PUB followed by digits, e.g. PUB131.</small>
                </div>
                <input type="text" name="title" placeholder="Book Title" maxlength="100" required>
                <input type="text" name="subtitle" placeholder="Subtitle" maxlength="255">
                <input type="text" name="language_used" placeholder="Language Used" maxlength="50" required>
                <input type="text" name="shelf_location" placeholder="Shelf Location" maxlength="30" required>
                <div class="number-stepper">
                    <input type="number" name="pages" placeholder="Pages" min="1" max="2147483647" step="1" required>
                    <div class="number-stepper-actions" aria-label="Adjust pages">
                        <button type="button" data-number-step="1" aria-label="Increase pages">+</button>
                        <button type="button" data-number-step="-1" aria-label="Decrease pages">&minus;</button>
                    </div>
                </div>
                <input type="text" name="series" placeholder="Series" maxlength="100">
                <input type="text" name="edition" placeholder="Edition (e.g. 1st)" maxlength="30">
                <input type="text" name="publisher_id" placeholder="Publisher ID" maxlength="30">
                <input type="text" name="publisher" placeholder="Publisher Name" maxlength="100">
                <input type="text" name="place_of_publication" placeholder="Place of Publication" maxlength="100">

                <div class="date-group">
                    <label for="add-date-published">Date Published</label>
                    <div class="date-input-control">
                        <input type="date" name="date_published" id="add-date-published" required>
                        <button type="button" data-open-date-picker aria-label="Open publication date calendar">
                            <i class="bi bi-calendar3" aria-hidden="true"></i>
                        </button>
                    </div>
                </div>
                <div class="date-group">
                    <label for="add-copyright-date">Copyright Year</label>
                    <input type="number" name="copyright_date" id="add-copyright-date" placeholder="YYYY" min="1000" max="2099" step="1" required>
                </div>
                <div class="status-toggle">
                    <span class="status-toggle-label">Status</span>
                    <div class="status-switch" data-status-display aria-live="polite">
                        <span class="status-switch-indicator" aria-hidden="true"></span>
                        <span class="status-switch-label" data-status-label>Available</span>
                    </div>
                </div>
                <input type="text" name="class_no" placeholder="Class No." maxlength="50" required>
                <input type="text" name="call_no" placeholder="Call No." maxlength="50" required>
                <div class="form-field">
                    <input type="text" name="ISBN" placeholder="ISBN-..." maxlength="25" pattern="ISBN-[A-Za-z0-9][A-Za-z0-9 ./-]*" aria-describedby="add-book-isbn-hint" required>
                    <small class="field-hint" id="add-book-isbn-hint">Include ISBN- at the start, e.g. ISBN-978-621-12-3456-7.</small>
                </div>
                <div class="form-field category-field">
                    <label for="add-book-category">Category</label>
                    <select name="category" id="add-book-category" required>
                        <option value="" disabled selected>Choose a category</option>
                        <option value="Academic">Academic</option>
                        <option value="Non-Academic">Non-Academic</option>
                    </select>
                </div>
                <div class="form-field category-field audience-field">
                    <label for="add-book-audience-type">Audience Type</label>
                    <select name="audience_type_choice" id="add-book-audience-type">
                        <option value="" selected>Choose an audience</option>
                        <option value="Students">Students</option>
                        <option value="Teachers">Teachers</option>
                        <option value="Researchers">Researchers</option>
                        <option value="Professionals">Professionals</option>
                        <option value="General Public">General Public</option>
                        <option value="Other">Other</option>
                    </select>
                    <input type="text" name="audience_type_custom" id="add-book-audience-custom" placeholder="Enter audience type" maxlength="50" hidden>
                </div>
                <div class="modal-actions">
                    <button type="button" class="modal-cancel" id="cancel-add-publication-modal">Cancel</button>
                    <button type="submit" name="add_publication" class="submit-btn">
                        <i class="bi bi-plus-lg"></i> Add Book
                    </button>
                </div>
            </form>
        </section>
    </div>

    <div class="modal-overlay" id="add-periodical-modal" aria-hidden="true">
        <section class="update-modal" role="dialog" aria-modal="true" aria-labelledby="add-periodical-modal-title">
            <div class="modal-header">
                <div>
                    <h2 id="add-periodical-modal-title">Add Periodical</h2>
                    <p>Link the periodical record to a publication.</p>
                </div>
                <button type="button" class="modal-close" id="close-add-periodical-modal" aria-label="Close">&times;</button>
            </div>
            <form method="POST" class="book-form modal-form" novalidate>
                <div class="form-field">
                    <input type="text" name="pub_id" id="add-periodical-publication" placeholder="Publication ID (PUB...)" maxlength="20" pattern="PUB[0-9]+" aria-describedby="add-periodical-pub-id-hint" required>
                    <small class="field-hint" id="add-periodical-pub-id-hint">Format: PUB followed by digits, e.g. PUB131.</small>
                </div>
                <input type="text" data-publication-field="title" placeholder="Publication Title" readonly>
                <input type="text" data-publication-field="subtitle" placeholder="Subtitle" readonly>
                <input type="text" data-publication-field="language_used" placeholder="Language Used" readonly>
                <input type="text" data-publication-field="shelf_location" placeholder="Shelf Location" readonly>
                <input type="text" data-publication-field="pages" placeholder="Pages" readonly>
                <input type="text" data-publication-field="series" placeholder="Series" readonly>
                <input type="text" data-publication-field="edition" placeholder="Edition" readonly>
                <input type="text" data-publication-field="publisher_id" placeholder="Publisher ID" readonly>
                <input type="text" data-publication-field="publisher" placeholder="Publisher Name" readonly>
                <input type="text" data-publication-field="place_of_publication" placeholder="Place of Publication" readonly>
                <div class="date-group">
                    <label for="add-periodical-date-published">Date Published</label>
                    <div class="date-input-control">
                        <input type="date" id="add-periodical-date-published" data-publication-field="date_published" readonly aria-readonly="true">
                        <button type="button" disabled aria-label="Publication date is read-only">
                            <i class="bi bi-calendar3" aria-hidden="true"></i>
                        </button>
                    </div>
                </div>
                <div class="date-group">
                    <label for="add-periodical-copyright-year">Copyright Year</label>
                    <div class="number-stepper">
                        <input type="number" id="add-periodical-copyright-year" data-publication-field="copyright_date" placeholder="YYYY" min="1000" max="2099" readonly aria-readonly="true">
                        <div class="number-stepper-actions" aria-hidden="true">
                            <button type="button" disabled>+</button>
                            <button type="button" disabled>&minus;</button>
                        </div>
                    </div>
                </div>
                <div class="status-toggle">
                    <span class="status-toggle-label">Status</span>
                    <div class="status-switch" data-publication-field="book_status" data-status-display aria-live="polite">
                        <span class="status-switch-indicator" aria-hidden="true"></span>
                        <span class="status-switch-label" data-status-label>Available</span>
                    </div>
                </div>
                <div class="form-field">
                    <input type="text" name="ISSN" placeholder="ISSN-..." maxlength="20" pattern="ISSN-[A-Za-z0-9][A-Za-z0-9 ./-]*" aria-describedby="add-periodical-issn-hint" required>
                    <small class="field-hint" id="add-periodical-issn-hint">Include ISSN- at the start, e.g. ISSN-2094-1011.</small>
                </div>
                <div class="form-field category-field">
                    <label for="add-periodical-type">Periodical Type</label>
                    <select name="peridodic_type" id="add-periodical-type" required>
                        <option value="" disabled selected>Choose a periodical type</option>
                        <?php foreach (dashboardPeriodicalTypes() as $periodicalType): ?>
                            <option value="<?php echo htmlspecialchars($periodicalType); ?>"><?php echo htmlspecialchars($periodicalType); ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="modal-actions">
                    <button type="button" class="modal-cancel" id="cancel-add-periodical-modal">Cancel</button>
                    <button type="submit" name="add_periodical" class="submit-btn">
                        <i class="bi bi-plus-lg"></i> Add Periodical
                    </button>
                </div>
            </form>
        </section>
    </div>

    <div class="modal-overlay" id="update-periodical-modal" aria-hidden="true">
        <section class="update-modal" role="dialog" aria-modal="true" aria-labelledby="update-periodical-modal-title">
            <div class="modal-header">
                <div>
                    <h2 id="update-periodical-modal-title">Update Periodical</h2>
                    <p>Edit the selected periodical details.</p>
                </div>
                <button type="button" class="modal-close" id="close-update-periodical-modal" aria-label="Close">&times;</button>
            </div>
            <form method="POST" class="book-form modal-form" novalidate>
                <input type="hidden" name="original_issn" id="update-original-issn">
                <input type="hidden" name="original_pub_id" id="update-periodical-original-pub-id">
                <div class="form-field">
                    <input type="text" name="ISSN" id="update-periodical-issn" placeholder="ISSN-..." maxlength="20" pattern="ISSN-[A-Za-z0-9][A-Za-z0-9 ./-]*" aria-describedby="update-periodical-issn-hint" required>
                    <small class="field-hint" id="update-periodical-issn-hint">Include ISSN- at the start, e.g. ISSN-2094-1011.</small>
                </div>
                <div class="form-field">
                    <input type="text" name="pub_id" id="update-periodical-publication" placeholder="Publication ID (PUB...)" maxlength="20" pattern="PUB[0-9]+" aria-describedby="update-periodical-pub-id-hint" required>
                    <small class="field-hint" id="update-periodical-pub-id-hint">Format: PUB followed by digits, e.g. PUB131.</small>
                </div>
                <input type="text" data-publication-field="title" placeholder="Publication Title" readonly>
                <input type="text" data-publication-field="subtitle" placeholder="Subtitle" readonly>
                <input type="text" data-publication-field="language_used" placeholder="Language Used" readonly>
                <input type="text" data-publication-field="shelf_location" placeholder="Shelf Location" readonly>
                <input type="text" data-publication-field="pages" placeholder="Pages" readonly>
                <input type="text" data-publication-field="series" placeholder="Series" readonly>
                <input type="text" data-publication-field="edition" placeholder="Edition" readonly>
                <input type="text" data-publication-field="publisher_id" placeholder="Publisher ID" readonly>
                <input type="text" data-publication-field="publisher" placeholder="Publisher Name" readonly>
                <input type="text" data-publication-field="place_of_publication" placeholder="Place of Publication" readonly>
                <div class="date-group">
                    <label for="update-periodical-date-published">Date Published</label>
                    <div class="date-input-control">
                        <input type="date" id="update-periodical-date-published" data-publication-field="date_published" readonly aria-readonly="true">
                        <button type="button" disabled aria-label="Publication date is read-only">
                            <i class="bi bi-calendar3" aria-hidden="true"></i>
                        </button>
                    </div>
                </div>
                <div class="date-group">
                    <label for="update-periodical-copyright-year">Copyright Year</label>
                    <div class="number-stepper">
                        <input type="number" id="update-periodical-copyright-year" data-publication-field="copyright_date" placeholder="YYYY" min="1000" max="2099" readonly aria-readonly="true">
                        <div class="number-stepper-actions" aria-hidden="true">
                            <button type="button" disabled>+</button>
                            <button type="button" disabled>&minus;</button>
                        </div>
                    </div>
                </div>
                <div class="status-toggle">
                    <span class="status-toggle-label">Status</span>
                    <div class="status-switch" data-publication-field="book_status" data-status-display aria-live="polite">
                        <span class="status-switch-indicator" aria-hidden="true"></span>
                        <span class="status-switch-label" data-status-label>Available</span>
                    </div>
                </div>
                <div class="form-field category-field">
                    <label for="update-periodical-type">Periodical Type</label>
                    <select name="peridodic_type" id="update-periodical-type" required>
                        <option value="" disabled>Choose a periodical type</option>
                        <?php foreach (dashboardPeriodicalTypes() as $periodicalType): ?>
                            <option value="<?php echo htmlspecialchars($periodicalType); ?>"><?php echo htmlspecialchars($periodicalType); ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="modal-actions">
                    <button type="button" class="modal-cancel" id="cancel-update-periodical-modal">Cancel</button>
                    <button type="submit" name="update_periodical" class="submit-btn">
                        <i class="bi bi-check-lg"></i> Save Changes
                    </button>
                </div>
            </form>
        </section>
    </div>

    <div class="modal-overlay" id="periodical-selection-warning-modal" aria-hidden="true">
        <section class="selection-warning" role="alertdialog" aria-modal="true" aria-labelledby="periodical-selection-warning-title">
            <div class="warning-icon"><i class="bi bi-exclamation-lg"></i></div>
            <h2 id="periodical-selection-warning-title">No Periodical Selected</h2>
            <p>Select a periodical from the Periodicals table first.</p>
            <button type="button" class="submit-btn" id="close-periodical-selection-warning">OK</button>
        </section>
    </div>

    <div class="modal-overlay" id="update-modal" aria-hidden="true">
        <section class="update-modal" role="dialog" aria-modal="true" aria-labelledby="update-modal-title">
            <div class="modal-header">
                <div>
                    <h2 id="update-modal-title">Update Book</h2>
                    <p>Edit the selected book and publication details.</p>
                </div>
                <button type="button" class="modal-close" id="close-update-modal" aria-label="Close">&times;</button>
            </div>

            <form method="POST" class="book-form modal-form" novalidate>
                <input type="hidden" name="original_pub_id" id="modal_original_pub_id">
                <div class="form-field">
                    <input type="text" name="pub_id" id="modal_pub_id" placeholder="Publication ID (PUB...)" maxlength="20" pattern="PUB[0-9]+" aria-describedby="update-book-pub-id-hint" required>
                    <small class="field-hint" id="update-book-pub-id-hint">Format: PUB followed by digits, e.g. PUB131.</small>
                </div>
                <input type="text" name="title" id="modal_title" placeholder="Book Title" maxlength="100" required>
                <input type="text" name="subtitle" id="modal_subtitle" placeholder="Subtitle" maxlength="255">
                <input type="text" name="language_used" id="modal_language" placeholder="Language Used" maxlength="50" required>
                <input type="text" name="shelf_location" id="modal_shelf" placeholder="Shelf Location" maxlength="30" required>
                <div class="number-stepper">
                    <input type="number" name="pages" id="modal_pages" placeholder="Pages" min="1" max="2147483647" step="1" required>
                    <div class="number-stepper-actions" aria-label="Adjust pages">
                        <button type="button" data-number-step="1" aria-label="Increase pages">+</button>
                        <button type="button" data-number-step="-1" aria-label="Decrease pages">&minus;</button>
                    </div>
                </div>
                <input type="text" name="series" id="modal_series" placeholder="Series" maxlength="100">
                <input type="text" name="edition" id="modal_edition" placeholder="Edition (e.g. 1st)" maxlength="30">
                <input type="text" name="publisher_id" id="modal_publisher" placeholder="Publisher ID" maxlength="30">
                <input type="text" name="publisher" id="modal_publisher_name" placeholder="Publisher Name" maxlength="100">
                <input type="text" name="place_of_publication" id="modal_place_of_publication" placeholder="Place of Publication" maxlength="100">

                <div class="date-group">
                    <label for="modal_date_published">Date Published</label>
                    <div class="date-input-control">
                        <input type="date" name="date_published" id="modal_date_published" required>
                        <button type="button" data-open-date-picker aria-label="Open publication date calendar">
                            <i class="bi bi-calendar3" aria-hidden="true"></i>
                        </button>
                    </div>
                </div>

                <div class="date-group">
                    <label for="modal_copyright">Copyright Year</label>
                    <input type="number" name="copyright_date" id="modal_copyright" placeholder="YYYY" min="1000" max="2099" step="1" required>
                </div>
                <div class="status-toggle">
                    <span class="status-toggle-label">Status</span>
                    <div class="status-switch" id="modal_status" data-status-display aria-live="polite">
                        <span class="status-switch-indicator" aria-hidden="true"></span>
                        <span class="status-switch-label" data-status-label>Available</span>
                    </div>
                </div>
                <input type="text" name="class_no" id="modal_class_no" placeholder="Class No." maxlength="50" required>
                <input type="text" name="call_no" id="modal_call_no" placeholder="Call No." maxlength="50" required>
                <div class="form-field">
                    <input type="text" name="ISBN" id="modal_isbn" placeholder="ISBN-..." maxlength="25" pattern="ISBN-[A-Za-z0-9][A-Za-z0-9 ./-]*" aria-describedby="update-book-isbn-hint" required>
                    <small class="field-hint" id="update-book-isbn-hint">Include ISBN- at the start, e.g. ISBN-978-621-12-3456-7.</small>
                </div>
                <div class="form-field category-field">
                    <label for="modal_category">Category</label>
                    <select name="category" id="modal_category" required>
                        <option value="" disabled>Choose a category</option>
                        <option value="Academic">Academic</option>
                        <option value="Non-Academic">Non-Academic</option>
                    </select>
                </div>
                <div class="form-field category-field audience-field">
                    <label for="modal_audience_type">Audience Type</label>
                    <select name="audience_type_choice" id="modal_audience_type">
                        <option value="">Choose an audience</option>
                        <option value="Students">Students</option>
                        <option value="Teachers">Teachers</option>
                        <option value="Researchers">Researchers</option>
                        <option value="Professionals">Professionals</option>
                        <option value="General Public">General Public</option>
                        <option value="Other">Other</option>
                    </select>
                    <input type="text" name="audience_type_custom" id="modal_audience_type_custom" placeholder="Enter audience type" maxlength="50" hidden>
                </div>

                <div class="modal-actions">
                    <button type="button" class="modal-cancel" id="cancel-update-modal">Cancel</button>
                    <button type="submit" name="update_publication" class="submit-btn">
                        <i class="bi bi-check-lg"></i> Save Changes
                    </button>
                </div>
            </form>
        </section>
    </div>

    <div class="modal-overlay" id="selection-warning-modal" aria-hidden="true">
        <section class="selection-warning" role="alertdialog" aria-modal="true" aria-labelledby="selection-warning-title" aria-describedby="selection-warning-message">
            <div class="warning-icon"><i class="bi bi-exclamation-lg"></i></div>
            <h2 id="selection-warning-title">No Book Selected</h2>
<p id="selection-warning-message">Please select a book from the Books table first.</p>
<button type="button" class="submit-btn" id="close-selection-warning">OK</button>
</section>
    </div>

    <div class="modal-overlay" id="details-modal" aria-hidden="true">
        <section class="update-modal details-modal" role="dialog" aria-modal="true" aria-labelledby="details-modal-title">
            <div class="modal-header">
                <div>
                    <h2 id="details-modal-title">Book Details</h2>
                    <p id="details-modal-subtitle"></p>
                </div>
                <button type="button" class="modal-close" id="close-details-modal" aria-label="Close">&times;</button>
            </div>
            <div id="details-body"></div>
            <div class="modal-actions">
                <button type="button" class="modal-cancel" id="details-close-btn">Close</button>
                <button type="button" class="submit-btn details-delete" id="details-delete-btn"><i class="bi bi-trash3-fill"></i> Delete</button>
                <button type="button" class="submit-btn" id="details-update-btn"><i class="bi bi-pencil-square"></i> Update</button>
            </div>
        </section>
    </div>

    <form method="POST" id="delete-publication-form" hidden>
        <input type="hidden" name="pub_id" id="delete-publication-id">
        <input type="hidden" name="delete_publication" value="1">
    </form>
    <form method="POST" id="delete-periodical-form" hidden>
        <input type="hidden" name="ISSN" id="delete-periodical-issn">
        <input type="hidden" name="delete_periodical" value="1">
    </form>

    <section class="table-section" id="books-table"<?php echo $view === 'books' ? '' : ' hidden'; ?>>
        
        <div class="section-header-inline">
            
            <h2 class="section-title">
                <i class="bi bi-book-half"></i> Books
            </h2>
            
            <div class="header-actions-group">
                
                <form method="GET" action="" class="search-form-container sort-preserve-scroll">
                    <input type="hidden" name="periodical_search" value="<?php echo htmlspecialchars($periodical_search_query); ?>">
                    <input type="hidden" name="periodical_sort" value="<?php echo htmlspecialchars($periodical_sort); ?>">
                    <input type="hidden" name="view" value="books">
                    <input type="hidden" name="scroll_position" value="0">
                    <input type="text" name="search" placeholder="Search Title, ID, Subtitle, or Language..." value="<?php echo htmlspecialchars($search_query); ?>" class="search-input-box">
                    <select name="book_sort" class="sort-select" aria-label="Sort books" onchange="this.form.elements.scroll_position.value = Math.round(window.scrollY); this.form.submit()">
                        <?php foreach ($sort_options as $sortValue => $sortLabel): ?>
                            <option value="<?php echo htmlspecialchars($sortValue); ?>" <?php echo $book_sort === $sortValue ? 'selected' : ''; ?>><?php echo htmlspecialchars($sortLabel); ?></option>
                        <?php endforeach; ?>
                    </select>
                    <button type="submit" class="search-submit-btn">
                        <i class="bi bi-search"></i> Search
                    </button>
                    <?php if (!empty($search_query)): ?>
                        <a href="librarian_dashboard.php?<?php echo htmlspecialchars(http_build_query([
                            'view' => 'books',
                            'book_sort' => $book_sort,
                            'periodical_search' => $periodical_search_query,
                            'periodical_sort' => $periodical_sort
                        ])); ?>" class="search-clear-btn">Clear</a>
                    <?php endif; ?>
                </form>

                <button type="button" class="btn-header-action btn-header-update" id="open-add-publication-modal">
                    <i class="bi bi-plus-lg"></i> Add Book
                </button>

                <button type="button" id="open-update-modal" class="btn-header-action btn-header-update">
                    <i class="bi bi-pencil-square"></i> Update
                </button>
                
                <button type="button" id="delete-publication-button" class="btn-header-action btn-header-delete">
                    <i class="bi bi-trash3-fill"></i> Delete
                </button>
            </div>
        </div>

        <?php if (!empty($add_message)): ?>
            <div class="<?php echo $add_message_class; ?> auto-dismiss-message" role="alert" aria-live="assertive">
                <i class="bi <?php echo $add_message_class === 'alert-danger' ? 'bi-exclamation-triangle-fill' : 'bi-check-circle-fill'; ?>" aria-hidden="true"></i>
                <span><?php echo htmlspecialchars($add_message); ?></span>
            </div>
        <?php endif; ?>

        <?php if (!empty($publication_message)): ?>
            <div class="<?php echo $publication_message_class; ?> auto-dismiss-message" role="alert" aria-live="assertive">
                <i class="bi <?php echo $publication_message_class === 'alert-danger' ? 'bi-exclamation-triangle-fill' : 'bi-check-circle-fill'; ?>" aria-hidden="true"></i>
                <span><?php echo htmlspecialchars($publication_message); ?></span>
            </div>
        <?php endif; ?>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Publication ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Language</th>
                        <th>Shelf</th>
                        <th>Status</th>
                        <th>ISBN</th>
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
                        data-subtitle="<?php echo htmlspecialchars($row['subtitle'] ?? ''); ?>"
                        data-language="<?php echo htmlspecialchars($row['language_used']); ?>"
                        data-shelf="<?php echo htmlspecialchars($row['shelf_location']); ?>"
                        data-pages="<?php echo htmlspecialchars($row['pages']); ?>"
                        data-series="<?php echo htmlspecialchars($row['series'] ?? ''); ?>"
                        data-edition="<?php echo htmlspecialchars($row['edition'] ?? ''); ?>"
                        data-publisher="<?php echo htmlspecialchars($row['publisher_id'] ?? ''); ?>"
                        data-publisher-name="<?php echo htmlspecialchars($row['publisher'] ?? ''); ?>"
                        data-place-of-publication="<?php echo htmlspecialchars($row['place_of_publication'] ?? ''); ?>"
                        data-datepub="<?php echo htmlspecialchars($row['date_published']); ?>"
                        data-copyright="<?php echo htmlspecialchars($row['copyright_date']); ?>"
                        data-status="<?php echo htmlspecialchars($row['book_status']); ?>"
                        data-class-no="<?php echo htmlspecialchars($row['class_no'] ?? ''); ?>"
                        data-call-no="<?php echo htmlspecialchars($row['call_no'] ?? ''); ?>"
                        data-isbn="<?php echo htmlspecialchars($row['ISBN'] ?? ''); ?>"
                        data-category="<?php echo htmlspecialchars($row['category'] ?? ''); ?>"
                        data-audience-type="<?php echo htmlspecialchars($row['audience_type'] ?? ''); ?>">
                        
                        <td><strong><?php echo htmlspecialchars($row['pub_id']); ?></strong></td>
                        <td><?php echo htmlspecialchars($row['title']); ?></td>
                        <td><?php echo htmlspecialchars($row['category'] ?? ''); ?></td>
                        <td><?php echo htmlspecialchars($row['language_used']); ?></td>
                        <td><?php echo htmlspecialchars($row['shelf_location']); ?></td>
                        <td><?php echo htmlspecialchars($row['book_status']); ?></td>
                        <td><?php echo htmlspecialchars($row['ISBN'] ?? ''); ?></td>
                    </tr>
                    <?php
                        }
                    } else {
                        echo "<tr><td colspan='7' style='text-align:center;'>No publications found.</td></tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>
    </section>

    <section class="table-section" id="periodicals-table"<?php echo $view === 'periodicals' ? '' : ' hidden'; ?>>
        <div class="section-header-inline">
            <h2 class="section-title"><i class="bi bi-newspaper"></i> Periodicals</h2>
            <div class="header-actions-group">
                <form method="GET" action="" class="search-form-container sort-preserve-scroll">
                    <input type="hidden" name="search" value="<?php echo htmlspecialchars($search_query); ?>">
                    <input type="hidden" name="book_sort" value="<?php echo htmlspecialchars($book_sort); ?>">
                    <input type="hidden" name="view" value="periodicals">
                    <input type="hidden" name="scroll_position" value="0">
                    <input type="text" name="periodical_search" placeholder="Search ISSN, Publication ID, Title, or Type..." value="<?php echo htmlspecialchars($periodical_search_query); ?>" class="search-input-box">
                    <select name="periodical_sort" class="sort-select" aria-label="Sort periodicals" onchange="this.form.elements.scroll_position.value = Math.round(window.scrollY); this.form.submit()">
                        <?php foreach ($sort_options as $sortValue => $sortLabel): ?>
                            <option value="<?php echo htmlspecialchars($sortValue); ?>" <?php echo $periodical_sort === $sortValue ? 'selected' : ''; ?>><?php echo htmlspecialchars($sortLabel); ?></option>
                        <?php endforeach; ?>
                    </select>
                    <button type="submit" class="search-submit-btn">
                        <i class="bi bi-search"></i> Search
                    </button>
                    <?php if ($periodical_search_query !== ''): ?>
                        <a href="librarian_dashboard.php?<?php echo htmlspecialchars(http_build_query([
                            'view' => 'periodicals',
                            'search' => $search_query,
                            'book_sort' => $book_sort,
                            'periodical_sort' => $periodical_sort
                        ])); ?>" class="search-clear-btn">Clear</a>
                    <?php endif; ?>
                </form>

                <button type="button" class="btn-header-action btn-header-update" id="open-add-periodical-modal">
                    <i class="bi bi-plus-lg"></i> Add Periodical
                </button>
                <button type="button" class="btn-header-action btn-header-update" id="open-update-periodical-modal">
                    <i class="bi bi-pencil-square"></i> Update
                </button>
                <button type="button" class="btn-header-action btn-header-delete" id="delete-periodical-button">
                    <i class="bi bi-trash3-fill"></i> Delete
                </button>
            </div>
        </div>

        <?php if (!empty($periodical_message)): ?>
            <div class="<?php echo $periodical_message_class; ?> auto-dismiss-message" role="alert" aria-live="assertive">
                <i class="bi <?php echo $periodical_message_class === 'alert-danger' ? 'bi-exclamation-triangle-fill' : 'bi-check-circle-fill'; ?>" aria-hidden="true"></i>
                <span><?php echo htmlspecialchars($periodical_message); ?></span>
            </div>
        <?php endif; ?>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Publication ID</th>
                        <th>Title</th>
                        <th>Periodical Type</th>
                        <th>ISSN</th>
                        <th>Language</th>
                        <th>Shelf</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (mysqli_num_rows($periodicals_result) > 0): ?>
                        <?php while ($periodical = mysqli_fetch_assoc($periodicals_result)): ?>
                            <tr class="clickable-periodical-row"
                                data-issn="<?php echo htmlspecialchars($periodical['ISSN']); ?>"
                                data-pubid="<?php echo htmlspecialchars($periodical['pub_id']); ?>"
                                data-type="<?php echo htmlspecialchars($periodical['peridodic_type']); ?>"
                                data-title="<?php echo htmlspecialchars($periodical['title']); ?>"
                                data-subtitle="<?php echo htmlspecialchars($periodical['subtitle'] ?? ''); ?>"
                                data-language="<?php echo htmlspecialchars($periodical['language_used']); ?>"
                                data-shelf="<?php echo htmlspecialchars($periodical['shelf_location']); ?>"
                                data-pages="<?php echo htmlspecialchars($periodical['pages']); ?>"
                                data-series="<?php echo htmlspecialchars($periodical['series'] ?? ''); ?>"
                                data-edition="<?php echo htmlspecialchars($periodical['edition'] ?? ''); ?>"
                                data-publisher="<?php echo htmlspecialchars($periodical['publisher_id'] ?? ''); ?>"
                                data-publisher-name="<?php echo htmlspecialchars($periodical['publisher'] ?? ''); ?>"
                                data-place-of-publication="<?php echo htmlspecialchars($periodical['place_of_publication'] ?? ''); ?>"
                                data-datepub="<?php echo htmlspecialchars($periodical['date_published']); ?>"
                                data-copyright="<?php echo htmlspecialchars($periodical['copyright_date']); ?>"
                                data-status="<?php echo htmlspecialchars($periodical['book_status']); ?>">
                                <td><strong><?php echo htmlspecialchars($periodical['pub_id']); ?></strong></td>
                                <td><?php echo htmlspecialchars($periodical['title']); ?></td>
                                <td><?php echo htmlspecialchars($periodical['peridodic_type']); ?></td>
                                <td><?php echo htmlspecialchars($periodical['ISSN']); ?></td>
                                <td><?php echo htmlspecialchars($periodical['language_used']); ?></td>
                                <td><?php echo htmlspecialchars($periodical['shelf_location']); ?></td>
                                <td><?php echo htmlspecialchars($periodical['book_status']); ?></td>
                            </tr>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <tr><td colspan="7" style="text-align:center;"><?php echo $periodical_search_query !== '' ? 'No periodicals match your search.' : 'No periodical records found.'; ?></td></tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </section>

</main>

<?php require __DIR__ . '/includes/confirm_dialog.php'; ?>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const publicationDetails = <?php echo json_encode($publication_details, JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_TAG | JSON_HEX_AMP); ?>;

    document.querySelectorAll(".sort-preserve-scroll").forEach(function(form) {
        form.addEventListener("submit", function() {
            form.querySelector('[name="scroll_position"]').value = String(Math.round(window.scrollY));
        });
    });

    const scrollPosition = Number(new URLSearchParams(window.location.search).get("scroll_position"));
    if (Number.isFinite(scrollPosition) && scrollPosition > 0) {
        window.history.scrollRestoration = "manual";
        window.addEventListener("load", function() {
            window.requestAnimationFrame(function() {
                window.requestAnimationFrame(function() {
                    window.scrollTo(0, scrollPosition);
                });
            });
        }, { once: true });
    }

    document.querySelectorAll(".auto-dismiss-message").forEach(function(message) {
        window.setTimeout(function() {
            message.remove();
        }, 20000);
    });

    document.querySelectorAll(".number-stepper").forEach(function(stepper) {
        const input = stepper.querySelector('input[type="number"]');

        stepper.querySelectorAll("[data-number-step]").forEach(function(button) {
            button.addEventListener("click", function() {
                const step = Number(input.step) || 1;
                const minimum = input.min === "" ? -Infinity : Number(input.min);
                const maximum = input.max === "" ? Infinity : Number(input.max);
                const current = input.value === "" ? minimum : Number(input.value);
                const next = Math.min(maximum, Math.max(minimum, current + Number(button.dataset.numberStep) * step));

                input.value = String(next);
                input.dispatchEvent(new Event("input", { bubbles: true }));
                input.dispatchEvent(new Event("change", { bubbles: true }));
            });
        });
    });

    document.querySelectorAll("[data-open-date-picker]").forEach(function(button) {
        button.addEventListener("click", function() {
            const dateInput = button.parentElement.querySelector('input[type="date"]');
            if (typeof dateInput.showPicker === "function") {
                dateInput.showPicker();
            } else {
                dateInput.focus();
                dateInput.click();
            }
        });
    });

    const rows = document.querySelectorAll(".clickable-row");
    const addPublicationButton = document.getElementById("open-add-publication-modal");
    const addPublicationModal = document.getElementById("add-publication-modal");
    const closeAddPublicationButton = document.getElementById("close-add-publication-modal");
    const cancelAddPublicationButton = document.getElementById("cancel-add-publication-modal");
    const addPeriodicalButton = document.getElementById("open-add-periodical-modal");
    const addPeriodicalModal = document.getElementById("add-periodical-modal");
    const closeAddPeriodicalButton = document.getElementById("close-add-periodical-modal");
    const cancelAddPeriodicalButton = document.getElementById("cancel-add-periodical-modal");
    const addPeriodicalPublicationSelect = document.getElementById("add-periodical-publication");
    const periodicalRows = document.querySelectorAll(".clickable-periodical-row");
    const updatePeriodicalButton = document.getElementById("open-update-periodical-modal");
    const updatePeriodicalModal = document.getElementById("update-periodical-modal");
    const updatePeriodicalPublicationSelect = document.getElementById("update-periodical-publication");
    const closeUpdatePeriodicalButton = document.getElementById("close-update-periodical-modal");
    const cancelUpdatePeriodicalButton = document.getElementById("cancel-update-periodical-modal");
    const periodicalSelectionWarning = document.getElementById("periodical-selection-warning-modal");
    const closePeriodicalSelectionWarning = document.getElementById("close-periodical-selection-warning");
    const deletePeriodicalButton = document.getElementById("delete-periodical-button");
    const deletePeriodicalForm = document.getElementById("delete-periodical-form");
    const deletePeriodicalIssn = document.getElementById("delete-periodical-issn");
    const updateButton = document.getElementById("open-update-modal");
    const updateModal = document.getElementById("update-modal");
    const closeModalButton = document.getElementById("close-update-modal");
    const cancelModalButton = document.getElementById("cancel-update-modal");
    const deleteButton = document.getElementById("delete-publication-button");
    const deleteForm = document.getElementById("delete-publication-form");
    const deletePublicationId = document.getElementById("delete-publication-id");
    const selectionWarningModal = document.getElementById("selection-warning-modal");
    const closeSelectionWarning = document.getElementById("close-selection-warning");
    let selectedRow = null;
    let selectedPeriodicalRow = null;

    function openModal(modal) {
        modal.classList.add("is-open");
        modal.setAttribute("aria-hidden", "false");
    }

    function closeModal(modal) {
        modal.classList.remove("is-open");
        modal.setAttribute("aria-hidden", "true");
    }

    function setStatusDisplay(display, status) {
        const isBorrowed = String(status).toLowerCase() === "borrowed";
        display.classList.toggle("is-borrowed", isBorrowed);
        display.querySelector("[data-status-label]").textContent = isBorrowed ? "Borrowed" : "Available";
    }

    function setAudienceType(select, customInput, value) {
        const standardOptions = Array.from(select.options).map(function(option) {
            return option.value;
        });
        const isStandardOption = standardOptions.includes(value) && value !== "Other";

        select.value = isStandardOption ? value : (value ? "Other" : "");
        customInput.value = value && !isStandardOption ? value : "";
        customInput.hidden = select.value !== "Other";
        customInput.required = select.value === "Other";
    }

    document.querySelectorAll(".audience-field").forEach(function(field) {
        const select = field.querySelector('select[name="audience_type_choice"]');
        const customInput = field.querySelector('input[name="audience_type_custom"]');
        select.addEventListener("change", function() {
            const isOther = select.value === "Other";
            customInput.hidden = !isOther;
            customInput.required = isOther;
            if (!isOther) {
                customInput.value = "";
            } else {
                customInput.focus();
            }
        });
    });

    function populatePeriodicalPublicationFields(modal, publicationSelect) {
        const details = publicationDetails[publicationSelect.value] || {};

        modal.querySelectorAll("[data-publication-field]").forEach(function(field) {
            const value = details[field.dataset.publicationField];
            if (field.hasAttribute("data-status-display")) {
                setStatusDisplay(field, value || "Available");
            } else {
                field.value = value === null || value === undefined ? "" : value;
            }
        });
    }

    addPublicationButton.addEventListener("click", function() {
        openModal(addPublicationModal);
    });
    closeAddPublicationButton.addEventListener("click", function() {
        closeModal(addPublicationModal);
    });
    cancelAddPublicationButton.addEventListener("click", function() {
        closeModal(addPublicationModal);
    });
    addPeriodicalButton.addEventListener("click", function() {
        openModal(addPeriodicalModal);
    });
    closeAddPeriodicalButton.addEventListener("click", function() {
        closeModal(addPeriodicalModal);
    });
    cancelAddPeriodicalButton.addEventListener("click", function() {
        closeModal(addPeriodicalModal);
    });
    addPeriodicalPublicationSelect.addEventListener("input", function() {
        populatePeriodicalPublicationFields(addPeriodicalModal, addPeriodicalPublicationSelect);
    });
    updatePeriodicalPublicationSelect.addEventListener("input", function() {
        populatePeriodicalPublicationFields(updatePeriodicalModal, this);
    });
    closeUpdatePeriodicalButton.addEventListener("click", function() {
        closeModal(updatePeriodicalModal);
    });
    cancelUpdatePeriodicalButton.addEventListener("click", function() {
        closeModal(updatePeriodicalModal);
    });
    closePeriodicalSelectionWarning.addEventListener("click", function() {
        closeModal(periodicalSelectionWarning);
    });

    updatePeriodicalButton.addEventListener("click", function() {
        if (!selectedPeriodicalRow) {
            openModal(periodicalSelectionWarning);
            closePeriodicalSelectionWarning.focus();
            return;
        }

        document.getElementById("update-original-issn").value = selectedPeriodicalRow.dataset.issn;
        document.getElementById("update-periodical-original-pub-id").value = selectedPeriodicalRow.dataset.pubid;
        document.getElementById("update-periodical-issn").value = selectedPeriodicalRow.dataset.issn;
        updatePeriodicalPublicationSelect.value = selectedPeriodicalRow.dataset.pubid;
        populatePeriodicalPublicationFields(
            updatePeriodicalModal,
            updatePeriodicalPublicationSelect
        );
        document.getElementById("update-periodical-type").value = selectedPeriodicalRow.dataset.type;
        openModal(updatePeriodicalModal);
        document.getElementById("update-periodical-issn").focus();
    });

    deletePeriodicalButton.addEventListener("click", async function() {
        if (!selectedPeriodicalRow) {
            openModal(periodicalSelectionWarning);
            closePeriodicalSelectionWarning.focus();
            return;
        }

        const confirmedPeriodical = await bpConfirm({
            title: "Delete Periodical",
            message: "Are you sure you want to delete the selected periodical?",
            buttons: [{ label: "Delete", value: true, kind: "danger" }]
        });
        if (confirmedPeriodical) {
            deletePeriodicalIssn.value = selectedPeriodicalRow.dataset.issn;
            deletePeriodicalForm.submit();
        }
    });

    function closeUpdateModal() {
        closeModal(updateModal);
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
            modal_publisher_name: "publisherName",
            modal_place_of_publication: "placeOfPublication",
            modal_date_published: "datepub",
            modal_class_no: "classNo",
            modal_call_no: "callNo",
            modal_isbn: "isbn",
            modal_category: "category"
        };

        Object.entries(fields).forEach(([id, dataKey]) => {
            document.getElementById(id).value = selectedRow.dataset[dataKey];
        });
        setAudienceType(
            document.getElementById("modal_audience_type"),
            document.getElementById("modal_audience_type_custom"),
            selectedRow.dataset.audienceType
        );
        setStatusDisplay(document.getElementById("modal_status"), selectedRow.dataset.status);
        document.getElementById("modal_original_pub_id").value = selectedRow.dataset.pubid;

        const copyrightValue = selectedRow.dataset.copyright;
        document.getElementById("modal_copyright").value = copyrightValue.includes("-")
            ? copyrightValue.split("-")[0]
            : copyrightValue;
        openModal(updateModal);
        document.getElementById("modal_title").focus();
    });

    deleteButton.addEventListener("click", async function() {
        if (!selectedRow) {
            openModal(selectionWarningModal);
            closeSelectionWarning.focus();
            return;
        }

        const confirmedBook = await bpConfirm({
            title: "Delete Book",
            message: "Are you sure you want to delete the selected publication?",
            buttons: [{ label: "Delete", value: true, kind: "danger" }]
        });
        if (confirmedBook) {
            deletePublicationId.value = selectedRow.dataset.pubid;
            deleteForm.submit();
        }
    });

    closeModalButton.addEventListener("click", closeUpdateModal);
    cancelModalButton.addEventListener("click", closeUpdateModal);
    closeSelectionWarning.addEventListener("click", closeSelectionWarningModal);
    updateModal.addEventListener("click", function(event) {
        if (event.target === updateModal) {
            closeUpdateModal();
        }
    });
    [addPublicationModal, addPeriodicalModal, updatePeriodicalModal].forEach(function(modal) {
        modal.addEventListener("click", function(event) {
            if (event.target === modal) {
                closeModal(modal);
            }
        });
    });
    selectionWarningModal.addEventListener("click", function(event) {
        if (event.target === selectionWarningModal) {
            closeSelectionWarningModal();
        }
    });
    periodicalSelectionWarning.addEventListener("click", function(event) {
        if (event.target === periodicalSelectionWarning) {
            closeModal(periodicalSelectionWarning);
        }
    });
    document.addEventListener("keydown", function(event) {
        if (event.key === "Escape" && updateModal.classList.contains("is-open")) {
            closeUpdateModal();
        }
        [addPublicationModal, addPeriodicalModal, updatePeriodicalModal, periodicalSelectionWarning].forEach(function(modal) {
            if (event.key === "Escape" && modal.classList.contains("is-open")) {
                closeModal(modal);
            }
        });
        if (event.key === "Escape" && selectionWarningModal.classList.contains("is-open")) {
            closeSelectionWarningModal();
        }
    });

    const detailsModal = document.getElementById("details-modal");
    const detailsTitle = document.getElementById("details-modal-title");
    const detailsSubtitle = document.getElementById("details-modal-subtitle");
    const detailsBody = document.getElementById("details-body");
    let detailsKind = "book";

    const detailsGroups = {
        book: [
            ["Basic Info", [["Publication ID", "pubid"], ["Title", "title"], ["Subtitle", "subtitle"], ["Language", "language"], ["Pages", "pages"], ["Shelf", "shelf"]]],
            ["Publishing", [["Publisher ID", "publisher"], ["Publisher", "publisherName"], ["Place of Publication", "placeOfPublication"], ["Date Published", "datepub"], ["Copyright Year", "copyright"], ["Series", "series"], ["Edition", "edition"]]],
            ["Classification", [["Category", "category"], ["Audience Type", "audienceType"], ["Class No.", "classNo"], ["Call No.", "callNo"], ["ISBN", "isbn"], ["Status", "status"]]]
        ],
        periodical: [
            ["Basic Info", [["Publication ID", "pubid"], ["Title", "title"], ["Subtitle", "subtitle"], ["Language", "language"], ["Pages", "pages"], ["Shelf", "shelf"]]],
            ["Publishing", [["Publisher ID", "publisher"], ["Publisher", "publisherName"], ["Place of Publication", "placeOfPublication"], ["Date Published", "datepub"], ["Copyright Year", "copyright"], ["Series", "series"], ["Edition", "edition"]]],
            ["Classification", [["ISSN", "issn"], ["Periodical Type", "type"], ["Status", "status"]]]
        ]
    };

    function escapeHtml(value) {
        const holder = document.createElement("div");
        holder.textContent = value;
        return holder.innerHTML;
    }

    function openDetails(kind, row) {
        detailsKind = kind;
        detailsTitle.textContent = kind === "book" ? "Book Details" : "Periodical Details";
        detailsSubtitle.textContent = row.dataset.title || "";
        detailsBody.innerHTML = detailsGroups[kind].map(function(group) {
            return '<div class="details-group"><h3>' + group[0] + '</h3><dl>' +
                group[1].map(function(field) {
                    const value = row.dataset[field[1]];
                    return '<dt>' + field[0] + '</dt><dd>' + (value ? escapeHtml(value) : '<span class="details-empty">Not provided</span>') + '</dd>';
                }).join("") + '</dl></div>';
        }).join("");
        openModal(detailsModal);
    }

    function closeDetails() {
        closeModal(detailsModal);
    }

    rows.forEach(function(row) {
        row.setAttribute("tabindex", "0");
        row.addEventListener("click", function() {
            rows.forEach(function(r) { r.classList.remove("selected-row"); });
            this.classList.add("selected-row");
            selectedRow = this;
            closeSelectionWarningModal();
            openDetails("book", this);
        });
        row.addEventListener("keydown", function(event) {
            if (event.key === "Enter") {
                this.click();
            }
        });
    });

    periodicalRows.forEach(function(row) {
        row.setAttribute("tabindex", "0");
        row.addEventListener("click", function() {
            periodicalRows.forEach(function(r) { r.classList.remove("selected-row"); });
            this.classList.add("selected-row");
            selectedPeriodicalRow = this;
            closeModal(periodicalSelectionWarning);
            openDetails("periodical", this);
        });
        row.addEventListener("keydown", function(event) {
            if (event.key === "Enter") {
                this.click();
            }
        });
    });

    document.getElementById("close-details-modal").addEventListener("click", closeDetails);
    document.getElementById("details-close-btn").addEventListener("click", closeDetails);
    document.getElementById("details-update-btn").addEventListener("click", function() {
        closeDetails();
        (detailsKind === "book" ? updateButton : updatePeriodicalButton).click();
    });
    document.getElementById("details-delete-btn").addEventListener("click", function() {
        closeDetails();
        (detailsKind === "book" ? deleteButton : deletePeriodicalButton).click();
    });
    detailsModal.addEventListener("click", function(event) {
        if (event.target === detailsModal) {
            closeDetails();
        }
    });
    document.addEventListener("keydown", function(event) {
        if (event.key === "Escape" && detailsModal.classList.contains("is-open")) {
            closeDetails();
        }
    });
});
</script>

</body>
</html>