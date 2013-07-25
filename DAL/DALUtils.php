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


    // Decode cid(xxx) in link parts and return an array of used column names.
    public static function  getUsedColumnNames(array $linkParts) {
        global $db;

        foreach ($linkParts as $linkPart) {
            preg_match_all('/cid\([0-9]+\)/', $linkPart, $matches);
            foreach ($matches[0] as $match) {
                $encodedCols[$match] = $match;
            }
        }
        $encodedCols = array_keys($encodedCols);

        $sql = "select cid, dname_chosen from `colfusion_dnameinfo` where 1=2";
        foreach ($encodedCols as $encodedCol) {
            $cid = substr($encodedCol, 4, strlen($encodedCol) - 5);
            $sql .= " OR cid=$cid";
        }

        
        $colNameRows = $db->get_results($sql);
        foreach ($colNameRows as $colNameRow) {
            $colNames[$colNameRow->cid] = $colNameRow->dname_chosen;
        }

        return $colNames;
    }

    public static function decodeLinkPart($linkPart, $usedColumnNames) {
        preg_match_all('/cid\([0-9]+\)/', $linkPart, $matches);
        foreach ($matches[0] as $match) {
            $cid = substr($match, 4, strlen($match) - 5);
            $linkPart = str_replace("cid($cid)", "$usedColumnNames[$cid]", $linkPart);
        }

        return $linkPart;
    }
}

?>