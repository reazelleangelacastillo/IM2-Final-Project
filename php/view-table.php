<?php

$host = "localhost";
$user = "root";
$password = "";
$database = "queryshelf";

/* DATABASE CONNECTION */
$conn = mysqli_connect($host, $user, $password, $database);

/* CHECK CONNECTION */
if (!$conn) {

    die("Connection failed: " . mysqli_connect_error());

}

/* CHECK IF TABLE IS SELECTED */
if (!isset($_GET['table'])) {

    die("No table selected.");

}

/* GET TABLE NAME */
$table = $_GET['table'];

/* SECURITY CHECK:
   VERIFY IF TABLE EXISTS */
$check_table = "SHOW TABLES LIKE '$table'";

$check_result = mysqli_query($conn, $check_table);

if (mysqli_num_rows($check_result) == 0) {

    die("Table does not exist.");

}

/* SELECT ALL RECORDS */
$sql = "SELECT * FROM `$table`";

$result = mysqli_query($conn, $sql);

?>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        <?php echo strtoupper($table); ?>
    </title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>

        body{
            background-color:#f4f6f9;
            font-family:Arial, sans-serif;
            padding:40px;
        }

        .table-container{
            background:white;
            padding:30px;
            border-radius:15px;
            box-shadow:0 4px 10px rgba(0,0,0,0.1);
        }

        h2{
            margin-bottom:25px;
            color:#0d6efd;
            font-weight:bold;
        }

        table{
            width:100%;
        }

        th{
            background:#0d6efd !important;
            color:white !important;
            text-align:center;
        }

        td{
            text-align:center;
            vertical-align:middle;
        }

        .back-btn{
            margin-bottom:20px;
        }

    </style>

</head>

<body>

<div class="table-container">

    <a href="tables.php"
       class="btn btn-primary back-btn">

        ← Back to Tables

    </a>

    <h2>

        Table:
        <?php echo strtoupper($table); ?>

    </h2>

    <table class="table table-bordered table-hover">

        <thead>

            <tr>

                <?php

                /* DISPLAY COLUMN NAMES */
                $fields = mysqli_fetch_fields($result);

                foreach($fields as $field){

                    echo "<th>" . $field->name . "</th>";

                }

                ?>

            </tr>

        </thead>

        <tbody>

            <?php

            /* CHECK IF TABLE HAS RECORDS */
            if(mysqli_num_rows($result) > 0){

                while($row = mysqli_fetch_assoc($result)){

                    echo "<tr>";

                    foreach($row as $data){

                        echo "<td>" . $data . "</td>";

                    }

                    echo "</tr>";

                }

            } else {

                echo "
                <tr>
                    <td colspan='100'>
                        No records found.
                    </td>
                </tr>
                ";

            }

            ?>

        </tbody>

    </table>

</div>

</body>
</html>