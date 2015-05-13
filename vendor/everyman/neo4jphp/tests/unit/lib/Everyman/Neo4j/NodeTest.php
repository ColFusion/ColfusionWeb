<?php
namespace Everyman\Neo4j;

class NodeTest extends \PHPUnit_Framework_TestCase
{
	protected $client = null;
	protected $node = null;

	public function setUp()
	{
		$this->client = $this->getMock('Everyman\Neo4j\Client', array(
			'saveNode',
			'deleteNode',
			'loadNode',
			'getNodeRelationships',
			'runCommand',
		));
		$this->node = new Node($this->client);
	}

	public function testSave_SavesSelfUsingClient()
	{
		$expected = $this->node;
		$matched = false;

		$this->client->expects($this->once())
			->method('saveNode')
			// Have to do it this way because PHPUnit clones object parameters
			->will($this->returnCallback(function (Node $actual) use ($expected, &$matched) {
				$matched = $expected->getId() == $actual->getId();
				return true;
			}));

		$this->node->setId(123);
		$this->assertSame($this->node, $this->node->save());
		$this->assertTrue($matched);
	}

	/**
	 * Test for https://github.com/jadell/neo4jphp/issues/58
	 */
	public function testSave_FollowedByPropertyGet_DoesNotLazyLoad()
	{
		$this->client->expects($this->once())
			->method('saveNode')
			->will($this->returnValue(true));

		$this->client->expects($this->never())
			->method('loadNode');

		$this->node->setId(123);
		$this->node->save();
		$this->node->getProperty('foo');
	}

	public function testDelete_DeletesSelfUsingClient()
	{
		$this->client->expects($this->once())
			->method('deleteNode')
			->with($this->node)
			->will($this->returnValue(true));

		$this->assertSame($this->node, $this->node->delete());
	}

	public function testLoad_LoadsSelfUsingClient()
	{
		$this->client->expects($this->once())
			->method('loadNode')
			->with($this->node)
			->will($this->returnValue(true));

		$this->assertSame($this->node, $this->node->load());
	}

	public function testGetRelationships_ReturnsArrayOfRelationships()
	{
		$dir = Relationship::DirectionOut;
		$types = array('FOOTYPE','BARTYPE');

		$returnRels = array(
			new Relationship($this->client),
			new Relationship($this->client),
		);

		$this->client->expects($this->once())
			->method('getNodeRelationships')
			->with($this->node, $types, $dir)
			->will($this->returnValue($returnRels));

		$rels = $this->node->getRelationships($types, $dir);
		$this->assertEquals($returnRels, $rels);
	}

	public function testGetFirstRelationship_ReturnsRelationship()
	{
		$dir = Relationship::DirectionOut;
		$types = array('FOOTYPE','BARTYPE');

		$returnRels = array(
			new Relationship($this->client),
			new Relationship($this->client),
		);

		$this->client->expects($this->once())
			->method('getNodeRelationships')
			->with($this->node, $types, $dir)
			->will($this->returnValue($returnRels));

		$rel = $this->node->getFirstRelationship($types, $dir);
		$this->assertSame($returnRels[0], $rel);
	}

	public function testGetFirstRelationship_NoneFound_ReturnsNull()
	{
		$dir = Relationship::DirectionOut;
		$types = array('FOOTYPE','BARTYPE');

		$returnRels = array();

		$this->client->expects($this->once())
			->method('getNodeRelationships')
			->with($this->node, $types, $dir)
			->will($this->returnValue($returnRels));

		$rel = $this->node->getFirstRelationship($types, $dir);
		$this->assertNull($rel);
	}

	public function testRelateTo_ReturnsRelationship()
	{
		$toNode = new Node($this->client);
		$type = 'FOOTYPE';

		$rel = $this->node->relateTo($toNode, $type);
		$this->assertInstanceOf('Everyman\Neo4j\Relationship', $rel);
		$this->assertSame($this->client, $rel->getClient());
		$this->assertSame($this->node, $rel->getStartNode());
		$this->assertSame($toNode, $rel->getEndNode());
		$this->assertEquals($type, $rel->getType());
	}

	public function testFindPathsTo_ReturnsPathFinder()
	{
		$toNode = new Node($this->client);
		$type = 'FOOTYPE';
		$dir = Relationship::DirectionOut;

		$finder = $this->node->findPathsTo($toNode, $type, $dir);
		$this->assertInstanceOf('Everyman\Neo4j\PathFinder', $finder);
		$this->assertSame($this->node, $finder->getStartNode());
		$this->assertSame($toNode, $finder->getEndNode());
		$this->assertEquals($dir, $finder->getDirection());
		$this->assertEquals($type, $finder->getType());
	}
}
