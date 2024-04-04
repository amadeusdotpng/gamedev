extends CharacterBody3D


var SPEED = 25
const JUMP_VELOCITY = 4.5
const GRAV = 1

var mouse_captured = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * 0.001
		rotation.x = clamp(rotation.x - event.relative.y * 0.001, -PI/2, PI/2)
		
	if Input.is_action_just_pressed("ToggleMouseCaptureMode"):
		if mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_captured = not mouse_captured
	
	if Input.is_action_just_pressed("HideInstructions"):
		$UI/Instructions.visible = not $UI/Instructions.visible
			
func movement(delta):
	if not is_on_floor():
		velocity.y -= GRAV * delta /(basis.z.length()*100)
	
	if Input.is_action_just_pressed("Boost"):
		$AudioStreamPlayer.play()
		velocity -= basis.z * 75
	velocity -= basis.z * SPEED * delta

	velocity.x *= 0.995
	velocity.z *= 0.995
	
	
	#var sprint = 2 if Input.is_action_pressed("Sprint") else 1
		#
	#if Input.is_action_pressed("Jump"):
		#velocity.y = JUMP_VELOCITY * sprint
	#elif Input.is_action_pressed("Crouch"):
		#velocity.y = -JUMP_VELOCITY * sprint
	#else:
		#velocity.y = move_toward(velocity.y, 0, SPEED)
	#
	#var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#var horizontal_direction = Vector2(direction.x, direction.z).normalized()
		#velocity.x = horizontal_direction.x * SPEED * sprint
		#velocity.z = horizontal_direction.y * SPEED * sprint
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)		
		
func _physics_process(delta):
	movement(delta)
	move_and_slide()
