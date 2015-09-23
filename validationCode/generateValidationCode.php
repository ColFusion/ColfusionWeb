<?php

require_once('Net/SMTP.php');
require_once('Mail.php');
require_once '../DAL/ValidationCodeGateway.php';

$password = $_POST['password'];
$names = $_POST['names'];
$emails = $_POST['emails'];
$msg = nl2br($_POST['msg']);
$gateway = new ValidationCodeGateway();

if ($password != 'Evgeny')
    die('Invalid Password');

echo "Validation codes are sent to following addresses: <br/>";

$i = -1;

foreach ($emails as $email) {

    $i++;

    if (empty($email)) {
        continue;
    }

    $validationCode = generateValidationCode(15);
    $gateway->insertValidationCode($email, $validationCode);

    $vars = array("@@name@@", "@@email@@", "@@validationCode@@");
    $vals = array($names[$i], $email, $validationCode);

    $newMsg = str_replace($vars, $vals, $msg);

    sendValidationCode($email, $validationCode, $newMsg);

    echo "$email <br/>";
}

function generateValidationCode($length) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, strlen($characters) - 1)];
    }

    return $randomString;
}

function sendValidationCode($email, $validationCode, $msg) {
    $to = $email;
    $subject = "Colfusion Invitation";
    
    $body = $msg;

    $headers = "From: no-reply@colfsuion.exp.sis.pitt.edu\r\n";
    $headers .= "Content-type: text/html; charset=utf-8\r\n";
    $headers .= "Bcc: Karataev.Evgeny@gmail.com\r\n";

    if (mail($to, $subject, $body, $headers)) {
        
    }else{
        print("Something failed.");
    }
}

?>
