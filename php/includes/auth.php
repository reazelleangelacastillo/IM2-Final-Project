<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (empty($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

function current_libstaff_id(): string
{
    static $libstaffId = null;
    if ($libstaffId === null) {
        global $pdo;
        if (!isset($pdo)) {
            require __DIR__ . '/../../db.php';
            $GLOBALS['pdo'] = $pdo;
        }
        $stmt = $pdo->prepare('SELECT libstaff_id FROM library_staff WHERE user_id = ?');
        $stmt->execute([$_SESSION['user_id']]);
        $libstaffId = (string) $stmt->fetchColumn();
        if ($libstaffId === '') {
            session_destroy();
            header('Location: login.php');
            exit;
        }
    }
    return $libstaffId;
}
