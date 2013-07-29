<?php
    //include_once(realpath(dirname(__FILE__)) . '/../advancedsearch/AdvSearch.php');

    require(realpath(dirname(__FILE__)) . "/../vendor/autoload.php");

 //   error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
 //   ini_set('display_errors', 1);


   // Connecting to the default port 7474 on localhost
    $client = new Everyman\Neo4j\Client();

    //print_r($client->getServerInfo());


    $sourceIndex = new Everyman\Neo4j\Index\NodeIndex($client, 'sources');
   // $sourceIndex->save();

/*    for ($i=1; $i <= 7; $i++) { 
        $source = $client->makeNode();
        $source->setProperty('name', "s$i")->save();

        // Index the ship on one of its properties
        $sourceIndex->add($source, 'name', $source->getProperty('name'));
    }

 


    
    $sourceId = $source->getId();

    echo $sourceId;
*/
    // Returns an array of matching entities
  //  $matches = $sourceIndex->query('name:*');

  //  var_dump($matches);

    $targetSids = array("s1", "s3", "s6", "s7");

    $allSearchRes = array();
    
    $targetSidsCopy = $targetSids;
    
    do {

		$node1Sid = array_pop($targetSidsCopy);

    	$res = rec($sourceIndex, $node1Sid, $targetSidsCopy);
    	
    	$oneSearchRes = new stdClass();
    	
    	if (count($res->ar) == 0) {
    		$oneSearchRes->oneSid = true;
    		$oneSearchRes->value = $node1Sid;
    	}
    	else {
    		$oneSearchRes->oneSid = false;
    		$oneSearchRes->value = $res->ar;
    	}
    	
    	$allSearchRes[] = $oneSearchRes;
    	
    	$targetSidsCopy = $res->needToCheck;
    	
    } while (count($targetSidsCopy) > 0);

    

    echo json_encode($allSearchRes);


/*    $targetSidsCopy = $targetSids;

    $allPath = array();

    while (count($targetSidsCopy) > 0) {
        $node1Sid = array_pop($targetSidsCopy);

        $copyOfShortTargetSids = $targetSidsCopy;

        //array_pop($copyOfShortTargetSids);

        $allPathFromNode1 = array();

        $found = false;

        while (count($copyOfShortTargetSids) > 0) {
            $node2Sid = array_pop($copyOfShortTargetSids);

            $startNode = $sourceIndex->queryOne("name:{$node1Sid}");
            $endNode = $sourceIndex->queryOne("name:{$node2Sid}");

            $paths = getAllPathsBetweenTwoNodes($startNode,  $endNode);

            if (count($paths->paths) == 0)
                continue;

            $found = true;

            $targetSidsCopy = array_diff($targetSidsCopy, array($node2Sid));

            if (count($allPathFromNode1) == 0)
                $allPathFromNode1 = $paths->paths;
            else {
                $res = array();

                for ($i=0; $i < count($allPathFromNode1); $i++) { 
                    for ($j=0; $j < count($paths->paths); $j++) { 
                        $res[] = array_merge($allPathFromNode1[$i], $paths->paths[$j]);
                    }
                }

                $allPathFromNode1 = $res;
            }
        }

        if (!$found) {
            $allPath[] = $node1Sid;
        }
        else {
            $allPath[] = $allPathFromNode1;
        }
    }



echo json_encode($allPath);
    */


/*
    for ($i=0; $i < count($targetSids); $i++) { 

        for ($j=$i + 1; $j < count($targetSids); $j++) { 
            echo "name:{$targetSids[$i]}<br/>";
            echo "name:{$targetSids[$j]}<br/>";
           
            $startNode = $sourceIndex->queryOne("name:{$targetSids[$i]}");
            $endNode = $sourceIndex->queryOne("name:{$targetSids[$j]}");

            $paths = getAllPathsBetweenTwoNodes($startNode,  $endNode);

            printAllPathsBetweenTwoNodes($paths);
        }
    }
*/
    

    exit();
    

    function rec($sourceIndex, $node, $list) {
echo $node;
        $result = new stdClass();

        if (count($list) == 0) {
            $result->ar = array();
            $result->needToCheck = array();
        }
        else {

            $otherNode = array_pop($list);
echo $otherNode;

            $startNode = $sourceIndex->queryOne("name:{$node}");
            $endNode = $sourceIndex->queryOne("name:{$otherNode}");

            $paths = getAllPathsBetweenTwoNodes($startNode,  $endNode);

            if (count($paths->paths) == 0) {
        
                $res = rec($sourceIndex, $node, $list);

                $result->ar = $res->ar;
                $result->needToCheck = array_merge($res->needToCheck, array($otherNode));
            }
            else {
                $res = rec($sourceIndex, $otherNode, $list);

                $res2 = array();

                if (count($res->ar) == 0) {
                    $res2 =$paths->paths;
                }
                else {

                    for ($j=0; $j < count($paths->paths); $j++) {
                        for ($i=0; $i < count($res->ar); $i++) { 
                            $res2[] = array_merge($paths->paths[$j], $res->ar[$i]);
                        }
                    }     
                }       

                $result->ar = $res2;
                $result->needToCheck = $res->needToCheck;
            }
        }

        return $result;
        
    }

function getAllPathsBetweenTwoNodes($node1, $node2){

    $result = new stdClass;

    $result->node1 = $node1;
    $result->node2 = $node2;
    
    $paths = $node1->findPathsTo($node2)->setMaxDepth(5)->setAlgorithm(Everyman\Neo4j\PathFinder::AlgoAllSimple)->getPaths();

    $result->pathsNeo4j = $paths;
    $result->paths = array();

    foreach ($paths as $i => $path) {
        $path->setContext(Everyman\Neo4j\Path::ContextRelationship);
        $totalConfidence = 0;

      //  $pathToResult = new stdClass();
        $pathSteps = array();

        foreach ($path as $j => $rel) {
            $direction = $rel->getProperty('rel_id');
            $confidence = $rel->getProperty('confidence');
            
            $step = $j+1;
            $totalConfidence += $confidence;

            $pathStep = new stdClass();
           // $pathStep->stepIndex = $step;
            $pathStep->rel_id = $direction;
            $pathStep->confidence = $confidence;

            $pathSteps[] = $pathStep;           
        }

     //   $avgConfidence = $totalConfidence / $step;

     //   $pathToResult->pathSteps = $pathSteps;
     //   $pathToResult->avgConfidence = $avgConfidence;
     //   $pathToResult->numOfSteps = $step;

        $result->paths[] = $pathSteps;//$pathToResult;
    }

    return $result;
}

function printAllPathsBetweenTwoNodes($paths){

   

    echo "Start node id: " . $paths->node1->getId() . "<br/>";
    echo "End node id: " . $paths->node2->getId() . "<br/>";

    echo "Total paths: " . count($paths->paths) . "<br/>";


    foreach ($paths->paths as $i => $path) {
        
        echo "Path " . ($i+1) .":<br/>";
        foreach ($path->pathSteps as $j => $step) {
            $direction = $step->rel_id;
            $confidence = $step->confidence;
            
            echo "Step {$step->stepIndex}: {$direction} for {$confidence} conf.<br/>";
        }
        
        echo "Average confidence: {$path->avgConfidence}<br/>";
        echo "Num of steps: {$path->numOfSteps}<br/>";
        echo "<br/>";
    }
}
 
?>	