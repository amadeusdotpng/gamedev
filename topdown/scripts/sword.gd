extends Area2D
var rot_speed = deg_to_rad(1400)
var max_rot = deg_to_rad(140.0)
var dmg = 75
var rot_origin;
var local_rot = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _set_variables(_rot):
	rotation = _rot
	rot_origin = _rot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation -= rot_speed * delta
	local_rot += rot_speed * delta
	if local_rot >= max_rot:
		queue_free()


func _on_area_entered(area):
	if area.is_in_group('Enemy'):
		area.hp -= dmg
