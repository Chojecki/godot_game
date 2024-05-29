extends Sprite2D

@onready var collision_shape = $CollectArea/CollisionShape2D
@onready var animation_player = $AnimationPlayer


func hit() -> void:
	animation_player.play("shovel")




