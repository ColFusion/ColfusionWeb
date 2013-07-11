<?php

require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");
require_once(realpath(dirname(__FILE__)) . "/DatabaseHandlerFactory.php");

class ExternalDBs {
    public static function GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials) {
        $dbHandler = DatabaseHandlerFactory::createDatabaseHandler($externalDBCredentials->driver, $externalDBCredentials->user_name, $externalDBCredentials->password, $externalDBCredentials->source_database, $externalDBCredentials->server_address, $externalDBCredentials->port);
        return $dbHandler->getTableData($table_name, $perPage, $pageNo);
    }

    public static function GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials) {
        $dbHandler = DatabaseHandlerFactory::createDatabaseHandler($externalDBCredentials->driver, $externalDBCredentials->user_name, $externalDBCredentials->password, $externalDBCredentials->source_database, $externalDBCredentials->server_address, $externalDBCredentials->port);
        return $dbHandler->getTotalNumberTuplesInTable($table_name);
    }
}

?>