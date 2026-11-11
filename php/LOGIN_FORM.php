<?php
session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $_SESSION['username'] = "admin";

    header("Location: clerk_dashboard.php");
    exit();
}
?>

<!DOCTYPE html>
<html>

<head>

    <title>LOGIN</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link rel="stylesheet"
          href="LOGIN_FORM.css">

</head>

<body>

    <div class="login-box">

        <h2 class="login-title">
            LOGIN
        </h2>

        <form method="POST">

            <div class="mb-3">

                <label>Username</label>

                <input type="text"
                       name="username"
                       class="form-control"
                       required>

            </div>

            <div class="mb-3">

                <label>Password</label>

                <input type="password"
                       name="password"
                       class="form-control"
                       required>

            </div>

            <button type="submit"
                    class="btn btn-light btn-login">

                LOGIN

            </button>

        </form>

    </div>

</body>

</html>