extends KinematicBody2D

class_name Player

var velocity = Vector2.ZERO

var stats:Stats

var walk:bool
var sprint:bool

var AstarN:AstarNode

var fieldPosition:Vector2 

var team:Array
var teamPossession

var teamSide

var ball = WorldSpace.ball

var kickOffPlayer:bool

var withBall:bool = true

var tactics = Tactics.new()

var isHomeSide:bool = false

func _ready():
	if team.find(self):
		team.erase(self)
	if teamSide == "HOME":
		isHomeSide = true
	AstarN = AstarNode.new(WorldSpace.grid)
	move_and_slide(velocity)

func _physics_process(delta):
	AstarN.normalizeNode(self)
	

func findPlayer(role):
	var target
	for player in team:
		if player.stats.role == role:
			target = player
	return target.global_position

func move(position):
	if position != null:
		var dir = position - self.global_position
		velocity = dir * stats.speed * get_physics_process_delta_time()
		move_and_slide(velocity)

func moveWithPath(position):
	var path:Array = getPath(position)
	for step in path:
		move(step.worldPosition)

func getPath(target:Vector2) -> Array:
	return AstarN.path(self.global_position, target)

func withBall():
	if $Contact.ball:
		return true
	return false

func calculate_optimal_position() -> Vector2:
	var movetoposition: Vector2 = fieldPosition
	var ball_pos: Vector2 = ball.global_position
	var center = ball_pos - WorldSpace.CENTER_POSITION
	var attackBias: float = 2
	var pressureBias: float = 1.0 - attackBias
	var defenseLine: float = 3

	var maxBallX = 308.0
	var maxBallYUp = 73.0
	var maxBallYDown = 302.0

	if isHomeSide:
		# Home side: attacking right
		if center.x >= 10:
			var base_move = center.x * ((pressureBias + defenseLine) / 2)
			movetoposition.x = fieldPosition.x + base_move * get_role_line_bias(stats.role)
		elif center.x <= -10:
			movetoposition.x = calculate_defensive_x(stats.role, center.x, fieldPosition, true)

		movetoposition.y = calculate_y_axis_adjustment(stats.role, center.y, fieldPosition, true)

	else:
		# Away side: attacking left
		if center.x <= -10:
			var base_move = -center.x * ((pressureBias + defenseLine) / 2)
			movetoposition.x = fieldPosition.x - base_move * get_role_line_bias(stats.role)
		elif center.x >= 10:
			movetoposition.x = calculate_defensive_x(stats.role, center.x, fieldPosition, false)

		movetoposition.y = calculate_y_axis_adjustment(stats.role, center.y, fieldPosition, false)

	return movetoposition


func get_role_line_bias(role: String) -> float:
	match role:
		"GK": return 0.3
		"CB": return 0.6
		"CDM": return 0.5
		"CMF": return 0.7
		"AMF": return 0.3
		"CF": return 0.4
		_ : return 1.0


func calculate_defensive_x(role: String, center_x: float, field_pos: Vector2, isHomeSide: bool) -> float:
	var base_shift = abs(center_x / 308.0)
	var pos_ref = WorldSpace.HOME_POSITIONS if isHomeSide else WorldSpace.AWAY_POSITIONS

	match role:
		"CMF", "AMF":
			return field_pos.x + base_shift * ((pos_ref.CDM.x + (10 if isHomeSide else -10)) - field_pos.x)
		"CB", "RB", "LB", "CDM", "GK":
			return field_pos.x
		"LWF", "RWF", "LMF", "RMF":
			return field_pos.x + base_shift * ((pos_ref.CB.x + (50 if isHomeSide else -50) - field_pos.x) * 0.7)
		"CF":
			return field_pos.x + base_shift * ((pos_ref.CB.x + (50 if isHomeSide else -50) - field_pos.x) * 0.3)
		_:
			return field_pos.x


