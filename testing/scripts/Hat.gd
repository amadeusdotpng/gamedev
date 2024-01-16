extends CharacterBody2D

const SPEED = 300.0

func get_input():
	return Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	
func _physics_process(delta):
	velocity = get_input() * SPEED
	move_and_slide()
