extends Node

var basic_enemy = preload('res://scenes/enemies/basic_enemy.tscn')
var tank_enemy = preload('res://scenes/enemies/tank_enemy.tscn')
var range_enemy = preload('res://scenes/enemies/range_enemy.tscn')
var sniper_enemy = preload('res://scenes/enemies/sniper_enemy.tscn')
@onready var player = get_node('/root/world/player')
# Called when the node enters the scene tree for the first time.
var start = true
var spawn = false

func spawn_enemies(enemy, count, ranged):
	for i in range(count):
		var enemy_instance = enemy.instantiate()
		enemy_instance.set_target(player)
		if ranged:
			enemy_instance.set_noise_offset(randf_range(0,1000))
		var posx = [randf_range(player.position.x-1280-300,player.position.x-1280), 
				randf_range(player.position.x+1280, player.position.x+1280+300)].pick_random()
		var posy = [randf_range(player.position.y-720-300,player.position.y-720), 
				randf_range(player.position.y+720, player.position.y+720+300)].pick_random()
				
		enemy_instance.position = Vector2(posx, posy)
		add_sibling(enemy_instance)
		
func _ready():
	$spawner_timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start:
		spawn_enemies(basic_enemy, 20, false)
		spawn_enemies(tank_enemy, 7, false)
		spawn_enemies(range_enemy, 9, true)
		spawn_enemies(sniper_enemy, 5, true)
		start = false
		
	if spawn:
		spawn_enemies(basic_enemy, 10, false)
		spawn_enemies(tank_enemy, 5, false)
		spawn_enemies(range_enemy, 7, true)
		spawn_enemies(sniper_enemy, 4, true)
		spawn = false
		

func _on_spawner_timer_timeout():
	spawn = true
