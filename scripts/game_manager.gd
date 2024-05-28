extends Node

var score = 0

@onready var score_label = $CanvasLayer/ScoreLabel

func add_points():
	score += 1
	score_label.text = "Elo rap ziomal: " + str(score) + " Hajsu"
