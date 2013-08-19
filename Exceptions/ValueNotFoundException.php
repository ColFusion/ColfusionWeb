<?php

class ValueNotFoundException extends Exception {
    public function __construct($message = "Value does not exist in target table.", $code = 0, Exception $previous = null) {      
        parent::__construct($message, $code, $previous);
    }
}

?>