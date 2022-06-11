extends KinematicBody2D


export var speed := 200.0
export var can_accelerate := false
export var acceleration := 800.0
export var friction := 1_000.0
export var gravity := 1_200.0
export var jump_force := 800
export var max_fall_speed := 600.0

var velocity := Vector2()


func _physics_process(delta: float) -> void:
	var input := Input.get_axis("move_left", "move_right")
	if can_accelerate:
		if input == 0:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
		else:
			velocity.x = move_toward(velocity.x, input * speed, acceleration * delta)
	else:
		velocity.x = input * speed
	velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = -jump_force
	velocity = move_and_slide(velocity, Vector2.UP)
