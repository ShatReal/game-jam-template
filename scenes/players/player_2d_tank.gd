extends KinematicBody2D


export var speed := 200.0
export var can_accelerate := false
export var acceleration := 800.0
export var friction := 1_000.0
export var rotation_speed := 5.0

var velocity := Vector2()


func _physics_process(delta: float) -> void:
	var fb := Input.get_axis("move_down", "move_up")
	var rot := Input.get_axis("move_left", "move_right")
	if can_accelerate:
		if fb == 0:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		else:
			velocity = velocity.move_toward(Vector2.RIGHT.rotated(rotation) * fb * speed, acceleration * delta)
	else:
		velocity = Vector2.RIGHT.rotated(rotation) * fb * speed
	rotation += rotation_speed * rot * delta
	velocity = move_and_slide(velocity)
