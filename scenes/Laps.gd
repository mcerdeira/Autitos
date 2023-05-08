extends Node2D
export var color: Color
var count = -1
var tim = 0.0

func _ready():
	$Label.add_color_override("font_color", color)
	$Label.text = str(count + 1)
	$ItemList.clear()

func _physics_process(delta):
	if Global.STARTED:
		tim += 1.0 * delta
		$Label.text = str(count + 1)
		$Timer.text = str(tim).pad_decimals(1)

func add_lap(car_name):
	count += 1	
	if Global.STARTED and count > 0:
		$ItemList.add_item(str(count) + ". " +  $Timer.text)
		tim = 0.0
		$Label.text = str(count + 1)
		
	if count == Global.TOTAL_LAPS:
		Global.STARTED = false
		Global.end_race(car_name, color)

func dec_lap(car_name):
	tim = 0.0
	count -= 1
	$Label.text = str(count + 1)
