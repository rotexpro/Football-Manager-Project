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

var is_home_side:bool = false

func _ready():
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

	var field_mid_x = WorldSpace.CENTER_POSITION.x

	# ──────────────────────────────────────────────
	# HOME SIDE (Attacks right, ball to the right)
	# ──────────────────────────────────────────────
	if is_home_side:
		movetoposition.x = calculate_x_position(stats.role, center.x, fieldPosition, true)
		movetoposition.y = calculate_y_axis_adjustment(stats.role, center.y, fieldPosition, true)

	# ──────────────────────────────────────────────
	# AWAY SIDE (Attacks left, ball to the left)
	# ──────────────────────────────────────────────
	else:
		movetoposition.x = calculate_x_position(stats.role, center.x, fieldPosition, false)
		movetoposition.y = calculate_y_axis_adjustment(stats.role, center.y, fieldPosition, false)

	# ──────────────────────────────────────────────
	# Clamp player position to legal field bounds
	# ──────────────────────────────────────────────
	var mid = WorldSpace.CENTER_POSITION.x
	var buffer = 10

	movetoposition.y = clamp(movetoposition.y, WorldSpace.FIELD_HEIGHT_TOP, WorldSpace.FIELD_HEIGHT_BOTTOM)

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
	return field_pos.y

func look_at_ball():
	self.look_at(ball.global_position)







