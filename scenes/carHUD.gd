extends Node2D
export var _CarObj: NodePath
onready var CarObj : Node2D = get_node(_CarObj) as Node2D
var player_num = ""
var randomizing = 0
var randomizing_total = 1.2
var random_item = -1
var audio_stream_player = AudioStreamPlayer.new()

func _ready():
	audio_stream_player.stream = Global.boxes_snd
	audio_stream_player.bus = "BoxesSFX"
	add_child(audio_stream_player)
	
	$lbl_turbo.add_color_override("font_color", Color8(100, 100, 100))
	$background.color = CarObj.color
	player_num = CarObj.player_num
	if player_num == "p1":
		if Global.CAR_AVATAR1 != -1:
			$lbl_playername.text = Global.CAR_NAME1
			$avatar.visible = true
			$avatar.frame = Global.CAR_AVATAR1
	if player_num == "p2":
		if Global.CAR_AVATAR2 != -1:
			$lbl_playername.text = Global.CAR_NAME2
			$avatar.visible = true
			$avatar.frame = Global.CAR_AVATAR2
	if player_num == "p3":
		if Global.CAR_AVATAR3 != -1:
			$lbl_playername.text = Global.CAR_NAME3
			$avatar.visible = true
			$avatar.frame = Global.CAR_AVATAR3
	if player_num == "p4":
		if Global.CAR_AVATAR4 != -1:
			$lbl_playername.text = Global.CAR_NAME4
			$avatar.visible = true
			$avatar.frame = Global.CAR_AVATAR4

func _physics_process(delta):
	if is_instance_valid(CarObj):
		if CarObj.engine_boost > 0 or CarObj.boosts > 0:
			var R = randi() % 256
			var G = randi() % 256
			var B = randi() % 256
			$lbl_turbo.add_color_override("font_color", Color8(R, G, B))
		else:
			$lbl_turbo.add_color_override("font_color", Color8(100, 100, 100))
		
		if CarObj.item == "randomize" and !$item.playing:
			if !audio_stream_player.playing:
				audio_stream_player.play()
				audio_stream_player.pitch_scale = 1.5
			
			randomizing = randomizing_total
			random_item = -1
			$item.playing = true
			
		if CarObj.item != "" and CarObj.item != "randomize":
			if audio_stream_player.playing:
				audio_stream_player.stop()
		
		if CarObj.item == "":
			if audio_stream_player.playing:
				audio_stream_player.stop()
			randomizing = randomizing_total
			random_item = -1
			$item.frame = 0
			$item.playing = false
			
		if $item.playing:
			randomizing -= 1 * delta
			if randomizing <= 0:
				randomizing = randomizing_total
				random_item = -1
				$item.playing = false
				$item.frame = Global.pick_random([1, 2, 3, 4])
				CarObj.set_item($item.frame)
				
		
		$speed.text = str(round(CarObj.velocity.length()))
		$tires_bar.rect_size.x = CarObj.tires
