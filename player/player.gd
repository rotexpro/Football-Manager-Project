extends KinematicBody2D

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

func _ready():
	if team.find(self):
		team.erase(self)
	AstarN = AstarNode.new(WorldSpace.grid)
	move_and_slide(velocity)

func _physics_process(delta):
	AstarN.normalizeNode(self)
	move_and_slide(velocity)

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

func calculate_optimal_position():
	var movetoposition: Vector2 = Vector2(420,111)
	var ball_pos: Vector2 = ball.global_position
	var center = ball_pos - WorldSpace.CENTER_POSITION
	var fieldWidth = Vector2(WorldSpace.FIELD_WIDTH, WorldSpace.FIELD_HEIGHT)
	var attackBias: float = tactics.attackBias
	var pressureBias: float = 1 - attackBias

	return movetoposition


#func _ready():
#	if Team.team == Team.TeamSide.HomeSide:
#		$"FOOTBALL_PLAYER SPRITE".modulate = Color(0, 0, 1)
#		homeside = true
#	elif Team.team == Team.TeamSide.AwaySide:
#		$"FOOTBALL_PLAYER SPRITE".modulate = Color(1, 0, 0)
#		awayside = false
#	hCBpos = Playerbase.hCBposition
#	hCDMpos = Playerbase.hCDMposition
#	aCBpos = Playerbase.aCBposition
#	aCDMpos = Playerbase.aCDMposition
#	pass
#
#
#func _physics_process(delta):
#	Playerbase.playerposition = self.global_position
#	pressureBias = Tactics.pressurebias
#	defenseBias = Tactics.defensebias
#	ballpos = Team.ballPos
#	LookAtBall()
#	playerteam()
##	trapball()
#	velocity = move_and_slide(velocity)
#
##..........................................................................
#
#
#
#func cal_move():
#	if self == Team.ClosestToBall:
#		var direction = ballpos
#		var self_pos = self.global_position
#		var dir = direction - self_pos 
#		velocity = dir * stats.speed * get_process_delta_time()
#	else:
#		velocity = Vector2.ZERO
#

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
