extends Control

func _ready():
	# Adjust the Control node to cover the right side of the screen
	anchor_left = 0.5
	anchor_right = 1
	offset_left = 0
	offset_right = 0

	# Ensure the Control node is receiving input events
	set_process_input(true)

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		# Check if the touch is within the right side of the screen
		var viewport_width = get_viewport().size.x
		if event.position.x >= viewport_width * 0.5:
			_on_right_side_touched()

func _on_right_side_touched():
	Input.action_press("grab")
	Input.action_release("grab")
