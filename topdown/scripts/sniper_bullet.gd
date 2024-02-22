extends Area2D
var speed = 6400.0
var max_distance = 1200
var dmg = 150
var pierce = 10

var origin;
var direction;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _set_variables(_origin, _direction):
	position = _origin
	origin = _origin
	direction = _direction
	rotation = direction.angle()+PI/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	if pierce <= 0:
		queue_free()
		
	if abs(position.distance_squared_to(origin)) >= max_distance*max_distance:
		queue_free()
		
func _on_area_entered(area):
	if area.is_in_group('Enemy'):
		area.hp -= dmg
		pierce -= 1
