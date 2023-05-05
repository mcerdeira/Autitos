extends Node
var STARTED = false
var TOTAL_LAPS = 7
var winner_label = null

func end_race(car_name, color):
	winner_label.text =  car_name + " WINNER!!"
	winner_label.add_color_override("font_color", color)
	winner_label.visible = true

func _ready():
	pass # Replace with function body.

