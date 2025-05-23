extends Node2D

class_name AstarNode

class ArrayNode:
	
	var walkable:bool
	var worldPosition: Vector2
	var gridX
	var gridY
	
	var gCost: int
	var hCost: int
	var parent: ArrayNode
	
	func _init(_walkable:bool, _worldPos:Vector2, _gridX:int, _gridY:int):
		walkable = _walkable
		worldPosition = _worldPos
		gridX = _gridX
		gridY = _gridY
	
	func fCost():
		return gCost + hCost

var path:Array

var grid:Array
var nodeGrid:Array

var seeker: Vector2 
var target:Vector2

var startNode: ArrayNode
var targetNode: ArrayNode 

var allPlayers:Array

func _init(_grid):
	grid = _grid

#All grid position generated are normalized to walkable and non-walkable nodes
func normalizeNode(_player):
	allPlayers = WorldSpace.matchPlayers
	
	var notWalkable:Array
	
	allPlayers.erase(_player)
	
	for player in allPlayers:
		var gridPosition = positionToGrid(player.global_position)
		var gridNeighbours = getNeighbours(gridPosition)
		notWalkable.append(gridPosition)
#		notWalkable.append_array(gridNeighbours)
	
	for node in notWalkable:
		node.walkable = false

# Stores nodes around the parent node and returns array
func getNeighbours(node: ArrayNode):
	var neighbours:Array = []
	for y in range(-1, 2):
		for x in range(-1, 2):
			if x == 0 and y == 0:
				continue
			var checkX = node.gridX + x
			var checkY = node.gridY + y
			if checkX < 0 or checkX >= grid[0].size():
				continue
			if checkY < 0 or checkY >= grid.size():
				continue
			neighbours.append(grid[checkY][checkX])
	return neighbours


# returns an object Arraynode from a vector2 world position input
func positionToGrid(_position: Vector2):
	var node = grid[0][0]
	for i in range(grid.size()):
		for j in range(grid[i].size()):
			var point = grid[i][j].worldPosition
			if grid[i][j].worldPosition.distance_to(_position) < node.worldPosition.distance_to(_position):
				node = grid[i][j]
	return node


# Generates a path from source to destination
func path(start:Vector2, end:Vector2) -> Array:
	startNode = positionToGrid(start)
	targetNode = positionToGrid(end)
	
	var openSet = []
	var closedSet = []
	
	openSet.append(startNode)
	
	while openSet.size() > 0:
		var currentNode = openSet[0]
		for i in range(openSet.size()):
			if openSet[i].fCost() < currentNode.fCost() or (openSet[i].fCost() == currentNode.fCost() and openSet[i].hCost < currentNode.hCost):
				currentNode = openSet[i]
		openSet.erase(currentNode)
		closedSet.append(currentNode)
		
		if currentNode == targetNode:
			return RetracePath(currentNode)
		
		for neighbour in getNeighbours(currentNode):
			if (!neighbour.walkable or closedSet.has(neighbour)):
				continue
			var newMovementCostToNeighbour = currentNode.gCost + getDistance(currentNode, neighbour)
			if (newMovementCostToNeighbour < neighbour.gCost or !openSet.has(neighbour)):
				neighbour.gCost = newMovementCostToNeighbour
				neighbour.hCost = getDistance(neighbour,targetNode)
				neighbour.parent = currentNode
				
				if (!openSet.has(neighbour)):
					openSet.append(neighbour)
	
	return Array()


func getDistance(nodeA:ArrayNode, nodeB:ArrayNode):
	var dstX = abs(nodeA.gridX - nodeB.gridX)
	var dstY = abs(nodeA.gridY - nodeB.gridY)
	return 10 * (dstX + dstY)


# After path is generated, this functions retraces the steps taken by the Astar algorithm 
# and stores the objects in an array
func RetracePath(currentNode:ArrayNode):
	var retracePath = []
	while (currentNode != null):
		retracePath.append(currentNode)
		currentNode = currentNode.parent
	retracePath.invert()
	return retracePath


