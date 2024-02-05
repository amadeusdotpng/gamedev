extends Area2D
var used = false
@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	_animated_sprite.play("default")
	var player = get_node("/root/level_4/Player")
	player.connect("died", respawn)

func respawn():
	visible = true
	used = false
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		if not used:
			body.ability_counter[1] += 1
			visible = false
