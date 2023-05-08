extends Node2D
var ttl = 0.2

func _ready():
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

func _on_Semaphore_frame_changed():
	if $Label2/Semaphore.frame == 2:
		Global.play_sound(Global.bip_low2)
	if $Label2/Semaphore.frame == 4:
		Global.play_sound(Global.bip_low)
	if $Label2/Semaphore.frame == 6:
		Global.play_sound(Global.bip_high)
