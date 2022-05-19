extends Actor2DSidescroller


func _physics_process(delta: float) -> void:
	var horizontal_input := Input.get_axis("move_left", "move_right")
	if can_accelerate:
		if horizontal_input:
			velocity.x = move_toward(velocity.x, horizontal_input * speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		velocity.x = horizontal_input * speed
	
	velocity.y += gravity * delta
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = -jump_force
		
	velocity = move_and_slide(velocity, Vector2.UP)
