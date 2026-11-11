<?php

$host = "localhost";
$user = "root";
$password = "";
$database = "queryshelf";

$conn = mysqli_connect($host, $user, $password, $database);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$sql = "SHOW TABLES";
$result = mysqli_query($conn, $sql);

?>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Database Tables</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            padding: 40px;
        }

        h1 {
            text-align: center;
            margin-bottom: 40px;
            color: #0d6efd;
        }

        /* BACK BUTTON */
        .back-arrow {
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 30px;
            text-decoration: none;
            color: #0d6efd;
            font-weight: bold;
        }

        .back-arrow:hover {
            color: #084298;
        }

        .tables-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .table-box {
            background-color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: 0.3s;
        }

        .table-box:hover {
            transform: translateY(-5px);
        }

        .table-box a {
            text-decoration: none;
            font-size: 22px;
            font-weight: bold;
            color: #0d6efd;
        }

    </style>

</head>

<body>

    <!-- BACK ARROW -->
    <a href="clerk_dashboard.php" class="back-arrow">
        ←
    </a>

    <h1>
        Existing Tables
    </h1>

    <div class="tables-container">

        <?php

        if (mysqli_num_rows($result) > 0) {

            while($row = mysqli_fetch_array($result)) {

                echo "<div class='table-box'>";

                echo "<a href='view-table.php?table=" . $row[0] . "'>";

                echo $row[0];

                echo "</a>";

                echo "</div>";

            }

        } else {

            echo "<p>No tables found.</p>";

        }

        ?>

    </div>

</body>

</html>