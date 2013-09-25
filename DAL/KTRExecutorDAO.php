<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';

/**
 * Database operations performed by KTRExecutor
 */
class KTRExecutorDAO
{

    private $ezSql;

    private $pentaho_err_code = array(
        0 => 'The transformation ran without a problem',
        1 => "Errors occurred during processing",
        2 => "An unexpected error occurred during loading / running of the transformation",
        3 => "Unable to prepare and initialize this transformation",
        7 => "The transformation couldn't be loaded from XML or the Repository",
        8 => "Error loading steps or plugins (error in loading one of the plugins mostly)",
        9 => "Command line usage printing",
        10 => "Errors occur when storing source information"
    );

    public function __construct()
    {
        global $db;
        $this->ezSql = $db;
    }

    /**
     * Adds a tuple in the executeinfo table and returns eid.
     * @param         $sid    sid of the sotry for which the transformation will be run.
     * @param         $userId user who starts the transformation.
     * @throws Exception If query failed.
     */
    public function addExecutionInfoTuple($sid, $tableName, $userId)
    {
        $sql = "INSERT INTO " . table_prefix . "executeinfo (Sid, tableName, UserId, TimeStart, status)VALUES ($sid, '$tableName', $userId, CURRENT_TIMESTAMP, 'in progress');";

        try {
            $this->ezSql->query($sql);
            //get eid returned from the insert
            $logID = mysql_insert_id();

        }
        catch (Exception $e) {
            throw new Exception("Error Processing Request. Could not execute the query", 1);
        }

        return $logID;
    }

    /**
     * Set command column to the specified value for the execution info tuple identified by logID.
     * @param         $logID   eid of execution info tuple.
     * @param      $command the command value to set.
     * @throws Exception If query failed.
     */
    public function updateExecutionInfoTupleCommand( $logID,  $command)
    {
        $command = mysql_real_escape_string($command);  

        $sql = "UPDATE " . table_prefix . "executeinfo SET pan_command = '$command' WHERE Eid = $logID";

        try {
            $this->ezSql->query($sql);

        }
        catch (Exception $e) {
            throw new Exception("Error Processing Request. Could not execute the query", 1);
        }
    }

    /**
     * Update status column to the provided status value for the execution info tuple which is identified by given logid.
     * @param         $logID  eid of execution info tuple.
     * @param      $status status value to set.
     * @throws Exception If query failed.
     */
    public function updateExecutionInfoTupleStatus( $logID,  $status)
    {

        $status = mysql_real_escape_string($status); 
        $sql = "UPDATE " . table_prefix . "executeinfo SET status = '$status' WHERE Eid = $logID";

        try {
            $this->ezSql->query($sql);

        }
        catch (Exception $e) {
            throw new Exception("Error Processing Request. Could not execute the query", 1);
        }
    }

    public function updateExecutionInfoErrorMessage( $logID, $errorMessage)
    {
        $errorMessage = mysql_real_escape_string($errorMessage); 

        $sql = "UPDATE " . table_prefix . "executeinfo SET ErrorMessage='$errorMessage' WHERE EID= $logID";
        try {
            $this->ezSql->query($sql);
        }
        catch (Exception $e) {
            throw new Exception("Error Processing Request. Could not execute the query", 1);
        }
    }

    public function updateExecutionInfoTimeEnd($logID, $numProcessed)
    {
        $sql = "UPDATE " . table_prefix . "executeinfo SET RecordsProcessed='$numProcessed' WHERE EID= $logID";
        try {
            $this->ezSql->query($sql);
        }
        catch (Exception $e) {
            throw new Exception("Error Processing Request. Could not execute the query", 1);
        }
    }
    
    public function updateExecutionInfoNumProcessed($logID)
    {
        $sql = "UPDATE " . table_prefix . "executeinfo SET TimeEnd=CURRENT_TIMESTAMP WHERE EID= $logID";
        try {
            $this->ezSql->query($sql);
        }
        catch (Exception $e) {
            throw new Exception("Error Processing Request. Could not execute the query", 1);
        }
    }

    /**
     * Logs final messages to the execute info table depending on the returned value from pan execution.
     * @param         $logID        eid of execution info tuple.
     * @param         $returnVar    pan returned status number.
     * @param      $errorMessage pan output.
     * @param         $numProcessed number of processed records.
     * @param      $status       status value to set.
     * @throws Exception If query failed.
     */
    public function updateExecutionInfoTupleAfterPanTerminated( $logID,  $returnVar,  $errorMessage,  $numProcessed,  $status)
    {
        $errorMessage = mysql_real_escape_string($errorMessage); 
        $status = mysql_real_escape_string($status); 

        $sql = "UPDATE " . table_prefix . "executeinfo SET ExitStatus=$returnVar, ErrorMessage='$errorMessage',
                RecordsProcessed='$numProcessed', TimeEnd=CURRENT_TIMESTAMP, status = '$status' WHERE EID= $logID";

        try {
            $this->ezSql->query($sql);

        }
        catch (Exception $e) {
            throw new Exception("Error Processing Request. Could not execute the query", 1);
        }
    }

    /**
     * Returns array of objects which holds all information about the tuples for gien sid.
     * @param  [type] $sid sid to check.
     * @return array      array of rows from the table.
     * @throws Exception If query failed.
     */
    public function getTuplesBySid($sid)
    {
        $sql = "SELECT * FROM " . table_prefix . "executeinfo WHERE Sid= $sid";

        try {
            return $this->ezSql->get_results($sql);

        }
        catch (Exception $e) {
            throw new Exception("Error Processing Request. Could not execute the query", 1);
        }
    }
}
