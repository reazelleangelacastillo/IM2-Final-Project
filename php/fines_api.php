<?php
require_once __DIR__ . '/includes/api.php';

$action = requestAction();

try {
    if ($action === 'summary') {
        $rows = $pdo->query('SELECT status, COUNT(*) AS cnt, COALESCE(SUM(amount), 0) AS total FROM fines GROUP BY status')->fetchAll();
        $summary = [
            'unpaid_count' => 0, 'unpaid_total' => 0.0,
            'paid_count' => 0, 'paid_total' => 0.0,
            'borrowers_with_unpaid' => 0,
        ];
        foreach ($rows as $r) {
            $key = $r['status'] === 'Paid' ? 'paid' : 'unpaid';
            $summary[$key . '_count'] = (int) $r['cnt'];
            $summary[$key . '_total'] = (float) $r['total'];
        }
        $summary['borrowers_with_unpaid'] = (int) $pdo->query('
            SELECT COUNT(DISTINCT b.user_id)
            FROM fines f JOIN borrows b ON b.borrow_id = f.borrow_id
            WHERE f.status = \'Unpaid\'
        ')->fetchColumn();
        respond(['ok' => true, 'summary' => $summary]);
    }

    if ($action === 'list') {
        $filter = $_GET['status'] ?? 'All';
        $q = is_string($_GET['q'] ?? null) ? trim($_GET['q']) : '';
        $sql = '
            SELECT f.fine_id, f.borrow_id, br.borrower_id,
                   CONCAT(u.user_fname, \' \', u.user_lname) AS borrower_name,
                   p.title, f.hours_late, f.rate_applied, f.amount,
                   f.date_assessed, f.status, f.date_paid
            FROM fines f
            JOIN borrows b ON b.borrow_id = f.borrow_id
            JOIN borrower br ON br.user_id = b.user_id
            JOIN `user` u ON u.user_id = b.user_id
            JOIN `pub copies` pc ON pc.copy_id = b.copy_id
            JOIN publication p ON p.pub_id = pc.pub_id
            WHERE 1 = 1';
        $params = [];
        if ($filter === 'Unpaid' || $filter === 'Paid') {
            $sql .= ' AND f.status = ?';
            $params[] = $filter;
        }
        if ($q !== '') {
            $like = '%' . addcslashes($q, '%_\\') . '%';
            $sql .= ' AND (f.fine_id LIKE ? OR f.borrow_id LIKE ? OR br.borrower_id LIKE ? OR CONCAT(u.user_fname, \' \', u.user_lname) LIKE ?)';
            array_push($params, $like, $like, $like, $like);
        }
        $sql .= ' ORDER BY (f.status = \'Unpaid\') DESC, f.date_assessed DESC, f.fine_id DESC LIMIT 300';
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        respond(['ok' => true, 'fines' => $stmt->fetchAll()]);
    }

    if ($action === 'overdue') {
        $rows = $pdo->query('
            SELECT transaction_id, borrower_id, borrower_name, copy_id, title, due_date, hours_late, live_fine
            FROM v_overdue_borrows
            ORDER BY hours_late DESC, transaction_id
        ')->fetchAll();
        respond(['ok' => true, 'overdue' => $rows]);
    }

    if ($action === 'pay') {
        requirePost();
        $fineId = postText('fine_id');
        if ($fineId === '') {
            respond(['ok' => false, 'error' => 'Required field missing.']);
        }
        $stmt = $pdo->prepare('CALL sp_pay_fine(?)');
        $stmt->execute([$fineId]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        respond(['ok' => true, 'fine_id' => $row['fine_id'], 'date_paid' => $row['date_paid']]);
    }

    respond(['ok' => false, 'error' => 'Unknown action.']);
} catch (PDOException $e) {
    respond(['ok' => false, 'error' => exceptionMessage($e)]);
}
