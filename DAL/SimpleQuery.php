<?php

include_once(dirname(__FILE__) . '/../DAL/ExternalDBHandlers/MSSQLHandler.php');
include_once(dirname(__FILE__) . '/../DAL/LinkedServerCred.php');

require_once(realpath(dirname(__FILE__)) . "../vendor/autoload.php");

Logger::configure(realpath(dirname(__FILE__)) . '../conf/log4php.xml');

class SimpleQuery
{
    /**
     * [getNewSid description]
     * @param  [type] $author
     * @param  [type] $state
     * @return [type]
     */
    public function getNewSid($author, $state)
    {
        global $db;

        $datetime = date("Y-m-d H:i:s", mktime(date('H'), date('i'), date('s'), date('m'), date('d'), date('Y')));
        $sql = "INSERT INTO " . table_prefix . "sourceinfo (UserId, EntryDate, Status, source_type) VALUES ('$author','$datetime', '$state', 'database');";

        $rs = $db->query($sql);
        $newSid = mysql_insert_id();

        return $newSid;
    }

    public function setSourceTypeBySid($sid, $soureType)
    {
        global $db;

        $sql = "UPDATE " . table_prefix . "sourceinfo set source_type = '$soureType' where sid=$sid;";
        $db->query($sql);
    }

// Get info of all attachments of a source.
// Return an array of objects with properties mapped to table's columns.
    public function getSourceAttachmentsInfo($sid)
    {
        global $db;
        $sid = $db->escape($sid);
        $sql = "SELECT * FROM colfusion_des_attachments WHERE Sid='$sid';";
        $results = $db->get_results($sql);

        return $results;
    }

// Get source attachment info.
// Return an object with properties mapped to table's columns.
    public function getSourceAttachmentInfo($fileId)
    {
        global $db;
        $fileId = $db->escape($fileId);
        $sql = "SELECT * FROM colfusion_des_attachments WHERE FileId='$fileId';";
        $results = $db->get_results($sql);
        if ($results == null)
            return null;
        else
            return $results[0];
    }

// Store attachment info.
// Returns fileId.
    public function addSourceAttachmentInfo($sourceId, $userId, $title, $filename, $size, $description)
    {
        global $db;

        $title = $db->escape($title);
        $filename = $db->escape($filename);
        $description = $db->escape($description);
        $sql = "INSERT INTO colfusion_des_attachments (Sid, UserId, Title, Filename, Description, Size) VALUES ('$sourceId', '$userId', '$title', '$filename', '$description', '$size');";
        $db->query($sql);

        return mysql_insert_id();
    }

// Delete file info in DB.
// Use userId to check if the file is deleted by uploader.
// Return filename.
    public function deleteSourceAttachmentInfo($fileId, $userId)
    {
        global $db;

        $fileId = $db->escape($fileId);
        $userId = $db->escape($userId);

// Get filename.
        $filename_sql = "SELECT Filename FROM colfusion_des_attachments WHERE FileId='$fileId' AND UserId='$userId';";
        $results = $db->get_results($filename_sql);
        foreach ($results as $result) {
            $filename = $result->Filename;
        }

// Delete file info.
        $delete_sql = "DELETE FROM colfusion_des_attachments WHERE FileId='$fileId' AND UserId='$userId';";
        $db->query($delete_sql);

        return $filename;
    }

// Store info about external source db.
    public function addSourceDBInfo($sid, $server, $port, $user, $password, $database, $driver, $isImported, $linkedServerName)
    {

//var_dump($sid, $server, $port, $user, $password, $database, $driver, $isImported, $linkedServerName);

        global $db;

        $sid = $db->escape($sid);
        $server = $db->escape($server);
        $port = $db->escape($port);
        $user = $db->escape($user);
        $password = $db->escape($password);
        $database = $db->escape($database);
        $driver = $db->escape($driver);
        $isImported = $db->escape($isImported);
        $linkedServerName = $db->escape($linkedServerName);

        $sql = "INSERT INTO %ssourceinfo_DB (sid, server_address, port, user_name, password, source_database, driver, is_local, linked_server_name) VALUES (%d, '%s', %d, '%s', '%s', '%s', '%s', %d, '%s') 
                ON DUPLICATE KEY UPDATE server_address = values(server_address), port = values(port), user_name = values(user_name), 
                password = values(password), source_database = values(source_database), driver = values(driver), is_local = values(is_local), linked_server_name = values(linked_server_name)";
        $sql = sprintf($sql, table_prefix, $sid, $server, $port, $user, $password, $database, $driver, $isImported, $linkedServerName);
        $db->query($sql);

//        $this->addLinkedServer($server, $port, $user, $password, $database, $driver, $linkedServerName);
    }

