extends Node2D
var ttl = 0.2
var forward = true

func _ready():
	Music.stop()
	$lbl_winner.visible = false
	$Label2.text = "LAPS: " + str(Global.TOTAL_LAPS)
	$Label2.visible = true
	
func _physics_process(delta):
	if ttl > 0:
		ttl -= 1 * delta
		if ttl >= 0:
			$Label2/Semaphore.playing = true

func _on_Semaphore_animation_finished():
	$Label2/Semaphore.playing = false
	$Label2/Semaphore.visible = false
	Global.STARTED = true
	var theme = Global.pick_random(Global.RacingTheme)
	Music.play(theme)

func _on_Semaphore_frame_changed():
	if $Label2/Semaphore.frame == 2:
		Global.play_sound(Global.bip_low2)
	if $Label2/Semaphore.frame == 4:
		Global.play_sound(Global.bip_low)
	if $Label2/Semaphore.frame == 6:
		Global.play_sound(Global.bip_high)

func _on_hand_animation_animation_finished(anim_name):
	if forward:
		forward = false
		Global.shaker_obj.shake(10, 2.3)
		var cars = get_tree().get_nodes_in_group("cars")
		for c in cars:
			if c.player_num != Global.hand_nodamage:
				c.explode()
		
		Global.hand_nodamage = ""
		$hand_animation.play_backwards("New Anim")
	else:
		Global.hand_nodamage = ""
		forward = true
