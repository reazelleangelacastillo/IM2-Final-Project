<?php
require_once __DIR__ . '/auth.php';
require_once __DIR__ . '/../../db.php';

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

function requestAction(): string
{
    return $_GET['action'] ?? $_POST['action'] ?? '';
}

function exceptionMessage(PDOException $e): string
{
    return ($e->errorInfo[0] ?? '') === '45000' ? $e->errorInfo[2] : 'Could not save. Please try again.';
}

function syncOverdueFineRecords(): void
{
    global $pdo;
    $stmt = $pdo->query('CALL sp_sync_overdue_fines()');
    $stmt->closeCursor();
}
