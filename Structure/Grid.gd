extends Node

class_name Grid

var start:Vector2
var end:Vector2

var playerSize = 12

var colNum:int = 24
var rowNum:int = 12

var width:float
var height:float

var grid:Array
var astarGrid:Array

func _init(startPos, endPos):
	start = startPos
	end = endPos
	
	var heightDiff = end.y - start.y
	var widthDiff = end.x - start.x
	
	colNum = widthDiff / playerSize
	rowNum = colNum / 2
	
	width = widthDiff / colNum
	height = heightDiff / rowNum
	
	start += Vector2(width/2, height/2)
	end -= Vector2(width/2, height/2)
	
	heightDiff = end.y - start.y
	widthDiff = end.x - start.x
	
	colNum = widthDiff / playerSize
	rowNum = colNum / 2
	
	width = widthDiff / colNum
	height = heightDiff / rowNum
	
	print("Start position is " + String(start))
	print("End position is " + String(end))

func createGrid():
	print_debug("Initializing grid structure")
	var tempGrid:Array
	for y in range(0,rowNum):
		tempGrid = []
		for x in range(0,colNum):
			if grid.empty() and tempGrid.empty():
				tempGrid.append(start)
			elif tempGrid.empty():
				tempGrid.append(grid[y-1][0] + Vector2(0,height))
			else:
				tempGrid.append(tempGrid[x-1] + Vector2(width, 0))
		grid.append(tempGrid)
	setAstarGrid()

func setAstarGrid():
	var temparray:Array = []
	var walkable:bool = true
	var x:int
	var y:int
	for i in grid:
		x = 0
		temparray = []
		for a in i:
			temparray.append(AstarNode.ArrayNode.new(walkable, a, x, y))
			x += 1
		astarGrid.append(temparray)
		y += 1

func getAstarGrid():
	return astarGrid



