<?php

session_start();

abstract class DatabaseImporter {

    protected $host;
    protected $port;
    protected $user;
    protected $password;
    protected $database;
    protected $engine;

    // Schema and data are imported in different steps, so cache dump file to fasten execution.
    // $sqlCommandCache[filePath] = cmds
    // TODO: very large dump file may exhaust memory, maybe we need to pipeline dump file instead of reading entire into mem.
    private $sqlCommandCache;

    public function __construct($user, $password, $database, $host, $port, $engine) {
        $this->host = $host;
        $this->port = $port;
        $this->user = $user;
        $this->database = $database;
        $this->password = $password;
        $this->engine = $engine;
        
        $this->sqlCommandCache = $_SESSION;
    }

    abstract public function importDbSchema($filePath, $sqlDelimiter = "/;/");

    abstract public function importDbData($filePath, $sqlDelimiter = "/;/");
    
    protected function execImportQuery($sql_query, $pdo) {
               
        foreach ($sql_query as $sql) {
            $sql .= ';';
            $sql = trim(preg_replace('/\n/', '', $sql));
            
            if (!empty($sql)) {
                $this->execOneQuery($sql, $pdo);
            }
        }
    }
    
    protected function execOneQuery($sql, $pdo){
        $pdo->exec($sql);
    }

    protected function parseSqlCommands($filePath, $filter_pattern = "/*/", $sqlDelimiter = "/;/"){

        if(isset($this->sqlCommandCache[$filePath])){
            $sql_query = $this->sqlCommandCache[$filePath];
        }else{
            $sql_query = @fread(@fopen($filePath, 'r'), @filesize($filePath));
            $sql_query = $this->split_sql_file($sql_query, $sqlDelimiter);
            $this->sqlCommandCache[$filePath] = $sql_query;
        }

        $filtered_sqlCommands = array();
        foreach($sql_query as $sql){

            $sql .= ';';
            $sql = preg_replace( "/\r|\n/", "", $sql);
                     
            preg_match($filter_pattern, $sql, $matches);
            $sql = count($matches) > 0 ? $matches[0] : '';

            if(!empty($sql)){
                $filtered_sqlCommands[] = $sql;
            }                    
        }

        return $filtered_sqlCommands;
    }

    // This function only removes comments wrapped in /**/ block.
    // It does not remove DB-specific comments.
    private function remove_comments(&$output) {
        $lines = explode("\n", $output);
        $output = "";

        // try to keep mem. use down
        $linecount = count($lines);

        for ($i = 0; $i < $linecount; $i++) {
            if (!preg_match("/(^\\\-\\\-)/", preg_quote($lines[$i]) && !preg_match("/\/\*.*\*\//", $lines[$i]))) {
                $output .= $lines[$i] . "\n";
            }
        }

        unset($lines);
        return $output;
    }

    //
    // remove_remarks will strip the sql comment lines out of an uploaded sql file
    //
    private function remove_remarks($sql) {
        $lines = explode("\n", $sql);

        // try to keep mem. use down
        $sql = "";

        $linecount = count($lines);
        $output = "";

        for ($i = 0; $i < $linecount; $i++) {
            if (($i != ($linecount - 1)) || (strlen($lines[$i]) > 0)) {
                if (isset($lines[$i][0]) && $lines[$i][0] != "#") {
                    $output .= $lines[$i] . "\n";
                } else {
                    $output .= "\n";
                }
                // Trading a bit of speed for lower mem. use here.
                $lines[$i] = "";
            }
        }

        return $output;
    }

    //
    // split_sql_file will split an uploaded sql file into single sql statements.
    // Note: expects trim() to have already been run on $sql.
    //
    private function split_sql_file($sql, $delimiter) {
        // Split up our string into "possible" SQL statements.
        $tokens = preg_split($delimiter, $sql);

        // try to save mem.
        $sql = "";
        $output = array();

        // we don't actually care about the matches preg gives us.
        $matches = array();

        // this is faster than calling count($oktens) every time thru the loop.
        $token_count = count($tokens);
        for ($i = 0; $i < $token_count; $i++) {

            // Don't wanna add an empty string as the last thing in the array.
            if (($i != ($token_count - 1)) || (strlen($tokens[$i] > 0))) {

                // This is the total number of single quotes in the token.
                $total_quotes = preg_match_all("/'/", $tokens[$i], $matches);

                // Counts single quotes that are preceded by an odd number of backslashes,
                // which means they're escaped quotes.
                $escaped_quotes = preg_match_all("/(?<!\\\\)(\\\\\\\\)*\\\\'/", $tokens[$i], $matches);

                $unescaped_quotes = $total_quotes - $escaped_quotes;

                // If the number of unescaped quotes is even, then the delimiter did NOT occur inside a string literal.
                if (($unescaped_quotes % 2) == 0) {

                    // It's a complete sql statement.
                    $output[] = $tokens[$i];
                    // save memory.
                    $tokens[$i] = "";

                } else {

                    // incomplete sql statement. keep adding tokens until we have a complete one.
                    // $temp will hold what we have so far.
                    $temp = $tokens[$i] . $delimiter;
                    // save memory..
                    $tokens[$i] = "";

                    // Do we have a complete statement yet?
                    $complete_stmt = false;

                    for ($j = $i + 1; (!$complete_stmt && ($j < $token_count)); $j++) {
                        // This is the total number of single quotes in the token.
                        $total_quotes = preg_match_all("/'/", $tokens[$j], $matches);
                        // Counts single quotes that are preceded by an odd number of backslashes,
                        // which means they're escaped quotes.
                        $escaped_quotes = preg_match_all("/(?<!\\\\)(\\\\\\\\)*\\\\'/", $tokens[$j], $matches);

                        $unescaped_quotes = $total_quotes - $escaped_quotes;

                        if (($unescaped_quotes % 2) == 1) {
                            // odd number of unescaped quotes. In combination with the previous incomplete
                            // statement(s), we now have a complete statement. (2 odds always make an even)
                            $output[] = $temp . $tokens[$j];

                            // save memory.
                            $tokens[$j] = "";
                            $temp = "";

                            // exit the loop.
                            $complete_stmt = true;
                            // make sure the outer loop continues at the right point.
                            $i = $j;
                        } else {
                            // even number of unescaped quotes. We still don't have a complete statement.
                            // (1 odd and 1 even always make an odd)
                            $temp .= $tokens[$j] . $delimiter;
                            // save memory.
                            $tokens[$j] = "";
                        }
                    }
                }
            }
        }
        return $output;
    }

    public function getDatabase() {
        return $this->database;
    }

    public function unsetSqlCommandCache($filePath){
        unset($this->sqlCommandCache[$filePath]);
    }
}

?>
