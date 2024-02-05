extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	_animated_sprite.play("default")
func _on_body_entered(body):
	if body.is_in_group("Player"):
		var current_scene = get_tree().current_scene.scene_file_path
		var next_level_num = current_scene.to_int() + 1
		var next_level_scene = "res://scenes/level_" + str(next_level_num) + ".tscn"
		
		get_tree().change_scene_to_file(next_level_scene)