    public function getSourceDBInfo($sid)
    {
        global $db;

        $query = "select * from colfusion_sourceinfo_DB where sid = $sid";

        return $db->get_row($sql);
    }

    private function addLinkedServer($server, $port, $user, $password, $database, $driver, $linkedServerName)
    {
        $MSSQLHandler = new MSSQLHandler(MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD, MSSQLWLS_DB_NAME, MSSQLWLS_DB_HOST, MSSQLWLS_DB_PORT, null, null);

        if ($server == "localhost")
            $host = COLFUSION_HOST;
        else
            $host = $server;

        $MSSQLHandler->AddLinkedServer($driver, $host, $port, $database, $user, $password, $linkedServerName);
    }

    public function dropLinkedServerIfExists($linkedServerName)
    {
        $MSSQLHandler = new MSSQLHandler(MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD, MSSQLWLS_DB_NAME, MSSQLWLS_DB_HOST, MSSQLWLS_DB_PORT, null, null);

        $MSSQLHandler->dropLinkedServerIfExists($linkedServerName);
    }

// Store metadata about column.
    public function addColumnInfo($sid, $newDname, $type, $unit, $description, $originaDname)
    {
        global $db;

        $sid = $db->escape($sid);
        $newDname = $db->escape($newDname);
        $type = $db->escape($type);
        $unit = $db->escape($unit);
        $description = $db->escape($description);
        $originaDname = $db->escape($originaDname);

        $sql = "INSERT INTO %sdnameinfo (sid, dname_chosen, dname_value_type, dname_value_unit, dname_value_description, dname_original_name) VALUES (%d, '%s', '%s', '%s', '%s', '%s')";
        $sql = sprintf($sql, table_prefix, $sid, $newDname, $type, $unit, $description, $originaDname);
        $db->query($sql);

        return mysql_insert_id();
    }

// Store metadata about column.
    public function addConstantColumnInfo($sid, $newDname, $type, $unit, $description, $originaDname, $value)
    {
        global $db;

        $sid = $db->escape($sid);
        $newDname = $db->escape($newDname);
        $type = $db->escape($type);
        $unit = $db->escape($unit);
        $description = $db->escape($description);
        $originaDname = $db->escape($originaDname);
        $value = $db->escape($value);

        $sql = "INSERT INTO %sdnameinfo (sid, dname_chosen, dname_value_type, dname_value_unit, dname_value_description, dname_original_name, isConstant, constant_value) VALUES (%d, '%s', '%s', '%s', '%s', '%s', 1, '%s')";
        $sql = sprintf($sql, table_prefix, $sid, $newDname, $type, $unit, $description, $originaDname, $value);
        $db->query($sql);

        return mysql_insert_id();
    }

// Store "parent" between column and tables
    public function addColumnTableInfo($cid, $tableName)
    {
        global $db;
        $logger = Logger::getLogger("generalLog");

        $cid = $db->escape($cid);
        $tableName = $db->escape($tableName);

        $sql = sprintf("INSERT INTO %scolumnTableInfo (cid, tableName) VALUES (%d, '%s')", table_prefix, $cid, $tableName);

        $logger->info("addColumnTableInfo SQL " . $sql);

        $db->query($sql);
    }

// Store "parent" between column and tables
    public function addColumnDataMatchingInfo($sid, $cid, $category, $suggestedValue)
    {
        global $db;

        $sid = $db->escape($sid);
        $cid = $db->escape($cid);
        $category = $db->escape($category);
        $suggestedValue = $db->escape($suggestedValue);

        $sql = sprintf("INSERT INTO %sdname_meta_data (sid, cid, type, value) VALUES (%d, %d, '%s', '%s')", table_prefix, $sid, $cid, $category, $suggestedValue);
        $db->query($sql);
    }

    public function addCidToNewData($sid, $tableName)
    {
        global $db;

        $tableName = mysql_real_escape_string($tableName);
        $query = <<< EOQ
             update colfusion_temporary t1
set cid =  (
    SELECT colfusion_dnameinfo.cid
    FROM colfusion_dnameinfo, colfusion_columnTableInfo
    where sid = t1.sid and dname_chosen = t1.dname
      and colfusion_dnameinfo.cid = colfusion_columnTableInfo.cid
      and colfusion_columnTableInfo.tableName = '$tableName'

   )
where cid is null and sid = $sid;
EOQ;

        $db->query($query);
    }

}
