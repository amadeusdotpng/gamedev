extends Area2D
const max_backup_speed = 200
const max_forward_speed = 230

var hp = 20
var speed = 180
var rot_speed = 270
var rooted = false

var target;
var shooting_distance = 600

@onready var projectile = preload('res://scenes/enemies/sniper_projectile.tscn')
var shoot_cooldown = true

@onready var noise = FastNoiseLite.new()
var noise_x = 0
var offset_x = 0

func _ready():
	pass

func set_target(_target):
	target = _target
	
func set_noise_offset(_offset_x):
	offset_x = _offset_x
	
func _on_projectile_timer_timeout():
	shoot_cooldown = true
	
func shoot():
	if shoot_cooldown:
		shoot_cooldown = false
		$ProjectileTimer.start()
		var projectile_instance = projectile.instantiate()
		var projectile_direction = (target.position-position).normalized()
		projectile_instance._set_variables(position, projectile_direction)
		add_sibling(projectile_instance)
		
func _process(delta):
	if hp <= 0:
		queue_free()
		
	if rooted:
		shoot()
		return
		
	var distance_to_target = position.distance_to(target.position)
	if not rooted and distance_to_target >= shooting_distance:
		position += position.direction_to(target.position) * speed * delta
		position += (position-target.position).orthogonal().normalized() * (rot_speed) * sign(noise.get_noise_1d(noise_x+offset_x)) * delta
		noise_x += 0.5
		
	if not rooted and distance_to_target <= shooting_distance:
		rooted = true



