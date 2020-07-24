<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sql = "SELECT * FROM user WHERE EMAIL = '$email' AND PASSWORD = '$password' AND VERIFY ='1'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo $data = "success,".$row["NAME"].",".$row["EMAIL"].",".$row["PHONE"].",".$row["CREDIT"].",".$row["DATEREG"];
    }
}else{
    echo "failed";
}
?>