extends Node
var STARTED = false
var CAR_NAME1 = ""
var CAR_NAME2 = ""
var CAR_NAME3 = ""
var CAR_NAME4 = ""
var TOTAL_LAPS = 7
var winner_label = null
var one = null
var two = null
var three = null
var four = null
var engine = null
var bip_low = null
var bip_low2 = null
var bip_high = null
var explosion = null
var boost_snd = null
var drift_snd = null
var MainTheme = null
var you_win = null
var PlayersJoined = 0
var players = []

func _input(event):
	var cur_scene = get_tree().current_scene.name
	if cur_scene == "TitleScreen":
		if event.is_action_pressed("quit_game"):
			get_tree().quit()
	else:
		if event.is_action_pressed("toggle_fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen

func end_race(car_name, color):
	Global.play_sound(Global.you_win)
	winner_label.text =  car_name + " WINNER!!"
	winner_label.add_color_override("font_color", color)
	winner_label.visible = true

func _ready():
	loadSfx()
	
func loadSfx():
	bip_low = preload("res://sfx/biplow.wav")
	bip_low2 = preload("res://sfx/biplow.wav")
	bip_high = preload("res://sfx/biphigh.wav")
	explosion = preload("res://sfx/explosion.wav")
	boost_snd = preload("res://sfx/boost.wav")
	drift_snd = preload("res://sfx/drift.wav")
	MainTheme = preload("res://music/MainTheme.mp3")
	you_win = preload("res://sfx/you_win.ogg")
	one = preload("res://sfx/1.ogg")
	two = preload("res://sfx/2.ogg")
	three = preload("res://sfx/3.ogg")
	four = preload("res://sfx/4.ogg")
	engine = preload("res://sfx/engine.wav")

func play_sound(stream: AudioStream, options:= {}) -> AudioStreamPlayer:
	var audio_stream_player = AudioStreamPlayer.new()

	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	audio_stream_player.bus = "SFX"
	
	for prop in options.keys():
		audio_stream_player.set(prop, options[prop])
	
	audio_stream_player.play()
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")
	
	return audio_stream_player
