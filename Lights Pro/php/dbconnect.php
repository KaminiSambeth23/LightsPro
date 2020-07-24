<?php
$servername ="localhost";
$username   ="theksult_applicationUser";
$password   ="&%&Kr]Ml]!$2";
$dbname     ="theksult_project";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

?>