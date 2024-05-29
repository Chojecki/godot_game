extends CharacterBody2D

signal enemy_died

const SPEED = 60

var direction: Vector2 = Vector2.RIGHT

@export var health := 3

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var enemy_kill_zone = $EnemyKillZone
@onready var collision_shape_2d_enemy = $CollisionShape2DEnemy
@onready var timer = $Timer
@onready var timer_2 = $Timer2



var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	ray_cast_right.enabled = true
	ray_cast_left.enabled = true

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Check for collisions
	if direction == Vector2.RIGHT and ray_cast_right.is_colliding():
		var collider = ray_cast_right.get_collider()
		if collider and collider.is_in_group("enemy_walls"):
			direction = Vector2.LEFT
			animated_sprite.flip_h = true
	elif direction == Vector2.LEFT and ray_cast_left.is_colliding():
		var collider = ray_cast_left.get_collider()
		if collider and collider.is_in_group("enemy_walls"):
			direction = Vector2.RIGHT
			animated_sprite.flip_h = false

	# Move the character
	if is_on_floor():
		velocity = direction * SPEED
	move_and_slide()

func die():
	if collision_shape_2d_enemy:
		collision_shape_2d_enemy.queue_free()
		collision_shape_2d_enemy = null
		timer.start()
		emit_signal("enemy_died")

func _on_enemy_kill_zone_body_entered(body):
	die()

func take_damage(amount: int) -> void:
	timer_2.start()
	animated_sprite.play("hit")
	
	if amount >= health:
		die()
	else:
		health -= amount
		print(str(health))

func _on_timer_timeout():
	queue_free()


func _on_timer_2_timeout():
	animated_sprite.play("default")
