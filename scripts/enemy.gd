extends CharacterBody2D

const SPEED = 60

var direction: Vector2 = Vector2.RIGHT

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	ray_cast_right.enabled = true
	ray_cast_left.enabled = true

func _physics_process(delta):
	# Check for collisions
	if direction == Vector2.RIGHT and ray_cast_right.is_colliding():
		direction = Vector2.LEFT
		animated_sprite.flip_h = true
	elif direction == Vector2.LEFT and ray_cast_left.is_colliding():
		direction = Vector2.RIGHT
		animated_sprite.flip_h = false

	# Move the character
	velocity = direction * SPEED
	move_and_slide()
