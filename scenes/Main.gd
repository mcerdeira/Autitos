extends Node2D
var tim = 0.0

func _physics_process(delta):
	tim += 1.0 * delta
	$Label2/Timer.text = str(tim).pad_decimals(1)
