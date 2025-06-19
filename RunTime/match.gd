extends Node2D

var Ball

var Awaygoal = 0
var Homegoal = 0

var all_players:Array

var Astar:AstarNode
var ball = preload("res://MatchVariables/Scenes/Ball.tscn").instance()

# warning-ignore:unused_argument
func _physics_process(delta):
	WorldSpace.TEAM_POSSESSION = team_possession()

func team_possession():
	var possession = "HOME"
	if all_players.size() > 0:
		for player in all_players:
			if player.is_kick_off_player:
				possession = player.team_side
			if player.with_ball():
				possession = player.team_side
	return possession

func _ready():
	self.add_child(ball)
	ball.global_position = $"Control/pitch-scene".centerPos
	WorldSpace.CENTER_POSITION = $"Control/pitch-scene".centerPos
	WorldSpace.ball = ball
	
	var homeFieldpositions = $"Control/pitch-scene".homepositions()
	var awayFieldpositions = $"Control/pitch-scene".awaypositions()
	
	WorldSpace.AWAY_POSITIONS = awayFieldpositions
	WorldSpace.HOME_POSITIONS = homeFieldpositions
	
	WorldSpace.awayGoal = $"Control/pitch-scene".awayGoal
	
	var homeSquad = Database.clubTeam
	homeSquad = TeamData.createTeamData(homeSquad).startPlayers
	
	var oppSquad = Database.getTeam("TOMI")
	oppSquad = TeamData.createTeamData(oppSquad).startPlayers
	
	var grid = Grid.new($"Control/pitch-scene".gridPos.get("START"), $"Control/pitch-scene".gridPos.get("END"))
	grid.createGrid()
	WorldSpace.grid = grid.getAstarGrid()
	
	var homeTeam = Team($HomeTeam, homeFieldpositions, homeSquad, TeamCreator.matchPlace.HOME, "HOME")
	var awayTeam = Team($AwayTeam, awayFieldpositions, oppSquad, TeamCreator.matchPlace.AWAY, "AWAY")
	
	all_players.append_array(homeTeam)
	all_players.append_array(awayTeam)
	
	WorldSpace.FIELD_WIDTH = $"Control/pitch-scene".gridPos.get("END").x - $"Control/pitch-scene".gridPos.get("START").x
	WorldSpace.FIELD_HEIGHT = $"Control/pitch-scene".gridPos.get("END").y - $"Control/pitch-scene".gridPos.get("START").y
	
	WorldSpace.FIELD_WIDTH_START = $"Control/pitch-scene".gridPos.get("START").x
	WorldSpace.FIELD_WIDTH_END = $"Control/pitch-scene".gridPos.get("END").x
	
	WorldSpace.FIELD_HEIGHT_TOP = $"Control/pitch-scene".gridPos.get("START").y
	WorldSpace.FIELD_HEIGHT_BOTTOM = $"Control/pitch-scene".gridPos.get("END").y
	
	WorldSpace.GOAL_KEEPER_LINE_TOP = $"Control/pitch-scene".gridPos.get("GOAL_KEEPER_BOX_TOP").y
	WorldSpace.GOAL_KEEPER_LINE_BOTTOM = $"Control/pitch-scene".gridPos.get("GOAL_KEEPER_BOX_BOTTOM").y
	
	WorldSpace.MATCH_PLAYERS = all_players

func Team(holder:Node2D, fieldpositions, squad, matchplace, teamSide:String):
	var squadPlayers = TeamCreator.new().createTeam(fieldpositions, squad, matchplace, teamSide)
	for player in squadPlayers:
		holder.add_child(player)
		player.team = squadPlayers
		player.team_side = teamSide
		if teamSide == "HOME":
			player.is_home_side = true
		if player.team.find(self):
			player.team.erase(self)
	return squadPlayers














