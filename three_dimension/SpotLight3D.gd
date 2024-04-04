extends SpotLight3D

@export var physics_body: Node3D

func _process(delta):
	position = physics_body.position * Vector3(1,0,1)
	position.y = 1000
