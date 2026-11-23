<?php
function create_staff_account(PDO $pdo, array $in, string $role, string $password, string $confirm): string
{
    $birth = DateTime::createFromFormat('Y-m-d', $in['birth_date']);

    if ($in['user_fname'] === '' || $in['user_lname'] === '') {
        return 'First name and last name are required.';
    }
    if (!$birth || $birth->format('Y-m-d') !== $in['birth_date'] || $birth > new DateTime()) {
        return 'Please enter a valid birth date.';
    }
    if (!in_array($in['gender'], ['Male', 'Female'], true)) {
        return 'Please select a gender.';
    }
    if (!in_array($role, ['Librarian', 'Library Clerk'], true)) {
        return 'Please select a staff role.';
    }
    if (!filter_var($in['email'], FILTER_VALIDATE_EMAIL)) {
        return 'Please enter a valid email address.';
    }
    if (strlen($password) < 8) {
        return 'Password must be at least 8 characters.';
    }
    if ($password !== $confirm) {
        return 'Passwords do not match.';
    }

    $stmt = $pdo->prepare('SELECT 1 FROM user WHERE email = ?');
    $stmt->execute([$in['email']]);
    if ($stmt->fetch()) {
        return 'An account with this email already exists.';
    }

    try {
        $pdo->beginTransaction();

        $userId = $pdo->query('SELECT COALESCE(MAX(user_id), 100000) + 1 FROM user FOR UPDATE')->fetchColumn();
        $staffNo = $pdo->query('SELECT COALESCE(MAX(CAST(SUBSTRING(libstaff_id, 4) AS UNSIGNED)), 0) + 1 FROM library_staff FOR UPDATE')->fetchColumn();

        $optional = static function (string $key) use ($in): ?string {
            return isset($in[$key]) && $in[$key] !== '' ? $in[$key] : null;
        };

        $stmt = $pdo->prepare('
            INSERT INTO user (user_id, user_fname, user_lname, user_midInit, user_brgy, user_municipality,
                              user_province, birth_date, gender, email, user_type)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ');
        $stmt->execute([
            $userId, $in['user_fname'], $in['user_lname'], $optional('user_midInit'), $optional('user_brgy'),
            $optional('user_municipality'), $optional('user_province'), $in['birth_date'], $in['gender'],
            $in['email'], $role,
        ]);

        $stmt = $pdo->prepare('
            INSERT INTO library_staff (libstaff_id, user_id, hire_date, password)
            VALUES (?, ?, CURDATE(), ?)
        ');
        $stmt->execute([sprintf('LIB%03d', $staffNo), $userId, password_hash($password, PASSWORD_DEFAULT)]);

        $pdo->commit();
        return '';
    } catch (PDOException $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        return 'Could not create the account. Please try again.';
    }
}
