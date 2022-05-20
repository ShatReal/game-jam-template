extends KinematicBody2D


export var speed: float
export var can_accelerate: bool
export var acceleration: float
export var friction: float
export var apply_gravity: bool
export var gravity: float
export var jump_force: float


var velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var input := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	if can_accelerate:
		if input.x:
			velocity.x = move_toward(velocity.x, input.x * speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		velocity.x = input.x * speed
	if apply_gravity:
		velocity.y += gravity * delta
		if input.y < 0 and is_on_floor():
			velocity.y = -jump_force
	else:
		if can_accelerate:
			if input.y:
				velocity.y = move_toward(velocity.y, input.y * speed, acceleration * delta)
			else:
				velocity.y = move_toward(velocity.y, 0, friction * delta)
		else:
			velocity.y = input.y * speed
	velocity = move_and_slide(velocity, Vector2.UP)
