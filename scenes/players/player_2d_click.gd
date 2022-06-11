extends KinematicBody2D


export var speed := 200.0
export var can_accelerate := false
export var acceleration := 800.0
export var friction := 1_000.0

var velocity := Vector2()
var target = null


func _physics_process(delta: float) -> void:
	if target:
		var dir := position.direction_to(target)
		if can_accelerate:
			velocity = velocity.move_toward(dir * speed, acceleration * delta)
		else:
			velocity = dir * speed
	elif can_accelerate:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity)
	if target and position.distance_to(target) <= speed * delta:
		target = null


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		target = get_global_mouse_position()
