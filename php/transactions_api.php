<?php
require_once __DIR__ . '/lib/api.php';

$action = requestAction();

try {
    if ($action === 'policy') {
        $row = $pdo->query('SELECT max_books_allowed, loan_duration_days AS loan_period_days, fine_rate_per_hour, DATE_ADD(NOW(), INTERVAL loan_duration_days DAY) AS due_preview FROM borrowing_policy ORDER BY policy_id LIMIT 1')->fetch();
        respond(['ok' => true, 'policy' => $row]);
    }

    if ($action === 'copies') {
        $q = is_string($_GET['q'] ?? null) ? trim($_GET['q']) : '';
        $like = '%' . addcslashes($q, '%_\\') . '%';
        $stmt = $pdo->prepare('
            SELECT pc.copy_id, p.title, p.shelf_location, s.status_type, s.`condition`,
                   (SELECT MAX(b.due_date) FROM borrows b
                    WHERE b.copy_id = pc.copy_id AND b.date_returned IS NULL) AS due_back
            FROM `pub copies` pc
            JOIN `status` s ON s.status_id = pc.status_id
            JOIN publication p ON p.pub_id = pc.pub_id
            WHERE p.title LIKE ? OR pc.copy_id LIKE ?
            ORDER BY (s.status_type = \'Available\' AND s.`condition` = \'Good\') DESC, p.title, pc.copy_number
            LIMIT 15
        ');
        $stmt->execute([$like, $like]);
        $copies = [];
        foreach ($stmt->fetchAll() as $r) {
            $damaged = $r['condition'] === 'Damaged';
            $selectable = $r['status_type'] === 'Available' && !$damaged;
            $copies[] = [
                'copy_id' => $r['copy_id'],
                'title' => $r['title'],
                'shelf_location' => $r['shelf_location'],
                'label' => $damaged ? 'Damaged' : $r['status_type'],
                'selectable' => $selectable,
                'due_back' => $r['status_type'] === 'Borrowed' ? $r['due_back'] : null,
            ];
        }
        respond(['ok' => true, 'copies' => $copies]);
    }

    if ($action === 'active') {
        syncOverdueFineRecords();
        $id = is_string($_GET['borrower_id'] ?? null) ? trim($_GET['borrower_id']) : '';
        $sql = '
            SELECT b.borrow_id, br.borrower_id, CONCAT(u.user_fname, \' \', u.user_lname) AS borrower_name,
                   b.copy_id, p.title, b.due_date,
                   GREATEST(
                       fn_hours_late(b.due_date, NOW()) -
                       COALESCE((SELECT SUM(f.hours_late) FROM fines f
                                 WHERE f.borrow_id = b.borrow_id AND f.status = \'Paid\'), 0),
                       0
                   ) AS hours_late,
                   GREATEST(
                       fn_hours_late(b.due_date, NOW()) -
                       COALESCE((SELECT SUM(f.hours_late) FROM fines f
                                 WHERE f.borrow_id = b.borrow_id AND f.status = \'Paid\'), 0),
                       0
                   ) * bp.fine_rate_per_hour AS fine_now
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
        $stmt = $pdo->prepare($sql . ' ORDER BY (b.due_date < NOW()) DESC, hours_late DESC, b.borrow_id DESC LIMIT 200');
        $stmt->execute($params);
        respond(['ok' => true, 'borrows' => $stmt->fetchAll()]);
    }

    if ($action === 'borrow') {
        requirePost();
        $borrowerId = postText('borrower_id');
        $copyIds = array_values(array_unique(array_filter(array_map('trim', explode(',', postText('copy_ids'))), 'strlen')));
        if ($borrowerId === '' || count($copyIds) === 0) {
            respond(['ok' => false, 'error' => 'Required field missing.']);
        }
        if (count($copyIds) > 10) {
            respond(['ok' => false, 'error' => 'Too many copies selected.']);
        }
        $staffId = current_libstaff_id();
        $results = [];
        foreach ($copyIds as $copyId) {
            try {
                $stmt = $pdo->prepare('CALL sp_borrow(?, ?, ?)');
                $stmt->execute([$borrowerId, $copyId, $staffId]);
                $row = $stmt->fetch();
                $stmt->closeCursor();
                $results[] = [
                    'copy_id' => $copyId,
                    'ok' => true,
                    'transaction_id' => $row['transaction_id'],
                    'due_date' => $row['due_date'],
                ];
            } catch (PDOException $e) {
                $results[] = ['copy_id' => $copyId, 'ok' => false, 'error' => exceptionMessage($e)];
            }
        }
        respond(['ok' => true, 'results' => $results]);
    }

    if ($action === 'return') {
        requirePost();
        $borrowId = postText('borrow_id');
        if ($borrowId === '') {
            respond(['ok' => false, 'error' => 'Required field missing.']);
        }
        $collect = postText('pay') === '1';
        $stmt = $pdo->prepare('CALL sp_return(?, ?)');
        $stmt->execute([$borrowId, current_libstaff_id()]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        $paid = false;
        if ($collect && $row['fine_id'] !== null) {
            try {
                $payStmt = $pdo->prepare('CALL sp_pay_fine(?)');
                $payStmt->execute([$row['fine_id']]);
                $payStmt->closeCursor();
                $paid = true;
            } catch (PDOException $e) {
                $paid = false;
            }
        }
        respond([
            'ok' => true,
            'transaction_id' => $row['transaction_id'],
            'fine_id' => $row['fine_id'],
            'hours_late' => $row['hours_late'] === null ? 0 : (int) $row['hours_late'],
            'fine_amount' => (float) $row['fine_amount'],
            'paid' => $paid,
        ]);
    }

    respond(['ok' => false, 'error' => 'Unknown action.']);
} catch (PDOException $e) {
    respond(['ok' => false, 'error' => exceptionMessage($e)]);
}
