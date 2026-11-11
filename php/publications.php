<?php

$host = "localhost";
$user = "root";
$password = "";
$database = "queryshelf";

$conn = mysqli_connect($host, $user, $password, $database);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

/* JOIN QUERY */
$sql = "
SELECT 
    pub_id,
    title,
    series,
    edition,
    shelf_location,
    language_used,
    subtitle,
    pages,

    status_type,
    condition,

    first_name,
    last_name,
    middle_initial

FROM publication

LEFT JOIN status 
    ON publication.status_id = status.status_id

LEFT JOIN author 
    ON publication.author_id = author.author_id
";

$result = mysqli_query($conn, $sql);

?>

<!DOCTYPE html>
<html>

<head>

    <title>Publications</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>

        body{
            font-family: Arial;
            background: #f4f6f9;
            padding: 40px;
        }

        .container-box{
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h2{
            color: #0d6efd;
            margin-bottom: 20px;
        }

        th{
            background: #0d6efd;
            color: white;
            text-align: center;
        }

        td{
            text-align: center;
            vertical-align: middle;
        }

    </style>

</head>

<body>

<div class="container-box">

    <h2>Publications List</h2>

    <table class="table table-bordered table-hover">

        <thead>

            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Series</th>
                <th>Edition</th>
                <th>Shelf Location</th>
                <th>Language</th>
                <th>Subtitle</th>
                <th>Pages</th>
                <th>Status Type</th>
                <th>Condition</th>
                <th>Author First Name</th>
                <th>Author Last Name</th>
                <th>Middle Initial</th>
            </tr>

        </thead>

        <tbody>

        <?php

        if(mysqli_num_rows($result) > 0){

            while($row = mysqli_fetch_assoc($result)){

                echo "<tr>";

                echo "<td>{$row['pub_id']}</td>";
                echo "<td>{$row['title']}</td>";
                echo "<td>{$row['series']}</td>";
                echo "<td>{$row['edition']}</td>";
                echo "<td>{$row['shelf_location']}</td>";
                echo "<td>{$row['language_used']}</td>";
                echo "<td>{$row['subtitle']}</td>";
                echo "<td>{$row['pages']}</td>";

                echo "<td>{$row['status_type']}</td>";
                echo "<td>{$row['condition']}</td>";

                echo "<td>{$row['first_name']}</td>";
                echo "<td>{$row['last_name']}</td>";
                echo "<td>{$row['middle_initial']}</td>";

                echo "</tr>";
            }

        } else {
            echo "<tr><td colspan='13'>No publications found</td></tr>";
        }

        ?>

        </tbody>

    </table>

</div>

</body>

</html>