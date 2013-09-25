<?php

include_once(realpath(dirname(__FILE__)) . "/../config.php");

class DALUtils {

    public static function GetExternalDBCredentialsBySid($sid) {
        global $db;

        $sql = "SELECT * FROM colfusion_sourceinfo_DB where sid = $sid";
        $res = $db->get_results($sql);

        if (isset($res))
            return $res[0];
        else
        //TODO: throw error here
            die('Data source not found.');
    }

    public static function GetSourceType($sid) {
        global $db;

        $sql = "select source_type from colfusion_sourceinfo where sid = $sid";

        $res = $db->get_results($sql);

        if (isset($res))
            return $res[0]->source_type;
        else
        //TODO: throw error here
            die('Source not found GetSourceType');
    }

    public static function GetFileNameBySid($sid) {
        global $db;

        $sql = "SELECT raw_data_path FROM colfusion_sourceinfo where sid = $sid";

        $res = $db->get_results($sql);

        if (isset($res))
            return array($res[0]->raw_data_path);
        else
        //TODO: throw error here
            die('Source not found GetFileNameBySid');
    }


   
}

?>