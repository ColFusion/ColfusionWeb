<?php

class SimpleQuery {

    public function getNewSid($author, $state) {
        global $db;

        $datetime = date("Y-m-d H:i:s", mktime(date('H'), date('i'), date('s'), date('m'), date('d'), date('Y')));
        $sql = "INSERT INTO " . table_prefix . "sourceinfo (UserId, EntryDate, Status) VALUES ('$author','$datetime', '$state');";

        $rs = $db->query($sql);
        $newSid = mysql_insert_id();

        return $newSid;
    }
    
    public function setSourceTypeBySid($sid, $soureType){
    	global $db;
    	
    	$sql = "UPDATE " . table_prefix . "sourceinfo set source_type = '$soureType' where sid=$sid;";
    	$db->query($sql);
    }

    // Get info of all attachments of a source.
    // Return an array of objects with properties mapped to table's columns.
    public function getSourceAttachmentsInfo($sid){
        global $db;
        $sid = $db->escape($sid);                          
        $sql = "SELECT * FROM colfusion_des_attachments WHERE Sid='$sid';";
        $results = $db->get_results($sql);    
        return $results;
    }
    
    // Get source attachment info.
    // Return an object with properties mapped to table's columns.
    public function getSourceAttachmentInfo($fileId) {
        global $db;
        $fileId = $db->escape($fileId);                          
        $sql = "SELECT * FROM colfusion_des_attachments WHERE FileId='$fileId';";
        $results = $db->get_results($sql);
        if($results == null) return null;
        else return $results[0];
    }

    // Store attachment info.
    // Returns fileId.
    public function addSourceAttachmentInfo($sourceId, $userId, $title, $filename, $size, $description) {
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
    public function deleteSourceAttachmentInfo($fileId, $userId) {
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
    public function addSourceDBInfo($sid, $server, $port, $user, $password, $database, $driver) {
    	global $db;
    
    	$sid = $db->escape($sid);
    	$server = $db->escape($server);
    	$port = $db->escape($port);
    	$user = $db->escape($user);
    	$password = $db->escape($password);
    	$database = $db->escape($database);
    	$driver = $db->escape($driver);
    	    	
    
    	$sql = "INSERT INTO %ssourceinfo_DB (sid, server_address, port, user_name, password, source_database, driver) VALUES (%d, '%s', %d, '%s', '%s', '%s', '%s')";
    	
    	$sql=sprintf($sql, table_prefix, $sid, $server, $port, $user, $password, $database, $driver);
    	$rs=$db->query($sql);    	
    }
    
    // Store metadata about column.
    public function addColumnInfo($sid, $newDname, $type, $unit, $description, $originaDname) {
    	global $db;
    
    	$sid = $db->escape($sid);
    	$newDname = $db->escape($newDname);
    	$type = $db->escape($type);
    	$unit = $db->escape($unit);
    	$description = $db->escape($description);
    	$originaDname = $db->escape($originaDname);
    	    	
    	$sql = "INSERT INTO %sdnameinfo (sid, dname_chosen, dname_value_type, dname_value_unit, dname_value_description, dname_original_name) VALUES (%d, '%s', '%s', '%s', '%s', '%s')";
    		    		
    	$sql=sprintf($sql, table_prefix, $sid, $newDname, $type, $unit, $description, $originaDname);
    	$rs=$db->query($sql);
    	
    	return mysql_insert_id();
    }
    
    // Store metadata about column.
    public function addConstantColumnInfo($sid, $newDname, $type, $unit, $description, $originaDname, $value) {
    	global $db;
    
    	$sid = $db->escape($sid);
    	$newDname = $db->escape($newDname);
    	$type = $db->escape($type);
    	$unit = $db->escape($unit);
    	$description = $db->escape($description);
    	$originaDname = $db->escape($originaDname);
    	$value = $db->escape($value);
    
    	$sql = "INSERT INTO %sdnameinfo (sid, dname_chosen, dname_value_type, dname_value_unit, dname_value_description, dname_original_name, isConstant, constant_value) VALUES (%d, '%s', '%s', '%s', '%s', '%s', 1, '%s')";
    
    	$sql=sprintf($sql, table_prefix, $sid, $newDname, $type, $unit, $description, $originaDname, $value);
    	$rs=$db->query($sql);
    	 
    	return mysql_insert_id();
    }
    
    // Store "parent" between column and tables
    public function addColumnTableInfo($cid, $tableName) {
    	global $db;
    
    	$cid = $db->escape($cid);
    	$tableName = $db->escape($tableName);
    	    
    	$sql = "INSERT INTO %scolumnTableInfo (cid, tableName) VALUES (%d, '%s')";
    	
		$sql=sprintf($sql, table_prefix, $cid, $tableName);
		$rs=$db->query($sql);
    }
    
    // Store "parent" between column and tables
    public function addColumnDataMatchingInfo($sid, $cid, $category, $suggestedValue) {
    	global $db;
    
    	$sid = $db->escape($sid);
    	$cid = $db->escape($cid);
    	$category = $db->escape($category);
    	$suggestedValue = $db->escape($suggestedValue);
    		
    	$sql = "INSERT INTO %sdname_meta_data (sid, cid, type, value) VALUES (%d, %d, '%s', '%s')";
		
		$sql=sprintf($sql, table_prefix, $newSid, $cid, $category, $suggestedValue);
		$rs=$db->query($sql);
    }
}

?>