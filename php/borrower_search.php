<?php
require_once __DIR__ . '/lib/api.php';

const BORROWER_CATEGORIES = ['Student', 'Teacher', 'Researcher', 'Community Resident', 'Other'];

function nullIfEmpty(string $value): ?string
{
    return $value === '' ? null : $value;
}

function normalizeBorrowerId(string $q): ?string
{
    if (preg_match('/^(?:BOR)?\s*(\d{1,6})$/i', $q, $m)) {
        return 'BOR' . str_pad($m[1], 3, '0', STR_PAD_LEFT);
    }
    return null;
}

function resultRow(array $r): array
{
    return [
        'borrower_id' => $r['borrower_id'],
        'name' => $r['borrower_name'],
        'category' => $r['borrower_type'],
        'unpaid' => (float) $r['unpaid_fine_total'] > 0,
        'overdue' => (int) $r['overdue_count'] > 0,
    ];
}

function readBorrowerInput(): array
{
    $keys = ['first_name', 'last_name', 'middle_initial', 'birth_date', 'gender', 'barangay',
             'municipality', 'province', 'email', 'category', 'id_type', 'id_number'];
    $in = [];
    foreach ($keys as $key) {
        $in[$key] = postText($key);
    }
    $in['gender'] = ucfirst(strtolower($in['gender']));
    return $in;
}

function validateBorrowerInput(array $in): ?string
{
    if ($in['first_name'] === '' || $in['last_name'] === '') {
        return 'First name and last name are required.';
    }
    if (strlen($in['first_name']) > 50 || strlen($in['last_name']) > 50) {
        return 'Names must be 50 characters or fewer.';
    }
    if (strlen($in['middle_initial']) > 1) {
        return 'Middle initial must be one character.';
    }
    $birth = DateTime::createFromFormat('Y-m-d', $in['birth_date']);
    if (!$birth || $birth->format('Y-m-d') !== $in['birth_date'] || $birth > new DateTime()) {
        return 'Please enter a valid birth date.';
    }
    if (!in_array($in['gender'], ['Male', 'Female'], true)) {
        return 'Please select a gender.';
    }
    if ($in['email'] !== '' && (!filter_var($in['email'], FILTER_VALIDATE_EMAIL) || strlen($in['email']) > 100)) {
        return 'Please enter a valid email address.';
    }
    foreach (['barangay', 'municipality', 'province'] as $key) {
        if (strlen($in[$key]) > 100) {
            return 'Address parts must be 100 characters or fewer.';
        }
    }
    if (!in_array($in['category'], BORROWER_CATEGORIES, true)) {
        return 'Please select a borrower category.';
    }
    if ($in['id_type'] === '' || $in['id_number'] === '') {
        return 'ID type and ID number are required.';
    }
    if (strlen($in['id_type']) > 100 || strlen($in['id_number']) > 30) {
        return 'ID type or ID number is too long.';
    }
    return null;
}

