extends CharacterBody2D

@export var force = 1000

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var grabbed_object:RigidBody2D = null
var is_grabbing = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var grab_area = $Area2D

func _ready():
	# Connect the body_entered signal of the grab_area to a method
	grab_area.connect("body_entered", Callable(self, "_on_body_entered"))
	grab_area.connect("body_exited", Callable(self, "_on_body_exited"))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction > 0:
		animated_sprite.flip_h = false
		
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# pushing objects
	if not is_grabbing:
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			if col.get_collider() is RigidBody2D:
				col.get_collider().apply_force(col.get_normal() * -force)
				
	# handle grabbing
	if Input.is_action_just_pressed("grab"):
		if is_grabbing:
			release_object(delta)
		else:
			try_grab_object()
			
			
	if grabbed_object:
		move_grabbed_object()
	
func try_grab_object() -> void:
	for body in grab_area.get_overlapping_bodies():
		if body is RigidBody2D:
			grabbed_object = body as RigidBody2D
			handleLayerDuringDragging()
			is_grabbing = true
			grabbed_object.freeze = true
			break
			
var grab_position: Vector2

func release_object(delta) -> void:
	if grabbed_object:
		grabbed_object.freeze = false
		handleLayerDuringDragging()
		
		if not animated_sprite.flip_h:
			grabbed_object.move_body(Vector2(grab_position.x + 15.0, grab_position.y -5.0))
		else:
			grabbed_object.move_body(Vector2(grab_position.x + -15.0, grab_position.y -5.0))
			
		
		grabbed_object.apply_force(velocity * (force / 20))
		
		grabbed_object = null
		is_grabbing = false

func move_grabbed_object():
	if grabbed_object:
		grab_position = global_position + Vector2(velocity.x * get_physics_process_delta_time(), -10)
		grabbed_object.global_position = grab_position
		grabbed_object.move_body(grab_position)
		
func handleLayerDuringDragging():
	if is_grabbing:
		grabbed_object.set_collision_layer_value(4, false)
		grabbed_object.set_collision_layer_value(1, true)
	else:
		grabbed_object.set_collision_layer_value(1, false)
		grabbed_object.set_collision_layer_value(4, true)







		
		
		
		
		