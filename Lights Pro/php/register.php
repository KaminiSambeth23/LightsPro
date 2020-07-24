<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO user(NAME,EMAIL,PHONE,PASSWORD,VERIFY,CREDIT) VALUES ('$name','$email','$phone','$password','1','0')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "failed";
}



function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for Lights Pro'; 
    $message = 'http://theksultra.com/project/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@LightPro.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>