extends RigidBody2D

@export var destructable: bool = true

var sprite: Sprite2D

var health = 2

# For region switch - stone specific
const tileItem = 16
var sprite_size = Vector2(tileItem * 8, tileItem * 8)
var sprite_start = Vector2(0, 0)
var sprite_position = Vector2()

var reset_state = false
var moveVector: Vector2

func _ready():
	sprite = get_node("Sprite2D")

func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, moveVector)
		reset_state = false

func move_body(targetPos: Vector2):
	moveVector = targetPos;
	reset_state = true;


func _setup_sprite():
	if sprite:
		sprite_position = sprite_start
		sprite_position.x = sprite_start.x + sprite_size.x
		sprite.region_rect.position = sprite_position
	
func get_damage(damage: int):
	if health > 0:
		_setup_sprite()
		health -= damage
	else:
		queue_free()
