<?php

require 'PHPUnit/Autoload.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once '../DAL/QueryEngine.php';

class AddRelationshipTest extends PHPUnit_Framework_TestCase {

    public function testAddRelationshipWithFullData() {
        $queryEngine = new QueryEngine();

        $user_id = 20;
        $name = 'unit test adding';
        $description = 'unit test des';
        $from = ['sid' => 753, 'tableName' => 'Sheet1', 'columns' => ['cid(616) + cid(617)']];
        $to = ['sid' => 752, 'tableName' => 'Sheet1', 'columns' => ['cid(609)']];
        $confidence = 0;
        $comment = 'no comment';

        $queryEngine->AddRelationship($user_id, $name, $description, $from, $to, $confidence, $comment);
    }

    public function testAddRelationshipWithPartialData() {
        $queryEngine = new QueryEngine();
        
        $user_id = 20;

        $from = ['sid' => 753, 'tableName' => 'Sheet1', 'columns' => ['cid(616) + cid(617)']];
        $to = ['sid' => 752, 'tableName' => 'Sheet1', 'columns' => ['cid(609)']];
        $confidence = 0;

        $queryEngine->AddRelationship($user_id, $name, $description, $from, $to, $confidence, $comment);
    }

}

// run the test
$suite = new PHPUnit_Framework_TestSuite('QueryEngineTest');
PHPUnit_TextUI_TestRunner::run($suite);
?>
