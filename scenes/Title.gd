extends Node2D

func _ready():
	$AnimationPlayer.play("New Anim")
	for i in range(4):
		yield(get_tree().create_timer(0.2), "timeout")
		Global.play_sound(Global.drift_snd)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	Music.play(Global.MainTheme)
	yield(get_tree().create_timer(5), "timeout")
	get_tree().change_scene("res://scenes/PlayerSelect.tscn")
