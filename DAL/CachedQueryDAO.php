<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/CachedServerFacotry.php';

class CachedQueryDAO {

    private $ezSql;

    public function __construct() {
        global $db;
        $this->ezSql = $db;
    }

    public function getCacheQueryInfoByQuery($query) {
        


        $query = mysql_real_escape_string($query);
        $cachedQueryInfo = "SELECT * FROM `colfusion_cached_queries_info`  
            WHERE query = '$query'"; 

//var_dump($cachedQueryInfo);

        
        return $this->ezSql->get_row($cachedQueryInfo);
    }

    public function addCacheQuery($fromAndWherePart, $selectAllPart) {
        $dbHandler = CachedServerFacotry::createDatabaseHandler("mssql");

//var_dump($selectAllPart);

        $cacheQueryInfo = $this->saveNewQueryInTheDB($fromAndWherePart, $dbHandler);

        $dbHandler->ExecuteCTASQuery($selectAllPart, $cacheQueryInfo->tableName, $cacheQueryInfo->query);
    }

    public function saveNewQueryInTheDB($fromAndWherePart, $dbHandler) {

        $result = new stdClass();

        $result->query = mysql_real_escape_string($fromAndWherePart);
        $result->server_address = mysql_real_escape_string($dbHandler->getHost());
        $result->port = mysql_real_escape_string($dbHandler->getPort());
        $result->driver = mysql_real_escape_string($dbHandler->getDriver());
        $result->user_name = mysql_real_escape_string($dbHandler->getUser());
        $result->password = mysql_real_escape_string($dbHandler->getPassword());
        $result->database = mysql_real_escape_string($dbHandler->getDatabase());

        $sql = "INSERT INTO `colfusion_cached_queries_info`(`query`, `server_address`, `port`, `driver`, `user_name`, `password`, `database`, `tableName`, `expiration_date`) VALUES ('{$result->query}', '{$result->server_address}', '{$result->port}', '{$result->driver}', '{$result->user_name}', '{$result->password}', '{$result->database}', 'tableToUpdate', NOW())";

//var_dump($sql);

        $this->ezSql->query($sql);

        $result->cachedQueruId = $this->ezSql->insert_id;
        $result->tableName = "cachedTable_{$result->cachedQueruId}";

        $sql = "update colfusion_cached_queries_info set tableName = '{$result->tableName}' where id = {$result->cachedQueruId}";

//var_dump($sql);

        $this->ezSql->query($sql);

        return $result;
    }
  

}

?>
