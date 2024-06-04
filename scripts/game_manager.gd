extends Node

var score = 0
var timing = 0
var canPlayerProduce := false
var position: Vector2

var stone = preload("res://scenes/mobable_element.tscn")

@onready var score_label = $CanvasLayer/ScoreLabel
@onready var popup = $Popup
@onready var label_2 = $Popup/MarginContainer/VBoxContainer/Label2
@onready var name_input = $Popup/MarginContainer/VBoxContainer/LineEdit
@onready var http_request = $HTTPRequest
@onready var timer = $Timer
@onready var label_3 = $Popup/MarginContainer/VBoxContainer/Label3
@onready var button = $Popup/MarginContainer/VBoxContainer/Button

var url = "https://medicheck.pockethost.io/api/collections/medicines/records"

func _ready():
	http_request.request_completed.connect(_on_http_request_request_completed)
	
	timer.start()
	popup.hide()
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.connect("enemy_died", Callable(self, "_on_enemy_died"))

func _process(delta):
	if Input.is_action_just_pressed("produce") and canPlayerProduce:
		produce(position)

func add_points():
	score += 1
	score_label.text = "Elo rap ziomal: " + str(score) + " Hajsu"

func show_score_popup(way: String):
	timer.stop()
	# Update the score label with the current score
	label_2.text = str(timing)
	if way == "hit":
		label_3.text = "No nieźle. Ale da się ukończyć grę w 1 sekunde. Spróbuj jeszcze raz"
	else:
		label_3.text = "Brawo, jak widac, szapdel nie byl potrzebny"
	
	# Show the popup
	popup.popup_centered()

func _on_Button_pressed():
	# Handle the player's name submission here
	var player_name = name_input.text
	print("Player's name:", player_name)
	# Hide the popup after submission
	popup.hide()

func _on_enemy_died(way: String) -> void:
	#show_score_popup(way)
	pass

func send_data(data):
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	http_request.request(url, headers, HTTPClient.METHOD_POST, json)

func _on_http_request_request_completed(result, response_code, headers, body):
	get_tree().reload_current_scene()

func _on_button_pressed():
	if not name_input.text == "":
		button.disabled = true
		var data = {
		"name": name_input.text,
		"score": score,
		"time": timing
		}
		send_data(data)


func _on_timer_timeout():
	timing += 1
	
func produce(position):
	var stone_instance = stone.instantiate()
	stone_instance.position = position
	add_child(stone_instance)
