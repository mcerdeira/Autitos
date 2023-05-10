extends Node2D
var next = false

func _input(event):
	if event.is_action_pressed("acelerate_p1") or event.is_action_pressed("acelerate_p2") or event.is_action_pressed("acelerate_p3") or event.is_action_pressed("acelerate_p4"):
		go_next(true)

func go_next(now = false):
	if !next:
		next = true
		Music.play(Global.MainTheme)
		if !now:
			yield(get_tree().create_timer(5), "timeout")
		get_tree().change_scene("res://scenes/PlayerSelect.tscn")

func _ready():
	$AnimationPlayer.play("New Anim")
	for i in range(4):
		yield(get_tree().create_timer(0.2), "timeout")
		Global.play_sound(Global.drift_snd)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	go_next()
