extends CharacterBody2D


@export var accel = 2360
@export var down_accel = 1200
@export var jump_velocity = 545
@export var dash_speed = 1800
@export var backdash_speed = 1400
@export var max_speed = 950
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dash_velocity = Vector2i(0,0)

@export var max_jump_count = 1
@export var max_dash_count = 1
@export var max_backdash_count = 1

enum ABILITY {JUMP, DASH, BACKDASH}
var ability_counter = {
	ABILITY.JUMP: max_jump_count,
	ABILITY.DASH: max_dash_count,
	ABILITY.BACKDASH: max_backdash_count,
}

@onready var _animated_sprite = $AnimatedSprite2D
signal died;
var last_direction = 1
func get_collision_info():
	var tilemap = get_node('../TileMap')
	var tile_collision_normal = Dictionary()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collision_normal = collision.get_normal()
		
		var cell = tilemap.local_to_map(collision.get_position() - collision_normal) 
		print(cell)
		var tile_id = tilemap.get_cell_source_id(0, cell)
		tile_collision_normal[tile_id] = collision_normal
	return tile_collision_normal
	
func hmovement_run(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x += direction * accel * delta
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
func vmovement_grav(delta, collision_info):
	var wall_jump = 1 in collision_info and collision_info[1].x != 0
	if not is_on_floor():
		if velocity.y >= 0 and wall_jump:
			ability_counter[ABILITY.JUMP] = max_jump_count
			ability_counter[ABILITY.DASH] = max_dash_count
			velocity.y *= 0.95
			velocity.y = max(100, velocity.y)
		elif wall_jump:
			ability_counter[ABILITY.JUMP] = max_jump_count
			ability_counter[ABILITY.DASH] = max_dash_count
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta
			
func vmovement_jump(collision_info):
	var collision_normal = Vector2i(0,1);
	for tile_id in collision_info:
		var normal = collision_info[tile_id]
		if normal.x != 0:
			collision_normal = normal
			break
			
	var wall_jump = 1 in collision_info and collision_normal.x != 0
	if Input.is_action_just_pressed("ui_up") and ability_counter[ABILITY.JUMP] > 0:
		velocity.y = -jump_velocity
		dash_velocity = Vector2i(0,0)
		if wall_jump:
			velocity.x = 450 * collision_normal.x
			ability_counter[ABILITY.JUMP] -= 1
		else:
			ability_counter[ABILITY.JUMP] -= 1
			
func movement_dash():
	if (Input.is_action_just_pressed("mouse_left") or Input.is_action_just_pressed("shift")) and ability_counter[ABILITY.DASH] > 0:
		velocity = Vector2i(clamp(velocity.x, -300, 300),clamp(velocity.y, -100, 100))
		dash_velocity = Vector2(last_direction * dash_speed, 0)
		ability_counter[ABILITY.DASH] -= 1
		if ability_counter[ABILITY.JUMP] == 0:
			ability_counter[ABILITY.JUMP] = 1
			
	elif Input.is_action_just_pressed("mouse_right") and ability_counter[ABILITY.BACKDASH] > 0:
		velocity = Vector2i(clamp(velocity.x, -300, 300),clamp(velocity.y, -100, 100))
		dash_velocity = -get_local_mouse_position().normalized() * backdash_speed
		ability_counter[ABILITY.BACKDASH] -= 1
		if ability_counter[ABILITY.JUMP] == 0:
			ability_counter[ABILITY.JUMP] = 1
	
func check_death(collision_info):
	if 2 in collision_info:
		var spawn = get_tree().root.get_child(0).get_meta("Spawn")
		position = spawn
		velocity = Vector2i(0,0)
		emit_signal("died")

func handle_animations():
	if Input.is_action_just_pressed("mouse_left") or Input.is_action_just_pressed("mouse_right"):
		_animated_sprite.set_animation("air")
		if dash_velocity.x > 0:
			last_direction = 1
			_animated_sprite.frame = 0
		elif dash_velocity.x < 0:
			last_direction = -1
			_animated_sprite.frame = 1
	elif dash_velocity.length() < 150:
		if Input.is_action_pressed("ui_right"):
			last_direction = 1
			if is_on_floor():
				_animated_sprite.play("right_run")
			else:
				_animated_sprite.set_animation("air")
				_animated_sprite.frame = 0
		elif Input.is_action_pressed("ui_left"):
			last_direction = -1
			if is_on_floor():
				_animated_sprite.play("left_run")
			else:
				_animated_sprite.set_animation("air")
				_animated_sprite.frame = 1
		else:
			if is_on_floor():
				if last_direction == 1:
					_animated_sprite.set_animation("right_run")
					_animated_sprite.frame = 0
				elif last_direction == -1:
					_animated_sprite.set_animation("left_run")
					_animated_sprite.frame = 0
			else:
				_animated_sprite.set_animation("air")
				if last_direction == 1:
					_animated_sprite.frame = 0
				elif last_direction == -1:
					_animated_sprite.frame = 1
		
func _physics_process(delta):
	var collision_info = get_collision_info()
	check_death(collision_info)
	
	if is_on_floor():
		ability_counter[ABILITY.JUMP] = max_jump_count
		ability_counter[ABILITY.DASH] = max_dash_count
		ability_counter[ABILITY.BACKDASH] = max_backdash_count
		
	movement_dash()
	
	if dash_velocity.length() < 150:
		hmovement_run(delta)
		vmovement_grav(delta, collision_info)
	vmovement_jump(collision_info)	
	
	if Input.is_action_pressed("ui_down"):
		velocity.y += down_accel * delta
		
	dash_velocity *= 0.90
	position += dash_velocity * delta
	if is_on_floor() and not (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") ):
		velocity.x *= 0.875
	else:
		velocity.x *= 0.925
	velocity.y += 1
	velocity.y = clamp(velocity.y, -1200, 1200)
	
	handle_animations()
	
	move_and_slide()
