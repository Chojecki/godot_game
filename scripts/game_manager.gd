extends Node

var score = 0
var timing = 0

@onready var score_label = $CanvasLayer/ScoreLabel
@onready var popup = $Popup
@onready var label_2 = $Popup/MarginContainer/VBoxContainer/Label2
@onready var name_input = $Popup/MarginContainer/VBoxContainer/LineEdit
@onready var http_request = $HTTPRequest
@onready var timer = $Timer

var url = "https://medicheck.pockethost.io/api/collections/medicines/records"

func _ready():
	http_request.request_completed.connect(_on_http_request_request_completed)
	
	timer.start()
	popup.hide()
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.connect("enemy_died", Callable(self, "_on_enemy_died"))
	

func add_points():
	score += 1
	score_label.text = "Elo rap ziomal: " + str(score) + " Hajsu"

func show_score_popup():
	timer.stop()
	# Update the score label with the current score
	label_2.text = str(timing)
	# Show the popup
	popup.popup_centered()

func _on_Button_pressed():
	# Handle the player's name submission here
	var player_name = name_input.text
	print("Player's name:", player_name)
	# Hide the popup after submission
	popup.hide()

func _on_enemy_died() -> void:
	show_score_popup()

func send_data(data):
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	http_request.request(url, headers, HTTPClient.METHOD_POST, json)

func _on_http_request_request_completed(result, response_code, headers, body):
	if response_code == 200:
		popup.hide()

func _on_button_pressed():
	var data = {
		"name": name_input.text,
		"score": score,
		"time": timing
	}
	send_data(data)


func _on_timer_timeout():
	timing += 1