function borrowerCard(PDO $pdo, string $id): ?array
{
    $stmt = $pdo->prepare('
        SELECT br.borrower_id, br.borrower_type, br.ID_type, br.ID_number,
               u.user_fname, u.user_lname, u.user_midInit, u.birth_date, u.gender, u.email,
               u.user_brgy, u.user_municipality, u.user_province,
               s.active_borrows, s.overdue_count, s.unpaid_fine_total
        FROM borrower br
        JOIN `user` u ON u.user_id = br.user_id
        JOIN v_borrower_status s ON s.borrower_id = br.borrower_id
        WHERE br.borrower_id = ?
    ');
    $stmt->execute([$id]);
    $r = $stmt->fetch();
    if (!$r) {
        return null;
    }

    $stmt = $pdo->prepare('
        SELECT b.borrow_id, b.copy_id, p.title, b.date_borrowed, b.due_date, (b.due_date < NOW()) AS is_overdue
        FROM borrows b
        JOIN borrower br ON br.user_id = b.user_id
        JOIN `pub copies` pc ON pc.copy_id = b.copy_id
        JOIN publication p ON p.pub_id = pc.pub_id
        WHERE br.borrower_id = ? AND b.date_returned IS NULL
        ORDER BY b.due_date
    ');
    $stmt->execute([$id]);
    $borrows = $stmt->fetchAll();

    $max = (int) $pdo->query('SELECT max_books_allowed FROM borrowing_policy ORDER BY policy_id LIMIT 1')->fetchColumn();

    $unpaid = (float) $r['unpaid_fine_total'];
    $reasons = [];
    if ($unpaid > 0) {
        $reasons[] = 'Has an unpaid fine of PHP ' . number_format($unpaid, 2) . '.';
    }
    if ((int) $r['overdue_count'] > 0) {
        $reasons[] = 'Has an overdue book that has not been returned.';
    }
    if ((int) $r['active_borrows'] >= $max) {
        $reasons[] = 'Has reached the maximum of ' . $max . ' books.';
    }

    $address = array_filter([$r['user_brgy'], $r['user_municipality'], $r['user_province']]);

    return [
        'profile' => [
            'borrower_id' => $r['borrower_id'],
            'first_name' => $r['user_fname'],
            'last_name' => $r['user_lname'],
            'middle_initial' => $r['user_midInit'],
            'category' => $r['borrower_type'],
            'birth_date' => $r['birth_date'],
            'gender' => $r['gender'],
            'email' => $r['email'],
            'barangay' => $r['user_brgy'],
            'municipality' => $r['user_municipality'],
            'province' => $r['user_province'],
            'address' => implode(', ', $address),
            'id_type' => $r['ID_type'],
            'id_number' => $r['ID_number'],
        ],
        'status' => [
            'active_borrows' => (int) $r['active_borrows'],
            'max_books' => $max,
            'unpaid_fine_total' => $unpaid,
            'overdue_titles' => array_values(array_column(array_filter($borrows, fn($b) => $b['is_overdue']), 'title')),
        ],
        'borrows' => $borrows,
        'verdict' => $reasons ? 'Blocked' : 'Eligible',
        'reasons' => $reasons,
    ];
}

$action = $_GET['action'] ?? ($_POST['action'] ?? '');

if ($action === 'search') {
    $q = trim((string) ($_GET['q'] ?? ''));
    if ($q === '') {
        respond(['exact' => null, 'results' => []]);
    }

    $id = normalizeBorrowerId($q);
    if ($id !== null) {
        $stmt = $pdo->prepare('SELECT borrower_id, borrower_name, borrower_type, overdue_count, unpaid_fine_total FROM v_borrower_status WHERE borrower_id = ?');
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        respond(['exact' => $row ? $id : null, 'results' => $row ? [resultRow($row)] : []]);
    }

    $where = [];
    $params = [];
    foreach (array_slice(preg_split('/\s+/', $q), 0, 5) as $term) {
        $where[] = "CONCAT_WS(' ', u.user_fname, u.user_midInit, u.user_lname) LIKE ?";
        $params[] = '%' . addcslashes($term, '%_\\') . '%';
    }
    $stmt = $pdo->prepare('
        SELECT s.borrower_id, s.borrower_name, s.borrower_type, s.overdue_count, s.unpaid_fine_total
        FROM v_borrower_status s
        JOIN `user` u ON u.user_id = s.user_id
        WHERE ' . implode(' AND ', $where) . '
        ORDER BY u.user_lname, u.user_fname
        LIMIT 8
    ');
    $stmt->execute($params);
    respond(['exact' => null, 'results' => array_map('resultRow', $stmt->fetchAll())]);
}

if ($action === 'card') {
    $card = borrowerCard($pdo, trim((string) ($_GET['id'] ?? '')));
    if ($card === null) {
        respond(['ok' => false, 'error' => 'Borrower not found.']);
    }
    respond(['ok' => true] + $card);
}

if ($action === 'register') {
    requirePost();
    $in = readBorrowerInput();
    $error = validateBorrowerInput($in);
    if ($error !== null) {
        respond(['ok' => false, 'error' => $error]);
    }

    $stmt = $pdo->prepare('SELECT borrower_id FROM borrower WHERE ID_type = ? AND ID_number = ?');
    $stmt->execute([$in['id_type'], $in['id_number']]);
    $existing = $stmt->fetchColumn();
    if ($existing) {
        respond(['ok' => false, 'error' => 'A borrower with this ID type and number already exists.', 'existing' => $existing]);
    }

    if (postText('override') !== '1') {
        $stmt = $pdo->prepare('
            SELECT br.borrower_id, CONCAT(u.user_fname, \' \', u.user_lname) AS name
            FROM borrower br JOIN `user` u ON u.user_id = br.user_id
            WHERE u.user_fname = ? AND u.user_lname = ? AND u.birth_date = ?
        ');
        $stmt->execute([$in['first_name'], $in['last_name'], $in['birth_date']]);
        $matches = $stmt->fetchAll();
        if ($matches) {
            respond(['ok' => false, 'warning' => 'A borrower with the same name and birth date already exists.', 'matches' => $matches]);
        }
    }

    try {
        $stmt = $pdo->prepare('CALL sp_register_borrower(?,?,?,?,?,?,?,?,?,?,?,?)');
        $stmt->execute([
            $in['first_name'], $in['last_name'], $in['middle_initial'], $in['birth_date'], $in['gender'],
            $in['barangay'], $in['municipality'], $in['province'], $in['email'], $in['category'],
            $in['id_type'], $in['id_number'],
        ]);
        $newId = $stmt->fetchColumn();
        $stmt->closeCursor();
    } catch (PDOException $e) {
        respond(['ok' => false, 'error' => exceptionMessage($e)]);
    }
    respond(['ok' => true, 'borrower_id' => $newId]);
}

if ($action === 'update') {
    requirePost();
    $id = postText('borrower_id');
    $in = readBorrowerInput();
    $error = validateBorrowerInput($in);
    if ($error !== null) {
        respond(['ok' => false, 'error' => $error]);
    }

    $stmt = $pdo->prepare('SELECT user_id FROM borrower WHERE borrower_id = ?');
    $stmt->execute([$id]);
    $userId = $stmt->fetchColumn();
    if (!$userId) {
        respond(['ok' => false, 'error' => 'Borrower not found.']);
    }

    $stmt = $pdo->prepare('SELECT borrower_id FROM borrower WHERE ID_type = ? AND ID_number = ? AND borrower_id <> ?');
    $stmt->execute([$in['id_type'], $in['id_number'], $id]);
    $existing = $stmt->fetchColumn();
    if ($existing) {
        respond(['ok' => false, 'error' => 'A borrower with this ID type and number already exists.', 'existing' => $existing]);
    }

    try {
        $pdo->beginTransaction();
        $pdo->prepare('
            UPDATE `user` SET user_fname = ?, user_lname = ?, user_midInit = ?, birth_date = ?, gender = ?,
                              email = ?, user_brgy = ?, user_municipality = ?, user_province = ?
            WHERE user_id = ?
        ')->execute([
            $in['first_name'], $in['last_name'], nullIfEmpty($in['middle_initial']), $in['birth_date'], $in['gender'],
            nullIfEmpty($in['email']), nullIfEmpty($in['barangay']), nullIfEmpty($in['municipality']),
            nullIfEmpty($in['province']), $userId,
        ]);
        $pdo->prepare('UPDATE borrower SET borrower_type = ?, ID_type = ?, ID_number = ? WHERE borrower_id = ?')
            ->execute([$in['category'], $in['id_type'], $in['id_number'], $id]);
        $pdo->commit();
    } catch (PDOException $e) {
        $pdo->rollBack();
        respond(['ok' => false, 'error' => 'Could not save. Please try again.']);
    }
    respond(['ok' => true, 'borrower_id' => $id]);
}

if ($action === 'delete') {
    requirePost();
    $id = postText('borrower_id');

    $stmt = $pdo->prepare('SELECT user_id FROM borrower WHERE borrower_id = ?');
    $stmt->execute([$id]);
    $userId = $stmt->fetchColumn();
    if (!$userId) {
        respond(['ok' => false, 'error' => 'Borrower not found.']);
    }

    $stmt = $pdo->prepare('SELECT COUNT(*) FROM borrows WHERE user_id = ?');
    $stmt->execute([$userId]);
    if ((int) $stmt->fetchColumn() > 0) {
        respond(['ok' => false, 'error' => 'This borrower has borrow history and cannot be deleted.']);
    }

    try {
        $pdo->beginTransaction();
        $pdo->prepare('DELETE FROM borrower WHERE borrower_id = ?')->execute([$id]);
        $pdo->prepare('DELETE FROM `user` WHERE user_id = ?')->execute([$userId]);
        $pdo->commit();
    } catch (PDOException $e) {
        $pdo->rollBack();
        respond(['ok' => false, 'error' => 'Could not delete. Please try again.']);
    }
    respond(['ok' => true]);
}

http_response_code(400);
respond(['ok' => false, 'error' => 'Unknown action.']);
