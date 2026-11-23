<?php
if (PHP_SAPI !== 'cli') {
    http_response_code(404);
    exit;
}

if ($argc !== 3) {
    fwrite(STDERR, "Usage: php sql/reset_staff_password.php <email> <new password>\n");
    exit(1);
}

[$script, $email, $newPassword] = $argv;

if (strlen($newPassword) < 8) {
    fwrite(STDERR, "Password must be at least 8 characters.\n");
    exit(1);
}

require __DIR__ . '/../db.php';

$stmt = $pdo->prepare(
    'UPDATE library_staff ls JOIN user u ON u.user_id = ls.user_id SET ls.password = ? WHERE u.email = ?'
);
$stmt->execute([password_hash($newPassword, PASSWORD_DEFAULT), $email]);

if ($stmt->rowCount() === 0) {
    fwrite(STDERR, "No staff account found for that email.\n");
    exit(1);
}

echo "Password updated for {$email}.\n";
