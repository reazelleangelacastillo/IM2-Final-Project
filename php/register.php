<?php
require '../db.php';

$error = '';
$success = false;

$fields = ['user_fname', 'user_lname', 'user_midInit', 'user_brgy', 'user_municipality',
           'user_province', 'birth_date', 'gender', 'email', 'user_type'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $in = [];
    foreach ($fields as $k) {
        $in[$k] = is_string($_POST[$k] ?? null) ? trim($_POST[$k]) : '';
    }
    $password = is_string($_POST['password'] ?? null) ? $_POST['password'] : '';
    $confirm  = is_string($_POST['confirm_password'] ?? null) ? $_POST['confirm_password'] : '';
    $birth = DateTime::createFromFormat('Y-m-d', $in['birth_date']);

    if ($in['user_fname'] === '' || $in['user_lname'] === '') {
        $error = 'First name and last name are required.';
    } elseif (!$birth || $birth->format('Y-m-d') !== $in['birth_date'] || $birth > new DateTime()) {
        $error = 'Please enter a valid birth date.';
    } elseif (!in_array($in['gender'], ['Male', 'Female'], true)) {
        $error = 'Please select a gender.';
    } elseif (!in_array($in['user_type'], ['Librarian', 'Library Clerk'], true)) {
        $error = 'Please select a staff role.';
    } elseif (!filter_var($in['email'], FILTER_VALIDATE_EMAIL)) {
        $error = 'Please enter a valid email address.';
    } elseif (strlen($password) < 8) {
        $error = 'Password must be at least 8 characters.';
    } elseif ($password !== $confirm) {
        $error = 'Passwords do not match.';
    } else {
        $stmt = $pdo->prepare('SELECT 1 FROM user WHERE email = ?');
        $stmt->execute([$in['email']]);

        if ($stmt->fetch()) {
            $error = 'An account with this email already exists.';
        } else {
            try {
                $pdo->beginTransaction();

                // shortcut: ids are MAX+1 because the tables have no AUTO_INCREMENT; two signups
                // at the same instant make one fail with the error below. Upgrade: AUTO_INCREMENT.
                $userId = $pdo->query('SELECT COALESCE(MAX(user_id), 100000) + 1 FROM user')->fetchColumn();
                $staffNo = $pdo->query('SELECT COALESCE(MAX(CAST(SUBSTRING(libstaff_id, 4) AS UNSIGNED)), 0) + 1 FROM library_staff')->fetchColumn();

                $stmt = $pdo->prepare('
                    INSERT INTO user (user_id, user_fname, user_lname, user_midInit, user_brgy, user_municipality,
                                      user_province, birth_date, gender, email, user_type)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ');
                // empty optional fields are stored as NULL
                $stmt->execute(array_merge([$userId], array_map(fn($k) => $in[$k] !== '' ? $in[$k] : null, $fields)));

                $stmt = $pdo->prepare('
                    INSERT INTO library_staff (libstaff_id, user_id, hire_date, password)
                    VALUES (?, ?, CURDATE(), ?)
                ');
                $stmt->execute([sprintf('LIB%03d', $staffNo), $userId, $password]);

                $pdo->commit();
                $success = true;
                $_POST = [];
            } catch (PDOException $e) {
                $pdo->rollBack();
                $error = 'Could not create the account. Please try again.';
            }
        }
    }
}

function old($k) {
    return is_string($_POST[$k] ?? null) ? htmlspecialchars($_POST[$k]) : '';
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Registration - BookTrace</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet" href="../css/login.css">
    <link rel="stylesheet" href="../css/register.css">
</head>
<body>

    <div class="split-container">

        <a href="login.php" class="corner-back-btn" aria-label="Back">
            <i class="bi bi-arrow-left"></i> Back
        </a>

        <div class="left-panel">
            <div class="brand-content">
                <h1>BookTrace</h1>
                <p>A LIBRARY DATABASE MANAGEMENT SYSTEM</p>
            </div>

            <div class="form-box login-box register-box">

                <h2>Staff Registration</h2>
                <p>Fill in your details to create a staff account:</p>

                <form id="registerForm" action="register.php" method="POST">

                    <?php if ($success): ?>
                        <p class="success-msg">
                            Account created. You can now <a href="login.php">log in</a>.
                        </p>
                    <?php elseif (!empty($error)): ?>
                        <p class="error-msg">
                            <?php echo htmlspecialchars($error); ?>
                        </p>
                    <?php endif; ?>

                    <div class="input-group-container">
                        <label class="form-label-custom" for="user_fname">First Name</label>
                        <input type="text" id="user_fname" name="user_fname" value="<?php echo old('user_fname'); ?>"
                               required maxlength="50" class="form-input-custom">
                    </div>

                    <div class="input-group-container">
                        <label class="form-label-custom" for="user_midInit">Middle Initial</label>
                        <input type="text" id="user_midInit" name="user_midInit" value="<?php echo old('user_midInit'); ?>"
                               maxlength="1" class="form-input-custom">
                    </div>

                    <div class="input-group-container">
                        <label class="form-label-custom" for="user_lname">Last Name</label>
                        <input type="text" id="user_lname" name="user_lname" value="<?php echo old('user_lname'); ?>"
                               required maxlength="50" class="form-input-custom">
                    </div>

                    <div class="input-group-container">
                        <label class="form-label-custom" for="user_brgy">Barangay</label>
                        <input type="text" id="user_brgy" name="user_brgy" value="<?php echo old('user_brgy'); ?>"
                               maxlength="100" class="form-input-custom">
                    </div>

                    <div class="input-group-container">
                        <label class="form-label-custom" for="user_municipality">Municipality</label>
                        <input type="text" id="user_municipality" name="user_municipality" value="<?php echo old('user_municipality'); ?>"
                               maxlength="100" class="form-input-custom">
                    </div>

                    <div class="input-group-container">
                        <label class="form-label-custom" for="user_province">Province</label>
                        <input type="text" id="user_province" name="user_province" value="<?php echo old('user_province'); ?>"
                               maxlength="100" class="form-input-custom">
                    </div>

                    <div class="input-group-container">
                        <label class="form-label-custom" for="birth_date">Birth Date</label>
                        <input type="date" id="birth_date" name="birth_date" value="<?php echo old('birth_date'); ?>"
                               required max="<?php echo date('Y-m-d'); ?>" class="form-input-custom">
                    </div>

                    <div class="input-group-container">
                        <label class="form-label-custom" for="gender">Gender</label>
                        <select id="gender" name="gender" required class="form-input-custom">
                            <option value="">Select</option>
                            <?php foreach (['Male', 'Female'] as $g): ?>
                                <option <?php if (old('gender') === $g) echo 'selected'; ?>><?php echo $g; ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>

                    <div class="input-group-container">
                        <label class="form-label-custom" for="user_type">Staff Role</label>
                        <select id="user_type" name="user_type" required class="form-input-custom">
                            <option value="">Select</option>
                            <?php foreach (['Librarian', 'Library Clerk'] as $r): ?>
                                <option <?php if (old('user_type') === $r) echo 'selected'; ?>><?php echo $r; ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>

                    <div class="input-group-container full">
                        <label class="form-label-custom" for="email">Email Address</label>
                        <input type="email" id="email" name="email" value="<?php echo old('email'); ?>"
                               required maxlength="100" placeholder="Enter your email" class="form-input-custom">
                    </div>

                    <div class="input-group-container half">
                        <label class="form-label-custom" for="password">Password</label>
                        <input type="password" id="password" name="password"
                               required minlength="8" maxlength="255" placeholder="At least 8 characters" class="form-input-custom">
                    </div>

                    <div class="input-group-container half">
                        <label class="form-label-custom" for="confirm_password">Confirm Password</label>
                        <input type="password" id="confirm_password" name="confirm_password"
                               required minlength="8" maxlength="255" placeholder="Re-enter your password" class="form-input-custom">
                    </div>

                    <button type="submit" class="continue-btn primary-btn">
                        Register
                    </button>

                </form>

                <p class="register-link">Already have an account? <a href="login.php">Log in here</a></p>
            </div>
        </div>

        <div class="right-panel">
            <div class="diagonal-images" aria-hidden="true">
                <div class="image-strip"><img src="../assets/books.jpg" alt=""></div>
                <div class="image-strip"><img src="../assets/books.jpg" alt=""></div>
                <div class="image-strip"><img src="../assets/books.jpg" alt=""></div>
            </div>
        </div>

    </div>

</body>
</html>
