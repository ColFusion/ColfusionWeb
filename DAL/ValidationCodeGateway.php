<?php

include_once(realpath(dirname(__FILE__)) . '/../config.php');

class ValidationCodeGateway {
    
    public function insertValidationCode($email, $validationCode) {
        global $db;

        $email = mysql_real_escape_string($email);
        $validationCode = mysql_real_escape_string($validationCode);
        $sql = "insert into colfusion_validation_code(email, vcode) values('$email', '$validationCode')";
        $db->query($sql);
    }

    public function isValidationCodeUnsed($email, $validationCode) {
        global $db;

        $email = mysql_real_escape_string($email);
        $validationCode = mysql_real_escape_string($validationCode);
        $sql = "select * from colfusion_validation_code where email = '$email' and vcode = '$validationCode' and isUsed = 0 limit 1";
        $row = $db->get_row($sql);
        var_dump($row);
        
        if($row && $row->isUsed == 0){
            return true;
        }
        
        return false;
    }

    public function useValidationCode($email, $validationCode) {
        global $db;

        $email = mysql_real_escape_string($email);
        $validationCode = mysql_real_escape_string($validationCode);
        $sql = "update colfusion_validation_code set isUsed = 1 where email = '$email' and vcode = '$validationCode'";
        $db->query($sql);
    }

}

?>
