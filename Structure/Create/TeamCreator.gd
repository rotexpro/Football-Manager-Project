extends Node

class_name TeamCreator

enum positionSpecs{
	LEFT,
	RIGHT,
	DEFAULT
}

enum matchPlace{
	HOME,
	AWAY
}

var playerResource = load("res://player/Scenes/player.tscn")

func createTeam(positions:Dictionary, squadPlayers, matchplace) -> Array:
	var squadTeam:Array
	print_debug("creating player objects")
	for data in squadPlayers:
		print_debug("instancing player object")
		var player = playerResource.instance()
		print_debug("setting player position")
		setPosition(positions,player,data,matchplace)
		squadTeam.append(player)
		print("player created")
	return squadTeam

func setPosition(positions,player:Player,data,matchplace):
	player.stats = data
	var role:String = player.stats.tempRole
	var side = player.stats.position
	match side:
		positionSpecs.LEFT:
			var pos = positions.get(role) - Vector2(0,50)
			print("player position for : " + player.stats.playerName + " with role : "+ player.stats.role + " is " + String(pos))
			player.fieldPosition = pos
			player.global_position = pos
		positionSpecs.RIGHT:
			var pos = positions.get(role) + Vector2(0,50)
			print("player position for : " + player.stats.playerName + " with role : "+ player.stats.role + " is " + String(pos))
			player.fieldPosition = pos
			player.global_position = pos
		positionSpecs.DEFAULT:
			var pos = positions.get(role)
			print("player position for : " + player.stats.playerName + " with role : "+ player.stats.role + " is " + String(pos))
			player.fieldPosition = pos
			player.global_position = pos
	match matchplace:
		matchPlace.AWAY:
			player.rotation_degrees = 180
		matchPlace.HOME:
			player.rotation_degrees = 0
			print("setting to kick-off player")
			if player.stats.role == "CF":
				player.global_position = positions.get("KICKOFF")
				player.kickOffPlayer = true
				player.rotation_degrees = 180
		_:
			player.rotation_degrees = 0
	
	print("player position has been set")
