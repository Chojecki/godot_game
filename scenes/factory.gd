extends Area2D

var game_manager: Node

func _ready():
	game_manager = get_parent().get_node("GameManager")
	
func _on_body_entered(body):
	if body.name == "Player" and game_manager != null:
		game_manager.canPlayerProduce = true
		game_manager.position = body.position


func _on_body_exited(body):
	if body.name == "Player" and game_manager != null:
		game_manager.canPlayerProduce = false
