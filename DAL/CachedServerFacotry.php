<?php

require_once(realpath(dirname(__FILE__)) . "/CachedServersCred.php");
require_once(realpath(dirname(__FILE__)) . "/ExternalDBHandlers/DatabaseHandlerFactory.php");

class CachedServerFacotry {
       
    public static function createDatabaseHandler($engine) {
        switch (strtolower($engine)) {
            case 'mysql':
                break;

            case 'mssql':
            case 'sql server':
                return DatabaseHandlerFactory::createDatabaseHandler($engine, MSSQL_CQS_DB_USER, MSSQL_CQS_DB_PASSWORD, MSSQL_CQS_DB_DATABASE, MSSQL_CQS_DB_HOST, MSSQL_CQS_DB_PORT, null, null);
                break;
            case 'postgresql':
               
                break;
            case 'oracle':
                break;
            default:
                throw new Exception('Invalid DBMS');
                break;
        }
    }

}

?>
