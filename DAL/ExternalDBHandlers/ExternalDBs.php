<?php

//require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");
require_once(realpath(dirname(__FILE__)) . "/DatabaseHandlerFactory.php");

class ExternalDBs {

	// Get a database handler by database type which is one of the properties of input parameter.
	public static function GetDBHandler($externalDBCredentials) {
		return DatabaseHandlerFactory::createDatabaseHandler($externalDBCredentials->driver, $externalDBCredentials->user_name, $externalDBCredentials->password, $externalDBCredentials->source_database, $externalDBCredentials->server_address, $externalDBCredentials->port, $externalDBCredentials->is_local, $externalDBCredentials->linked_server_name);
	}

    public static function GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials) {
        $dbHandler = ExternalDBs::GetDBHandler($externalDBCredentials);
        return $dbHandler->getTableData($table_name, $perPage, $pageNo);
    }

    public static function GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials) {
        $dbHandler = ExternalDBs::GetDBHandler($externalDBCredentials);
        return $dbHandler->getTotalNumberTuplesInTable($table_name);
    }

	// select - valid sql select part
    // from -  tableName
    // where - valid SQL where part
    // group by - valid SQL group by
    // relationships - list of realtionship which should be used. If empty, all relationships between dataset will be used
    public static function PrepareAndRunQuery($select, $from, $where, $groupby, $perPage, $pageNo, $externalDBCredentials) {
    	$dbHandler = ExternalDBs::GetDBHandler($externalDBCredentials);
    	return $dbHandler->prepareAndRunQuery($select, $from, $where, $groupby, $perPage, $pageNo);
    }

    public static function ExecuteQuery($query, $externalDBCredentials) {
        $dbHandler = ExternalDBs::GetDBHandler($externalDBCredentials);
        return $dbHandler->ExecuteQuery($query);
    }
}

?>