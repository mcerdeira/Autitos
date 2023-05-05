extends Node2D
export var color: Color
var count = 0

func _ready():
	$Label.add_color_override("font_color", color)
	$Label.text = str(count)

func add_lap():
	count += 1
	$Label.text = str(count)

func dec_lap():
	count -= 1
	$Label.text = str(count)
