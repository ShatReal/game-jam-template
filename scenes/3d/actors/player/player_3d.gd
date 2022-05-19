extends Actor3D


func _physics_process(delta: float) -> void:
	var input := Vector3(
		Input.get_axis("move_left", "move_right"),
		0,
		Input.get_axis("move_up", "move_down")
	).normalized()
	input = input.rotated(Vector3.UP, $CameraArm.rotation.y)
	
	if can_accelerate:
		if input:
			velocity.x = move_toward(velocity.x, input.x * speed, acceleration * delta)
			velocity.z = move_toward(velocity.z, input.z * speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, acceleration * delta)
			velocity.z = move_toward(velocity.z, 0, acceleration * delta)
	else:
		velocity.x = input.x * speed
		velocity.z = input.z * speed
		
	velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_force
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		$MeshInstance.rotation.y = look_direction.angle()


func _process(_delta: float) -> void:
	$CameraArm.translation = translation
