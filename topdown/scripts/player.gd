extends Area2D

var hp = 100
var dead = false

enum Weapon {SWORD=0, SHURIKEN=1, PISTOL=2, SNIPER=3}
var cooldowns = {
	Weapon.SWORD: true,
	Weapon.SHURIKEN: true,
	Weapon.PISTOL: true,
	Weapon.SNIPER: true
}
var dash_cooldown = 2

@onready var sword = preload("res://scenes/weapons/sword.tscn")
@onready var shuriken = preload("res://scenes/weapons/shuriken.tscn")
@onready var bullet = preload("res://scenes/weapons/bullet.tscn")
@onready var sniper_bullet = preload("res://scenes/weapons/sniper_bullet.tscn")

@export var speed = 270.0
#var to_position = Vector2(0,0);
var current_weapon = Weapon.SWORD
func _on_dash_timer_timeout():
	dash_cooldown = min(dash_cooldown+1, 2)
	set_dash_bar()
	
func _on_sword_timer_timeout():
	cooldowns[Weapon.SWORD] = true
	
func _on_shuriken_timer_timeout():
	cooldowns[Weapon.SHURIKEN] = true
	
func _on_pistol_timer_timeout():
	cooldowns[Weapon.PISTOL] = true
	
func _on_sniper_timer_timeout():
	cooldowns[Weapon.SNIPER] = true
	
func _on_regen_timer_timeout():
	hp = min(hp+25, 100)
	
func movement(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	position += direction * speed * delta
	position = position.clamp(Vector2(-3000, -3000), Vector2(3000, 3000))
	print(position)
	
func dash():
	if Input.is_action_just_pressed("dash") and dash_cooldown > 0:
		if dash_cooldown == 2:
			$DashTimer.start()
		dash_cooldown -= 1
		var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
		position += direction * 500
		set_dash_bar()

func set_all_weapons_semitransparent():
	$UI/KnightMonkey.modulate.a = 75.0/255
	$UI/NinjaMonkey.modulate.a = 75.0/255
	$UI/DartMonkey.modulate.a = 75.0/255
	$UI/SniperMonkey.modulate.a = 75.0/255
	
func switch_weapon():
	if Input.is_key_pressed(KEY_1):
		current_weapon = Weapon.SWORD
		$Sprite2D.set_texture(load("res://assets/swordmonkey.tres"))
		set_all_weapons_semitransparent()
		$UI/KnightMonkey.modulate.a = 1
	elif Input.is_key_pressed(KEY_2):
		current_weapon = Weapon.SHURIKEN
		$Sprite2D.set_texture(load("res://assets/shurikenmonkey.tres"))
		set_all_weapons_semitransparent()
		$UI/NinjaMonkey.modulate.a = 1
	elif Input.is_key_pressed(KEY_3):
		current_weapon = Weapon.PISTOL
		$Sprite2D.set_texture(load("res://assets/gunmonkey.tres"))
		set_all_weapons_semitransparent()
		$UI/DartMonkey.modulate.a = 1
	elif Input.is_key_pressed(KEY_4):
		current_weapon = Weapon.SNIPER
		$Sprite2D.set_texture(load("res://assets/snipermonkey.tres"))
		set_all_weapons_semitransparent()
		$UI/SniperMonkey.modulate.a = 1
		
func shoot_sword():
	if Input.is_action_pressed("left_mouse") and cooldowns[Weapon.SWORD]:
		cooldowns[Weapon.SWORD] = false
		$SwordTimer.start()
		var sword_instance = sword.instantiate()
		var rot = deg_to_rad(72.5)+PI/2
		sword_instance._set_variables(rot)
		add_child(sword_instance)

		
func shoot_shuriken():
	if Input.is_action_pressed("left_mouse") and cooldowns[Weapon.SHURIKEN]:
		cooldowns[Weapon.SHURIKEN] = false
		$ShurikenTimer.start()
		var shuriken_instance_left = shuriken.instantiate()
		var shuriken_instance_mid = shuriken.instantiate()
		var shuriken_instance_right = shuriken.instantiate()
		var shuriken_direction = (get_global_mouse_position()-position).normalized()
		var offset_angle = deg_to_rad(20)
		shuriken_instance_left._set_variables(position, shuriken_direction.rotated(-offset_angle))
		shuriken_instance_mid._set_variables(position, shuriken_direction)
		shuriken_instance_right._set_variables(position, shuriken_direction.rotated(offset_angle))
		add_sibling(shuriken_instance_left)
		add_sibling(shuriken_instance_mid)
		add_sibling(shuriken_instance_right)
		
func shoot_pistol():
	if Input.is_action_pressed("left_mouse") and cooldowns[Weapon.PISTOL]:
		cooldowns[Weapon.PISTOL] = false
		$PistolTimer.start()
		var bullet_instance = bullet.instantiate()
		var bullet_direction = (get_global_mouse_position()-position).normalized()
		bullet_instance._set_variables(position, bullet_direction)
		add_sibling(bullet_instance)
		
func shoot_sniper():
	if Input.is_action_pressed("left_mouse") and cooldowns[Weapon.SNIPER]:
		cooldowns[Weapon.SNIPER] = false
		$SniperTimer.start()
		var sniper_bullet_instance = sniper_bullet.instantiate()
		var sniper_bullet_direction = (get_global_mouse_position()-position).normalized()
		sniper_bullet_instance._set_variables(position, sniper_bullet_direction)
		add_sibling(sniper_bullet_instance)
		
func set_health_bar():
	$UI/HealthLabel/HealthBar.value = hp
	
func set_dash_bar():
	$UI/DashLabel/DashBar.value = dash_cooldown
	
func _ready():
	set_health_bar()
	set_dash_bar()
	
	
func _physics_process(delta):
	if dead:
		return
		
	movement(delta)
	dash()
	if dash_cooldown >= 2:
		$UI/DashLabel/DashTimerBar.value = 0
	else:
		$UI/DashLabel/DashTimerBar.value = $DashTimer.wait_time - $DashTimer.time_left
	rotation = (get_global_mouse_position()-position).angle()
	
	switch_weapon()
	if current_weapon == Weapon.SWORD:
		shoot_sword()
	elif current_weapon == Weapon.SHURIKEN:
		shoot_shuriken()
	elif current_weapon == Weapon.PISTOL:
		shoot_pistol()
	elif current_weapon == Weapon.SNIPER:
		shoot_sniper()
		
	if hp <= 0:
		dead = true

func _on_player_hitbox_area_entered(area):
	if area.is_in_group("Enemy"):
		hp -= 10
		
	if area.is_in_group("Enemy_Projectile"):		
		hp -= area.dmg
		
	$RegenTimer.start()
	set_health_bar()






