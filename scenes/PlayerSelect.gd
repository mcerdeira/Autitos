extends Node2D
var timer = 60

func _ready():
	$timer.text = ""

func _physics_process(delta):
	if Global.PlayersJoined >= 2:
		timer -= 1 * delta
		if timer <= 0:
			timer = 0
			get_tree().change_scene("res://scenes/Main.tscn")
			
		$timer.text = str(round(timer))
