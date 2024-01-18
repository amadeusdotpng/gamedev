extends CharacterBody2D

const SPEED = 300.0

func get_input():
	return Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	
func _physics_process(delta):
	var on_cat: bool = 835 <= position.x and position.x <= 875 and 120 <= position.y and position.y <= 170 
	var on_lain: bool = 385 <= position.x and position.x <= 425 and 195 <= position.y and position.y <= 235
	if on_cat or on_lain:
		get_node('../Confetti_Right').visible = true
		get_node('..//Confetti_Left').visible = true 
	else:
		get_node('../Confetti_Right').visible = false
		get_node('../Confetti_Left').visible = false
	velocity = get_input() * SPEED
	move_and_slide()
