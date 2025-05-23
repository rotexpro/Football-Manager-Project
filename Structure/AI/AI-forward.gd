extends Node2D

var playerscript = load("res://player/player.gd")

var kickOff:bool

func _ready():
	$"Kick-off".enable = false
	$Timer.wait_time = 2.0
	$Timer.start()

func task_kickOff(task):
	var player = get_parent()
	var passTarget = player.findPlayer("CMF")
	while (!get_parent().withBall):
		get_parent().move(WorldSpace.ball.global_position)
	passBall(passTarget)
	WorldSpace.matchStart = true
	task.succeed()

func task_kickOffPlayer(task):
	if get_parent().kickOffPlayer:
		task.succeed()
	else:
		task.failed()

func task_matchStart(task):
	if WorldSpace.matchStart == true:
		task.succeed()
	else:
		task.failed()

func task_teamPossession(task):
	if get_parent().teamPossession:
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
	var targetPoints = get_parent().getPath(Vector2(625, 246))
	print(targetPoints)

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
	var player = get_parent()
	if player.withBall():
		task.succeed()
	else:
		task.failed()


func task_passBall(task):
	task.succeed()

func task_shootBall(task):
	task.succeed()

func task_canShoot(task):
	if get_parent().canShoot():
		task.succeed()
	else:
		task.failed()

func task_goalAreaDetect(task):
	if WorldSpace.goalDetected :
		task.succeed()
	else:
		task.failed()

func task_move(task):
	pass

func task_maintainPosition(task):
#	var homePosUpdate = get_parent().calculate_optimal_position()
#	var targetPoints = get_parent().getPath(Vector2(457, 261))
	get_parent().moveWithPath(Vector2(457, 261))
	task.succeed()

func passBall(target):
	var player = get_parent()
	var ball = player.ball
	ball.moveBall(target,10)


func _on_Timer_timeout():
	$"Kick-off".enable = true
