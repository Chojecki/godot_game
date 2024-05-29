extends Sprite2D

@onready var timer = $Timer
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var animation_player = $AnimationPlayer


var characterBody: CharacterBody2D

var taken := false

func _ready():
	animation_player.play("rotation")

func _on_area_2d_body_entered(body):
	if  !taken and body.has_method("get_weapon"):
		taken = true
		characterBody = body 
		timer.start()
		collision_shape.set_deferred("disabled", true)


func _on_timer_timeout():
	characterBody.get_weapon()
	queue_free()
	characterBody = null

