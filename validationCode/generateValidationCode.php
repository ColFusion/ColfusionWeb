<?php

require_once('Net/SMTP.php');
require_once('Mail.php');
require_once '../DAL/ValidationCodeGateway.php';

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
//    $headers['From'] = 'SaltSystemService@gmail.com';
//    $headers['To'] = $email;
//    $headers['Subject'] = 'Colfusion Invitation';

//    $body = $msg;

    // $smtpinfo["host"] = "ssl://smtp.gmail.com";
    // $smtpinfo["port"] = "465";
    // $smtpinfo["auth"] = true;
    // $smtpinfo["username"] = "SaltSystemService@gmail.com";
    // $smtpinfo["password"] = "robertcl0310";

    // $mail_object = & Mail::factory("smtp", $smtpinfo);
    // $mail_object->send($email, $headers, $body);
       


$headers['From']    = 'colfuion-noreply@colfusion.com';
$headers['To']      = $email;
$headers['Subject'] = 'Colfusion Invitation';



$params['sendmail_path'] = '/usr/sbin/sendmail';

// Create the mail object using the Mail::factory method
$mail_object =& Mail::factory('sendmail', $params);

    $recipients = $email . ", Karataev.Evgeny@gmail.com";

$mail_object->send($recipients, $headers, $msg);


    if (PEAR::isError($mail_object)) {print($mail_object->getMessage());}
}

?>
