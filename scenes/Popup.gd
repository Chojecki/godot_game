extends Popup

func _ready():
	# Create a new StyleBoxFlat
	var stylebox = StyleBoxFlat.new()
	
	# Set the background color
	stylebox.bg_color = Color(0.8, 0.8, 0.18, 1)  # Dark grey color
	
	# Set the border radius
	stylebox.set_corner_radius_all(50)  # 10 pixels radius for all corners
	
	# Apply the StyleBoxFlat to the Popup
	self.add_theme_stylebox_override("panel", stylebox)
	
	# Optionally, set padding for the popup
	add_theme_constant_override("margin_top", 10)
	add_theme_constant_override("margin_bottom", 10)
	add_theme_constant_override("margin_left", 10)
	add_theme_constant_override("margin_right", 10)
	
