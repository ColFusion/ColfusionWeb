<?php

require 'PHPUnit/Autoload.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/ValidationCodeGateway.php';

class ValidationCodeGatewayTest extends PHPUnit_Framework_TestCase {

    public function testInsertValidationCode() {
        $gateway = new ValidationCodeGateway();
        $email = 'testInsert@ttt.tttt';
        $validationCode = 'test vcode';
        
        $gateway->insertValidationCode($email, $validationCode);
        $isUnused = $gateway->isValidationCodeUnsed($email, $validationCode);
        $this->assertTrue($isUnused);
    }

    public function testIsValidationCodeUnsed($email, $validationCode) {
        $gateway = new ValidationCodeGateway();
        
        $email = 'aa@aaa.aaa';
        $validationCode = '123456';
        $this->assertTrue($gateway->isValidationCodeUnsed($email, $validationCode));
        
        $email = 'bb@bbb.bbb';
        $validationCode = '111111';
        $this->assertFalse($gateway->isValidationCodeUnsed($email, $validationCode));
        
        // No this email-vcode combination
        $email = 'sdfdsf345';
        $validationCode = 'dsfdsfdsfs6';
        $this->assertFalse($gateway->isValidationCodeUnsed($email, $validationCode));       
    }
  
    public function testUseValidationCode() {
        $gateway = new ValidationCodeGateway();
        $email = 'testUse@ttt.tttt';
        $validationCode = 'test vcode';
        
        $gateway->insertValidationCode($email, $validationCode);
        $gateway->useValidationCode($email, $validationCode);   
    }
}

// run the test
$suite = new PHPUnit_Framework_TestSuite('ValidationCodeGatewayTest');
PHPUnit_TextUI_TestRunner::run($suite);
?>
