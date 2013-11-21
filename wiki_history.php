<?php

    include_once('Smarty.class.php');
    $main_smarty = new Smarty;
    
    include('config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    include(mnminclude.'group.php');
    include(mnminclude.'smartyvariables.php');
    include_once(mnminclude.'user.php');
    
    global $current_user, $globals, $the_template, $smarty, $db;
    
    $target = $_GET['wiki'];
    $id = $_GET['id'];

    
    if($target=="title") {
        echo '<h2>Title History</h2>';
        $index = 1;
        //target =title
        echo '<table border="1">
             <tr>
             <th>INDEX</th>
             <th>MOFIDIED DATE</th>
             <th>TITLE</th>
             </tr>';
        
        $sql_select = "SELECT title_history, title_modify_date 
                       FROM link_".$id."_wiki_history 
                       WHERE title_history is not null";
        
        $result = mysql_query($sql_select);
        while($row = mysql_fetch_array($result)) {
            echo '<tr>';
            echo '<td style="padding: 10px;">' .$index . "</td>";
            echo '<td style="padding: 10px;">' . $row['title_modify_date'] . "</td>";
            echo '<td style="padding: 10px;">' . $row['title_history'] . "</td>";
            echo "</tr>";
            $index ++;
        }
        echo "</table>";
        
    }
    
    //target = description, description's history
    if($target=="description") {
        echo '<h2>Description History</h2>';
        $index = 1;
        echo '<table border="2">
             <tr>
             <th>INDEX</th>
             <th>MOFIDIED DATE</th>
             <th>DESCRIPTION</th>
             </tr>';
        
        $sql_select = "SELECT des_history, des_modify_date 
                       FROM link_".$id."_wiki_history 
                       WHERE des_history is not null";
        
        $result = mysql_query($sql_select);
        while($row = mysql_fetch_array($result)) {
            echo '<tr>';
            echo '<td style="padding: 10px;">' .$index . "</td>";
            echo '<td style="padding: 10px;">' . $row['des_modify_date'] . "</td>";
            echo '<td style="padding: 10px;">' . $row['des_history'] . "</td>";
            echo "</tr>";
            $index ++;
        }
        echo "</table>";
        
    }
    











?>