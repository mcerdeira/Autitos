extends Node2D
export var playernum = ""
export var color : Color
var started = false
var boxes_time_total = 3.5
var boxes_time = 0
var carObj = null
var audio_stream_player = AudioStreamPlayer.new()

func _ready():
	$col1.color = color
	$col2.color = color
	audio_stream_player.stream = Global.boxes_snd
	audio_stream_player.bus = "BoxesSFX"
	add_child(audio_stream_player)

func _physics_process(delta):
	if started:
		if !audio_stream_player.playing:
			audio_stream_player.play()
		
		boxes_time -= 1 * delta
		carObj.position = position
		if boxes_time <= 0:
			audio_stream_player.stop()
			started = false
			carObj.boxes(false)

func _on_area_body_entered(body):
	if !started and body.is_in_group("cars"):
		if playernum == body.player_num:
			carObj = body
			carObj.boxes(true)
			started = true
			boxes_time = boxes_time_total
