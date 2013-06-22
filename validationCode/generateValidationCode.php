<?php

include_once('Net/SMTP.php');
include_once('Mail.php');
include_once '../DAL/ValidationCodeGateway.php';

$password = $_POST['password'];
$names = $_POST['names'];
$emails = $_POST['emails'];
$msg = $_POST['msg'];
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
    $vals   = array($names[$i], $email, $validationCode);

    $newMsg = str_replace($vars, $vals, $msg);

//    var_dump($vars);
 //   var_dump($vals);

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
    $recipients = $email;

    $headers['From'] = 'SaltSystemService@gmail.com';
    $headers['To'] = $email;
    $headers['Subject'] = 'Colfusion Invitation';

    $body = $msg;

/*
    "Dear user, 
Welcome to Colfusion

Before you login, please register with following email and validation code:

     Email: $email
     Validation Code: $validationCode

Please contact us if you have any problems.

Best Regards,
Colfusion System Service";
*/

    $smtpinfo["host"] = "smtp.gmail.com";
    $smtpinfo["port"] = "25";
    $smtpinfo["auth"] = true;
    $smtpinfo["username"] = "SaltSystemService@gmail.com";
    $smtpinfo["password"] = "robertcl0310";


//echo $body;

    // Create the mail object using the Mail::factory method
    $mail_object = & Mail::factory("smtp", $smtpinfo);

    $mail_object->send($recipients, $headers, $body);
}

?>
