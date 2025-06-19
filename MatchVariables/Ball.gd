extends RigidBody2D


func moveBall(target_position: Vector2, power: float = 1.0, max_power_speed: float = 150.0, accuracy: float = 0.0, curve: int = 0):
	var direction = (target_position - global_position).normalized()
	var speed = clamp(power, 0.0, 1.0) * max_power_speed
	var velocity = direction * speed

	# Optional curve
	if curve != 0:
		var perp = Vector2(-direction.y, direction.x)
		velocity += perp * curve

	# Optional accuracy
	if accuracy > 0.0:
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		var noise = Vector2(rng.randf_range(-accuracy, accuracy), rng.randf_range(-accuracy, accuracy))
		velocity += noise

	linear_velocity = velocity




