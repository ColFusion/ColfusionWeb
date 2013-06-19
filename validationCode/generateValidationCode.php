<?php

include_once('Net/SMTP.php');
include_once('Mail.php');
include_once '../DAL/ValidationCodeGateway.php';

$password = $_POST['password'];
$emails = $_POST['emails'];
$gateway = new ValidationCodeGateway();

if ($password != 'Evgeny')
    die('Invalid Password');

echo "Validation codes are sent to following addresses: <br/>";

foreach ($emails as $email) {
    if (empty($email)) {
        continue;
    }

    $validationCode = generateValidationCode(15);
    $gateway->insertValidationCode($email, $validationCode);
    sendValidationCode($email, $validationCode);

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

function sendValidationCode($email, $validationCode) {
    $recipients = $email;

    $headers['From'] = 'SaltSystemService@gmail.com';
    $headers['To'] = $email;
    $headers['Subject'] = 'Colfusion Invitation';

    $body = "Dear user, 
Welcome to Colfusion

Before you login, please register with following email and validation code:

     Email: $email
     Validation Code: $validationCode

Please contact us if you have any problems.

Best Regards,
Colfusion System Service";

    $smtpinfo["host"] = "smtp.gmail.com";
    $smtpinfo["port"] = "25";
    $smtpinfo["auth"] = true;
    $smtpinfo["username"] = "SaltSystemService@gmail.com";
    $smtpinfo["password"] = "robertcl0310";


    // Create the mail object using the Mail::factory method
    $mail_object = & Mail::factory("smtp", $smtpinfo);

    $mail_object->send($recipients, $headers, $body);
}

?>
