<?php
require_once __DIR__ . '/includes/auth.php';
require __DIR__ . '/../db.php';

header('Content-Type: application/json; charset=utf-8');

function respond(array $data): void
{
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function requirePost(): void
{
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        respond(['ok' => false, 'error' => 'POST required.']);
    }
}

function postText(string $key): string
{
    return is_string($_POST[$key] ?? null) ? trim($_POST[$key]) : '';
}

function exceptionMessage(PDOException $e): string
{
    return ($e->errorInfo[0] ?? '') === '45000' ? $e->errorInfo[2] : 'Could not save. Please try again.';
}

$action = $_GET['action'] ?? $_POST['action'] ?? '';

try {
    if ($action === 'policy') {
        $row = $pdo->query('SELECT max_books_allowed, loan_period_days, fine_rate_per_hour, DATE_ADD(NOW(), INTERVAL loan_period_days DAY) AS due_preview FROM borrowing_policy ORDER BY policy_id LIMIT 1')->fetch();
        respond(['ok' => true, 'policy' => $row]);
    }

    if ($action === 'copies') {
        $q = is_string($_GET['q'] ?? null) ? trim($_GET['q']) : '';
        $like = '%' . addcslashes($q, '%_\\') . '%';
        $stmt = $pdo->prepare('
            SELECT pc.copy_id, p.title, p.shelf_location
            FROM `pub copies` pc
            JOIN `status` s ON s.status_id = pc.status_id
            JOIN publication p ON p.pub_id = pc.pub_id
            WHERE s.status_type = \'Available\' AND s.`condition` = \'Good\'
              AND (p.title LIKE ? OR pc.copy_id LIKE ?)
            ORDER BY p.title, pc.copy_number
            LIMIT 10
        ');
        $stmt->execute([$like, $like]);
        respond(['ok' => true, 'copies' => $stmt->fetchAll()]);
    }

    if ($action === 'active') {
        $id = is_string($_GET['borrower_id'] ?? null) ? trim($_GET['borrower_id']) : '';
        $sql = '
            SELECT b.borrow_id, br.borrower_id, CONCAT(u.user_fname, \' \', u.user_lname) AS borrower_name,
                   b.copy_id, p.title, b.due_date,
                   fn_hours_late(b.due_date, NOW()) AS hours_late,
                   fn_calc_fine(b.due_date, NOW(), bp.fine_rate_per_hour) AS fine_now
            FROM borrows b
            JOIN borrower br ON br.user_id = b.user_id
            JOIN `user` u ON u.user_id = b.user_id
            JOIN `pub copies` pc ON pc.copy_id = b.copy_id
            JOIN publication p ON p.pub_id = pc.pub_id
            JOIN borrowing_policy bp ON bp.policy_id = b.policy_id
            WHERE b.date_returned IS NULL';
        $params = [];
        if ($id !== '') {
            $sql .= ' AND br.borrower_id = ?';
            $params[] = $id;
        }
        $stmt = $pdo->prepare($sql . ' ORDER BY b.due_date LIMIT 200');
        $stmt->execute($params);
        respond(['ok' => true, 'borrows' => $stmt->fetchAll()]);
    }

    if ($action === 'borrow') {
        requirePost();
        $borrowerId = postText('borrower_id');
        $copyId = postText('copy_id');
        if ($borrowerId === '' || $copyId === '') {
            respond(['ok' => false, 'error' => 'Required field missing.']);
        }
        $stmt = $pdo->prepare('CALL sp_borrow(?, ?, ?)');
        $stmt->execute([$borrowerId, $copyId, current_libstaff_id()]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        respond(['ok' => true, 'transaction_id' => $row['transaction_id'], 'due_date' => $row['due_date']]);
    }

    if ($action === 'return') {
        requirePost();
        $borrowId = postText('borrow_id');
        if ($borrowId === '') {
            respond(['ok' => false, 'error' => 'Required field missing.']);
        }
        $stmt = $pdo->prepare('CALL sp_return(?, ?)');
        $stmt->execute([$borrowId, current_libstaff_id()]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        respond([
            'ok' => true,
            'transaction_id' => $row['transaction_id'],
            'fine_id' => $row['fine_id'],
            'hours_late' => $row['hours_late'] === null ? 0 : (int) $row['hours_late'],
            'fine_amount' => (float) $row['fine_amount'],
        ]);
    }

    respond(['ok' => false, 'error' => 'Unknown action.']);
} catch (PDOException $e) {
    respond(['ok' => false, 'error' => exceptionMessage($e)]);
}
