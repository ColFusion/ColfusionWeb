<?php

class SynonymExistedException extends Exception {
    public function __construct($message = "You have already defined this mapping", $code = 0, Exception $previous = null) {      
        parent::__construct($message, $code, $previous);
    }
}

?>
