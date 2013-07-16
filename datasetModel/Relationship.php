<?php

include_once (realpath(dirname(__FILE__)) . '/Link.php');
include_once (realpath(dirname(__FILE__)) . '/Comment.php');

class Relationship{
    public $rid;
    public $name;
    public $description;
    public $creator;
    public $createdTime;
    public $isOwned;
    
    public $fromDataset;
    public $toDataset;
    public $fromTableName;
    public $toTableName;
    
    public $links;
    
    public $avgConfidence;
    public $yourComment;
    public $comments;
}

?>
