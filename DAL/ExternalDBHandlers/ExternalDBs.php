<?php

require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");
require_once(realpath(dirname(__FILE__)) . "/DatabaseHandlerFactory.php");

class ExternalDBs {

	// Get a database handler by database type which is one of the properties of input parameter.
	public static function GetDBHandler($externalDBCredentials) {
		return DatabaseHandlerFactory::createDatabaseHandler($externalDBCredentials->driver, $externalDBCredentials->user_name, $externalDBCredentials->password, $externalDBCredentials->source_database, $externalDBCredentials->server_address, $externalDBCredentials->port);
	}

    public static function GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials) {
        $dbHandler = ExternalDBs::GetDBHandler($externalDBCredentials);
        return $dbHandler->getTableData($table_name, $perPage, $pageNo);
    }

    public static function GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials) {
        $dbHandler = ExternalDBs::GetDBHandler($externalDBCredentials);
        return $dbHandler->getTotalNumberTuplesInTable($table_name);
    }
}

?>