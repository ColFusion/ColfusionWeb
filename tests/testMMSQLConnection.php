<?php
   
   require_once(realpath(dirname(__FILE__)) . "/../DAL/LinkedServerCred.php");
   
   error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('error_log','cache/log.php');
   
   	 	if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            $conn_str = "sqlsrv:Server=" . MSSQLWLS_DB_HOST . "," . MSSQLWLS_DB_PORT . ";Database=" . MSSQLWLS_DB_NAME;
        } else {
            $conn_str = "dblib:dbname=" . MSSQLWLS_DB_NAME . ";host=" . MSSQLWLS_DB_HOST . ":" . MSSQLWLS_DB_PORT;
        }

        $pdo = new PDO($conn_str, MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->exec('SET QUOTED_IDENTIFIER ON');
        $pdo->exec('SET ANSI_WARNINGS ON');
        $pdo->exec('SET ANSI_PADDING ON');
        $pdo->exec('SET ANSI_NULLS ON');
        $pdo->exec('SET CONCAT_NULL_YIELDS_NULL ON');




        return $pdo;
   
   
 
?>	