func calculate_y_axis_adjustment(role: String, center_y: float, field_pos: Vector2, isHomeSide: bool) -> float:
	var mpUP = Vector2(125.127, 99.781)
	var mpDOWN = Vector2(125.127, 277.07)
	var markUp = field_pos.y - 73
	var markDown = field_pos.y - 302

	if role == "GK":
		if center_y <= -10:
			return field_pos.y - ((1 - ((center_y + markUp) / markUp)) * (field_pos.y - mpUP.y) * 0.85)
		elif center_y >= 10:
			return field_pos.y - ((1 - ((center_y + markDown) / markDown)) * (field_pos.y - mpDOWN.y) * 0.85)

	elif role in ["CDM", "CMF", "AMF", "CF"]:
		var scale = 0.6
		match role:
			"CDM": scale = 0.5
			"CMF": scale = 0.6
			"AMF": scale = 1.0
			"CF": scale = 0.8

		if center_y >= 10:
			return field_pos.y + ((mpDOWN.y - field_pos.y) * scale)
		elif center_y <= -10:
			return field_pos.y - ((1 - ((center_y + markUp) / markUp)) * (field_pos.y - mpUP.y) * scale)

	elif role in ["RWF", "LWF"]:
		if center_y <= -10:
			return field_pos.y - ((1 - ((center_y + markUp) / markUp)) * (field_pos.y - (mpDOWN.y + 20)))

	return field_pos.y

