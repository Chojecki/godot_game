extends RigidBody2D

var reset_state = false
var moveVector: Vector2

func _ready():
	add_to_group("kickable")

func move_body(targetPos: Vector2):
	moveVector = targetPos;
	reset_state = true;
	
func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, moveVector)
		reset_state = false
