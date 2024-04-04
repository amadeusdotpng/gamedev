extends Node3D

@export var physics_body: Node3D

func _physics_process(delta):
	global_position = physics_body.global_position.round() * Vector3(1,0,1)