#func withBall():
#	if $Contact.ball:
#		return true
#	elif !$Ballholder.ball:
#		yield(get_tree().create_timer(0.4), "time_out")
#		if $Ballholder.ball:
#			return true
#	return false
#
#func trapball():
#	var trapball
#	if $Ballholder.ball:
#		if !trapball :
#			ballResource.trapball(self.position)
#	else:
#		trapball = false
#
#func LookAtBall():
#	self.look_at(ballpos)
#
#
#func playerteam():
#	if Team.team == Team.TeamSide.HomeSide:
#		homeside = true
#		awayside = false
#	elif Team.team == Team.TeamSide.HomeSide:
#		homeside = false
#		awayside = true
#
#func Detectplayer():
#	if $Detectplayer.player:
#		return true
#	return false
#
#func detectsideline():
#	if $"detect_left-sideline".sideline:
#		leftsideline = true
#	elif $"detect_right-sideline".sideline:
#		rightsideline = true
#	elif $"detect_forward-sideline".sideline:
#		forwardsideline = true
#	else:
#		forwardsideline = false
#		leftsideline = false
#		rightsideline = false
#		pass
#
#func calculate_Move_Position():
#	# this function gives the formation location each player is required to move to 
#	var centerpos = WorldSpace.centerpos
#	var defenseLine = Tactics.defenseLine
#	var movetoposition:Vector2 = fieldPosition
#	var differentiator = ballpos - centerpos # difference btw the center pos and ball pos
#	var Maxballx = 308 # max distance for ball position on the x axis
#	var Maxballyup = 73
#	var Maxballydown = 302
#
#	# pressure..................................................................
#	if homeside:
#		# x-axis................................................................
#		if differentiator.x >= 10 :
#			movetoposition.x = (differentiator.x * ((pressureBias + defenseLine)/2)) + fieldPosition.x
#			if stats.role == "GK":
#				movetoposition.x = ((differentiator.x * ((pressureBias + defenseLine)/2)) + fieldPosition.x) * linebiasGK
#				if movetoposition.x <= fieldPosition.x:
#					movetoposition.x = fieldPosition.x
#					movetoposition.y = fieldPosition.y
#			elif stats.role == "CB":
#				movetoposition.x = ((differentiator.x * ((pressureBias + defenseLine)/2)) + fieldPosition.x) * linebiasCB
#				if movetoposition.x <= fieldPosition.x:
#					movetoposition.x = fieldPosition.x
#			elif stats.role == "CDM":
#				movetoposition.x = ((differentiator.x * ((pressureBias + defenseLine)/2)) + fieldPosition.x) * linebiasCDM
#				if movetoposition.x <= fieldPosition.x:
#					movetoposition.x = fieldPosition.x
#			elif stats.role == "CMF":
#				movetoposition.x = ((differentiator.x * ((pressureBias + defenseLine)/2)) + fieldPosition.x) * linebiasCMF
#				if movetoposition.x <= fieldPosition.x:
#					movetoposition.x = fieldPosition.x
#
#		# defense...............................................................
#
#		elif differentiator.x <= -10:
#			if stats.role == "CMF" or stats.role == "AMF":
#				movetoposition.x = (-(differentiator.x/ Maxballx) * ((hCDMpos.x + 10) - fieldPosition.x)) + fieldPosition.x
#			elif stats.role == "CB" or stats.role == "RB" or stats.role == "LB" or stats.role == "CDM" or stats.role == "GK":
#				movetoposition.x = fieldPosition.x
#			elif stats.role == "LWF" or stats.role == "RWF" or stats.role == "LMF" or stats.role == "RMF":
#				movetoposition.x = (-(differentiator.x/ Maxballx) * ((hCBpos.x  + 50) - fieldPosition.x) * 0.7) + fieldPosition.x 
#			elif stats.role == "CF":
#				movetoposition.x = (-(differentiator.x/ Maxballx) * ((hCBpos.x  + 50) - fieldPosition.x) * 0.3) + fieldPosition.x
#
#		var mpUP = Vector2(125.127,99.781)
#		var mpDOWN = Vector2(125.127,277.07)
#
#		var marklineupy = (fieldPosition.y - Maxballyup) # the line for y axis up
#		var marklinedowny = (fieldPosition.y - Maxballydown)
#
#		# y-axis................................................................
#		if stats.role == "GK" :
#			#up.................................................................
#			if differentiator.y <= -10:
#				movetoposition.y = fieldPosition.y - ((1 - ((differentiator.y + marklineupy)/marklineupy)) * (fieldPosition.y - mpUP.y) * 0.85)
#			# down..............................................................
#			elif differentiator.y >= 10:
#				movetoposition.y = fieldPosition.y - ((1 - ((differentiator.y + marklinedowny)/marklinedowny)) * (fieldPosition.y - mpDOWN.y) * 0.85)
##				print((1 - ((differentiator.y + marklinedowny)/marklinedowny)))
#
#		elif stats.role == "CMF" :
#			if differentiator.y >= 10:
#				movetoposition.y = ((((mpDOWN.y - fieldPosition.y)/differentiator.y) * differentiator.y ) * 0.6) + fieldPosition.y
#			elif differentiator.y <= -10:
#				movetoposition.y = fieldPosition.y - ((1 - ((differentiator.y + marklineupy)/marklineupy)) * (fieldPosition.y - mpUP.y) * 0.7)
#
#		elif stats.role == "CDM" :
#			if differentiator.y >= 10:
#				movetoposition.y = ((((mpDOWN.y - fieldPosition.y)/differentiator.y) * differentiator.y ) * 0.6) + fieldPosition.y
#			elif differentiator.y <= -10:
#				movetoposition.y = fieldPosition.y - ((1 - ((differentiator.y + marklineupy)/marklineupy) ) * (fieldPosition.y - mpUP.y) * 0.5)
#
#		elif  stats.role == "AMF":
#			if differentiator.y >= 10:
#				movetoposition.y = ((((mpDOWN.y - fieldPosition.y)/differentiator.y) * differentiator.y ) * 0.3) + fieldPosition.y
#			elif differentiator.y <= -10:
#				movetoposition.y = fieldPosition.y - ((1 - ((differentiator.y + marklineupy)/marklineupy)) * (fieldPosition.y - mpUP.y))
#
#		elif stats.role == "CF":
#			if differentiator.y >= 10:
#				movetoposition.y = ((((mpDOWN.y - fieldPosition.y)/differentiator.y) * differentiator.y ) * 0.8) + fieldPosition.y
#			elif differentiator.y <= -10:
#				movetoposition.y = fieldPosition.y - ((1 - ((differentiator.y + marklineupy)/marklineupy)) * (fieldPosition.y - mpUP.y) * 0.6)
#
#		elif stats.role == "RWF":
#			if differentiator.y <= -10:
#				movetoposition.y = fieldPosition.y - ((1 - ((differentiator.y + marklineupy)/marklineupy)) * (fieldPosition.y - (mpDOWN.y + 20)))
#
#		elif stats.role =="LWF":
#			if differentiator.y <= -10:
#				movetoposition.y = ((((mpUP.y - fieldPosition.y)/differentiator.y) * differentiator.y) * 0.3) + fieldPosition.y
#
#	#away side
#	return movetoposition
#
#func ballpassed(passer,object):
#	if self == passer:
#		ballholder = false
#		pass
#	elif self == object:
#		ballholder = true
#		pass
#	pass
#
#
#
#
#
#
#
