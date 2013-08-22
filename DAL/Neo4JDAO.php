<?php

require_once(realpath(dirname(__FILE__)) . "/../vendor/autoload.php");

use Everyman\Neo4j\Node,
    Everyman\Neo4j\Index;

/**
* Opeartions with Neo4J
*/
class Neo4JDAO
{
	const nodeIndexName = "sources";
	const relationshipIndexName = "rels";
	
	private $client;
	private $nodeIndex;
	private $relationshipIndex;

	public function __construct()
	{
		$this->client = $this->getClient();
		$this->nodeIndex = $this->getNodeIndex();
		$this->relationshipIndex = $this->getRelationshipIndex();
	}

	private function getClient()
	{
		// Connecting to the default port 7474 on localhost
        $client = new Everyman\Neo4j\Client();

        return $client;
	}

	private function getNodeIndex()
	{
		return new Index($this->client, Index::TypeNode, self::nodeIndexName);
	}

	private function getRelationshipIndex()
	{
		return new Index($this->client, Index::TypeRelationship, self::relationshipIndexName);
	}

	/**
	 * Returns existng node by sid property or creates new node if the nodes could not be found.
	 * @param  [type] $sid sid of the node to search by or set.
	 * @return Node      found or created node
	 */
	private function getOrAddNode($sid)
	{
		$node = $this->getNode($sid);

        if (!isset($node)) {
            $node = $this->client->makeNode();
            $node->setProperty('sid', $sid)->save();
            $this->nodeIndex->add($node, 'sid', $sid);
            $this->nodeIndex->save();
        }

        return $node;
	}

	/**
	 * Returns existng node by sid property.
	 * @param  [type] $sid sid of the node to search by or set.
	 * @return Node      found node or null
	 */
	public function getNode($sid)
	{
		$node = $this->nodeIndex->queryOne("sid:$sid");

        return $node;
	}

	/**
	 * Add relationship between two nodes. If either of the nodes does not exist, a node will be created. 
	 * @param [type] $sidFrom sid of the one of the nodes (e.g., sidFrom)
	 * @param [type] $sidTo   sid of the other node (e.g., sidTo)
	 * @param [type] $rel_id  rel_id to set up as a property for the relationship
	 * @param [type] $cost    reciprocal of confidence. Will be used to find the best path
	 * @throws Exception If either of the nodes are null
	 */
	public function addRelationship($sidFrom, $sidTo, $rel_id, $cost) {

		if (!isset($sidFrom) || !isset($sidTo) || $sidFrom == "" || $sidTo == "")
            throw new Exception("Sids cannot be empty to create a relationship.", 1);


        $sourceFrom = $this->getOrAddNode($sidFrom);

        $sourceTo = $this->getOrAddNode($sidTo);
        
        if (!isset($sourceFrom) || !isset($sourceTo))
            throw new Exception("Cannot add relationship on neo4j, one of the nodes is null", 1);

        $rel = $sourceFrom->relateTo($sourceTo, 'RELATED_TO');

        $rel->setProperty('rel_id', $rel_id)
            ->setProperty('cost', $cost)
            ->save();

        $this->relationshipIndex->add($rel, 'rel_id',  $rel_id);
        $this->relationshipIndex->save();
    }

    /**
     * Delete a node from the graph by sid property. If the node has any relationships, those relationships will be deleted at first.
     * @param  [type] $sid sid of the node to delete
     */
    public function deleteNodeBySid($sid)
    {
    	$node = $this->getNode($sid);

	    if (isset($node)) {
    	    $rels = $node->getRelationships();

	        if (isset($rels) && count($rels) > 0) {
        	    foreach ($rels as $key => $rel) {
            	    $rel->delete();
         	   }
        	}

        	$node->delete();
    	}
    }

    /**
     * Delete a relationship from the graph by rel_id property. 
     * @param  [type] $rel_id rel_id of the relationship to delete
     */
    public function deleteRelationshipByRelId($rel_id)
    {
    	$rel = $this->relationshipIndex->queryOne("rel_id:$rel_id");

	    if (isset($rel)) {
    	    $rel->delete();
    	}
    }

    /**
     * Update cost propery of a relationship from the graph by rel_id property. 
     * @param  [type] $rel_id rel_id of the relationship to delete
     */
    public function updateCostByRelId($rel_id, $cost)
    {
    	$rel = $this->relationshipIndex->queryOne("rel_id:$rel_id");

	    if (isset($rel)) {
    	    $rel->setProperty('cost', $cost)
            	->save();
    	}
    }

    /**
     * Returns an array of paths between two nodes identified by sid property. Each element of the array is an array of rel_id of one path.
     * @param  [type] $sid1 sid of one node
     * @param  [type] $sid2 sid of another node
     * @return array of array       all paths between two nodes.
     */
    public function getAllPathsBetweenTwoNodes($sid1, $sid2)
    {
    	$paths = array();

    	$startNode = $this->getNode($sid1);
        $endNode = $this->getNode($sid2);

        if (isset($startNode) && !isset($endNode)) 
        {
		    $neo4jPaths = $node1->findPathsTo($node2)->setMaxDepth(5)->setAlgorithm(Everyman\Neo4j\PathFinder::AlgoAllSimple)->getPaths();

		    foreach ($neo4jPaths as $i => $neo4jPath) {
		        $path->setContext(Everyman\Neo4j\Path::ContextRelationship);

		        $pathSteps = array();

		        foreach ($neo4jPath as $j => $rel) 
		        {
		            $pathSteps[] = $rel->getProperty('rel_id');           
		        }

		        $paths[] = $pathSteps;
		    }
		}

		return $paths;
    }
}

?>