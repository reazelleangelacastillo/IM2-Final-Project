<?php
session_start();

/* DATABASE CONNECTION */
$host = "localhost";
$user = "root";
$password = "";
$database = "queryshelf";

$conn = mysqli_connect($host, $user, $password, $database);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

/* TODAY'S DATE */
$today = date("Y-m-d");

/* GET DUE TODAY BOOKS */
$sql = "
SELECT *
FROM borrows
WHERE date_returned = '$today'
ORDER BY borrow_id DESC
";

$result = mysqli_query($conn, $sql);
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Notifications</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f6f9;
            font-family: Arial;
        }

        .container-box {
            width: 80%;
            margin: 50px auto;
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h2 {
            color: #0d6efd;
            margin-bottom: 20px;
        }

        .badge-due {
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 10px;
        }

        /* BACK BUTTON */
        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
        }
    </style>

</head>

<body>

<!-- BACK BUTTON -->
<a href="clerk_dashboard.php" class="btn btn-primary back-btn">
    ← Back
</a>

<div class="container-box">

    <h2>Notifications</h2>

    <?php if (mysqli_num_rows($result) > 0) { ?>

        <div class="alert alert-warning">
            You have books that are <b>due today</b>.
        </div>

        <table class="table table-bordered table-hover">

            <thead class="table-primary">

                <tr>
                    <th>Borrow ID</th>
                    <th>User ID</th>
                    <th>Accession ID</th>
                    <th>Date Borrowed</th>
                    <th>Return Date</th>
                    <th>Status</th>
                </tr>

            </thead>

            <tbody>

            <?php while ($row = mysqli_fetch_assoc($result)) { ?>

                <tr>
                    <td><?php echo $row['borrow_id']; ?></td>
                    <td><?php echo $row['user_id']; ?></td>
                    <td><?php echo $row['accession_id']; ?></td>
                    <td><?php echo $row['date_borrowed']; ?></td>
                    <td>
                        <span class="badge-due">
                            <?php echo $row['date_returned']; ?>
                        </span>
                    </td>
                    <td>Due Today</td>
                </tr>

            <?php } ?>

            </tbody>

        </table>

    <?php } else { ?>

        <div class="alert alert-success">
            No books are due today 🎉
        </div>

    <?php } ?>

</div>

</body>
</html>