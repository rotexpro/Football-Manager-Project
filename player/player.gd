extends KinematicBody2D

class_name Player

var velocity = Vector2.ZERO

var stats:Stats

var walk:bool
var sprint:bool

var AstarN:AstarNode

var field_position:Vector2 

var team:Array

var team_possession

var team_side: String

var ball = WorldSpace.ball

var is_kick_off_player:bool

var tactics = Tactics.new()

var is_home_side:bool = false

var look_at_ball:bool = true
var pass_ball:bool = false
var move_ball:bool = false

var is_receiving_pass: bool = false

func _ready():
	AstarN = AstarNode.new(WorldSpace.grid)
	move_and_slide(velocity)

func _physics_process(delta):
	AstarN.normalizeNode(self)
	if look_at_ball:
		look_at_ball()
	if with_ball() and !pass_ball and !move_ball:
		ball.global_position = $Contact/CollisionShape2D.global_position
	if (pass_ball or move_ball) and !with_ball():
		yield(get_tree().create_timer(3.0), "timeout")
		pass_ball = false
		move_ball = false
	if WorldSpace.TEAM_POSSESSION == team_side:
		team_possession = true
	else:
		team_possession = false

func findPlayer(role):
	var target
	for player in team:
		if player.stats.role == role:
			target = player
	return target

func move(position):
	if position != null:
		var dir = position - self.global_position
		velocity = dir * stats.speed * get_physics_process_delta_time()
		move_and_slide(velocity)

func moveWithPath(position):
	var path:Array = getPath(position)
	for step in path:
		var num = 0
		if num == 0:
			move(step.worldPosition)
		while self.global_position != step.worldPosition and num != 0:
			move(step.worldPosition)
		num = num + 1

func getPath(target:Vector2) -> Array:
	return AstarN.path(self.global_position, target)

func with_ball():
	if $Contact.ball:
		return true
	return false

func calculate_optimal_position() -> Vector2:
	var movetoposition: Vector2 = field_position
	var ball_pos: Vector2 = ball.global_position
	var ball_to_center_distance = ball_pos - WorldSpace.CENTER_POSITION

	if is_home_side:
		movetoposition.x = calculate_x_position(stats.role, ball_to_center_distance.x, field_position, true)
		movetoposition.y = calculate_y_axis_adjustment(stats.role, ball_to_center_distance.y, field_position, true)
	else:
		movetoposition.x = calculate_x_position(stats.role, ball_to_center_distance.x, field_position, false)
		movetoposition.y = calculate_y_axis_adjustment(stats.role, ball_to_center_distance.y, field_position, false)

	return movetoposition


func calculate_x_position(role: String, ball_to_center_distance_x: float, field_pos: Vector2, is_home_side: bool) -> float:
	var field_mid = WorldSpace.CENTER_POSITION.x
	
	# Do not adjust if the ball is too close to center
	if abs(ball_to_center_distance_x) <= 10.0:
		return field_pos.x

	var ball_x = field_mid + ball_to_center_distance_x
	var is_ball_ahead = (is_home_side and ball_x > field_mid) or (not is_home_side and ball_x < field_mid)

	# Calculate offset between player and ball
	var offset = ball_x - field_pos.x

	# Role-based pressure and fallback (defensive) bias
	var role_biases: Dictionary = {
		"CB": { "pressure": 0.2, "defense": 0.4 },
		"RB": { "pressure": 0.4, "defense": 0.5 },
		"LB": { "pressure": 0.4, "defense": 0.5 },
		"CDM": { "pressure": 0.5, "defense": 0.5 },
		"CMF": { "pressure": 0.7, "defense": 0.4 },
		"AMF": { "pressure": 0.9, "defense": 0.3 },
		"CF": { "pressure": 0.8, "defense": 0.3 },
		"LWF": { "pressure": 0.7, "defense": 0.4 },
		"RWF": { "pressure": 0.7, "defense": 0.4 },
		"LMF": { "pressure": 0.6, "defense": 0.5 },
		"RMF": { "pressure": 0.6, "defense": 0.5 },
		"GK": { "pressure": 0.05, "defense": 0.05 }
	}

	var bias = role_biases.get(role, { "pressure": 0.6, "defense": 0.4 })
	var active_bias = bias.pressure if is_ball_ahead else bias.defense

	var proposed_x = field_pos.x + offset * active_bias
	return clamp(proposed_x, WorldSpace.FIELD_WIDTH_START, WorldSpace.FIELD_WIDTH_END)


func calculate_y_axis_adjustment(role: String, ball_to_center_distance_y: float, field_pos: Vector2, is_home_side: bool) -> float:
	var keeper_line_top: float = WorldSpace.GOAL_KEEPER_LINE_TOP
	var keeper_line_bottom:float = WorldSpace.GOAL_KEEPER_LINE_BOTTOM
	var abs_dist := abs(ball_to_center_distance_y)
	
	if abs_dist < 10.0:
		return field_pos.y
	
	match role:
		"GK":
			var bias := 0.2
			var max_up := field_pos.y - keeper_line_top
			var max_down := keeper_line_bottom - field_pos.y
			var delta := clamp(ball_to_center_distance_y * bias, -max_up, max_down)
			return field_pos.y + delta
		"CDM", "CMF", "AMF", "CF":
			var bias_map := {"CDM": 0.5, "CMF": 0.2, "AMF": 1.0, "CF": 0.8}
			var bias:float = bias_map.get(role, 0.6)
			return field_pos.y + ball_to_center_distance_y * bias
		"RWF", "LWF":
			return field_pos.y + ball_to_center_distance_y * 0.1
	return clamp(field_pos.y, WorldSpace.FIELD_HEIGHT_TOP, WorldSpace.FIELD_HEIGHT_BOTTOM)

func look_at_ball():
	self.look_at(ball.global_position)







