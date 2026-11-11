
<?php
session_start();
require '../db.php';

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email']);
    $password = $_POST['password'];

    // Check Librarian account first
    $stmt = $pdo->prepare('
        SELECT u.user_id, u.user_fname, u.user_lname, u.user_type,
               l.librarian_pass AS operational_password
        FROM user u
        LEFT JOIN librarian l ON u.user_id = l.user_id
        WHERE u.email = ? AND u.user_type = ?
    ');

    $stmt->execute([$email, 'Librarian']);
    $user = $stmt->fetch();

    // If not Librarian, check Library Clerk
    if (!$user) {
        $stmt = $pdo->prepare('
            SELECT u.user_id, u.user_fname, u.user_lname, u.user_type,
                   c.libclerk_pass AS operational_password
            FROM user u
            LEFT JOIN `library clerk` c ON u.user_id = c.user_id
            WHERE u.email = ? AND u.user_type = ?
        ');

        $stmt->execute([$email, 'Library Clerk']);
        $user = $stmt->fetch();
    }

    if ($user) {
        if ($password === $user['operational_password']) {

            session_regenerate_id(true);

            $_SESSION['user_id'] = $user['user_id'];
            $_SESSION['user_name'] = $user['user_fname'] . ' ' . $user['user_lname'];
            $_SESSION['user_type'] = $user['user_type'];

            if ($user['user_type'] === 'Librarian') {
                header('Location: librarian_dashboard.php');
                exit;
            } elseif ($user['user_type'] === 'Library Clerk') {
                header('Location: ../libclerk_dashboard.php');
                exit;
            }

        } else {
            $error = "Invalid password.";
        }
    } else {
        $error = "No account is registered to this email.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login - BookTrace</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet" href="../css/login.css">
</head>
<body>

    <div class="split-container">

        <a href="../index.php" class="corner-back-btn" aria-label="Back">
            <i class="bi bi-arrow-left"></i> Back
        </a>

        <div class="left-panel">
            <div class="brand-content">
                <h1>BookTrace</h1>
                <p>A LIBRARY DATABASE MANAGEMENT SYSTEM</p>
            </div>

            <div class="form-box login-box">

                <h2>Welcome, Staff!</h2>
                <p>Please login with your authorized account:</p>

                <form id="loginForm" action="login.php" method="POST">

                    <?php if (!empty($error)): ?>
                        <p class="error-msg">
                            <?php echo htmlspecialchars($error); ?>
                        </p>
                    <?php endif; ?>

                    <div class="input-group-container">
                        <label class="form-label-custom">Email Address</label>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            value="<?php echo isset($_POST['email']) ? htmlspecialchars($_POST['email']) : ''; ?>"
                            required
                            placeholder="Enter your email"
                            class="form-input-custom"
                        >
                    </div>

                    <div class="input-group-container password-margin">
                        <label class="form-label-custom">Password</label>

                        <input
                            type="password"
                            id="password"
                            name="password"
                            required
                            placeholder="Enter your password"
                            class="form-input-custom"
                        >
                    </div>

                    <button type="submit" class="continue-btn primary-btn">
                        Login
                    </button>

                </form>

                <!-- Register Link -->
              <p class="register-link">  Don't have an account yet? <a href="register.php">Register here</a>
</p>
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