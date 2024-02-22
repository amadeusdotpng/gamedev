extends Area2D
var hp = 100
var speed = 280

var target;

func _ready():
	pass

func set_target(_target):
	target = _target

func _process(delta):
	if hp <= 0:
		queue_free()
	position += position.direction_to(target.position) * speed * delta
