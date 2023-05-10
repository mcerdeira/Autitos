extends Node2D
export var color: Color
export var playernum = ""
var count = -1
var tim = 0.0
var active = true

func _ready():
	$Label.add_color_override("font_color", color)
	$Label.text = str(count + 1)
	$ItemList.clear()
	if playernum == "p1":
		if Global.CAR_NAME1 == "":
			active = false
	
	if playernum == "p2":
		if Global.CAR_NAME2 == "":
			active = false
			
	if playernum == "p3":
		if Global.CAR_NAME3 == "":
			active = false
		
	if playernum == "p4":
		if Global.CAR_NAME4 == "":
			active = false

func _physics_process(delta):
	if active and Global.STARTED:
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
