extends Node2D

var playerscript = load("res://player/player.gd")

var kickOff:bool
var player:Player

func _ready():
	$"Kick-off".enable = false
	$Timer.wait_time = 2.0
	$Timer.start()
	player = get_parent()

func task_kickOff(task):
	var passTarget:Player = player.findPlayer("CMF")
	passBall(passTarget)
	WorldSpace.matchStart = true
	task.succeed()

func task_kickOffPlayer(task):
	if player.is_kick_off_player:
		task.succeed()
	else:
		task.failed()

func task_matchStart(task):
	if WorldSpace.matchStart == true:
		task.succeed()
	else:
		task.failed()

func task_teamPossession(task):
	if player.team_possession:
		task.succeed()
	else:
		task.failed()

func task_maintainPosition(task):
	var homePosUpdate:Vector2 = player.calculate_optimal_position()
	player.move(homePosUpdate)
	task.succeed()

func passBall(target:Player):
	var ball = player.ball
	player.pass_ball = true
	target.is_receiving_pass = true
	ball.moveBall(target.global_position, 0.3)

func task_canShoot(task):
	if player.canShoot():
		task.succeed()
	else:
		task.failed()

func task_goalAreaDetect(task):
	if WorldSpace.goalDetected :
		task.succeed()
	else:
		task.failed()

func task_receive_pass(task):
	if player.is_receiving_pass:
		task.succeed()
	else:
		task.failed()

func task_forwardPass(task):
	pass

func task_hasPassTarget(task):
	pass

func task_condPassBall(task):
	pass

func task_condCrossBall(task):
	pass

func task_progressBall(task):
	pass
#	var targetPoints = player.getPath(Vector2(625, 246))
#	print(targetPoints)

func task_condProgressBall(task):
	pass

func task_crossBall(task):
	pass

func task_hasSpace(task):
	pass

func task_canSupport(task):
	pass

func task_canMakeRun(task):
	pass

func task_HoldPosition(task):
	pass

func task_supportPlayer(task):
	pass

func task_isPressed(task):
	pass

func task_getFreeLocation(task):
	pass

func task_pressTarget(task):
	pass

func task_tackle(task):
	pass

func task_intercept(task):
	pass

func task_pressure(task):
	pass

func task_canslideTackle(task):
	pass

func task_canblockTackle(task):
	pass

func task_canpullTackle(task):
	pass

func task_slideTackle(task):
	pass

func task_blockTackle(task):
	pass

func task_pullTackle(task):
	pass

func task_closeOppPassTarget(task):
	pass

func task_withBall(task):
	if player.with_ball():
		task.succeed()
	else:
		task.failed()

func task_passBall(task):
	task.succeed()

func task_shootBall(task):
	task.succeed()

func task_move(task):
	pass


func _on_Timer_timeout():
	$"Kick-off".enable = true
