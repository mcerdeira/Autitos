extends Node2D
var done_avatar = false
var done = false
var active = false
var inv_time_total = 0.2
var inv_time = 0
export var color: Color
export var player_num = ""
var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", " ", "!", "?"]
var cursor = [0, 0, 0, 0]
var cursor_pos = 0

func _ready():
	$lbl_player.text = "PLAYER " + player_num + ":"
	$background.color = color
	
func get_name():
	return $char_1.text + $char_2.text + $char_3.text

func _physics_process(delta):
	if done and done_avatar:
		if Global.PlayersJoined >= 2:
			if Input.is_action_just_pressed("acelerate_p" + player_num):
				get_parent().timer -= 10
		
		Global.players.append("p"+player_num)
		if player_num == "1":
			Global.CAR_NAME1 = get_name()
		if player_num == "2":
			Global.CAR_NAME2 = get_name()
		if player_num == "3":
			Global.CAR_NAME3 = get_name()
		if player_num == "4":
			Global.CAR_NAME4 = get_name()
			
		$char_1.visible = true
		$char_2.visible = true
		$char_3.visible = true
		$player_avatar.visible = true
		$lbl_ready.visible = true
	else:
		if active:
			if player_num == "1":
				Global.CAR_NAME1 = get_name()
				Global.CAR_AVATAR1 = cursor[0]
			if player_num == "2":
				Global.CAR_NAME2 = get_name()
				Global.CAR_AVATAR2 = cursor[0]
			if player_num == "3":
				Global.CAR_NAME3 = get_name()
				Global.CAR_AVATAR3 = cursor[0]
			if player_num == "4":
				Global.CAR_NAME4 = get_name()
				Global.CAR_AVATAR4 = cursor[0]
			
			if !done_avatar and !done and Input.is_action_just_pressed("acelerate_p" + player_num):
				done_avatar = true
				Global.play_sound(Global.boost_snd)
				cursor_pos = 1
			elif done_avatar and !done and Input.is_action_just_pressed("acelerate_p" + player_num):
				done = true
				Global.play_sound(Global.boost_snd)
				yield(get_tree().create_timer(0.5), "timeout")
				Global.play_sound(Global.ready)
			
			if done_avatar:
				if Input.is_action_just_pressed("left_p" + player_num):
					Global.play_sound(Global.bip)
					cursor_pos -= 1
					if cursor_pos < 1:
						cursor_pos = 3
				if Input.is_action_just_pressed("right_p" + player_num):
					Global.play_sound(Global.bip)
					cursor_pos += 1
					if cursor_pos > 3:
						cursor_pos = 1
			else:
				cursor_pos = 0
				
			if Input.is_action_just_pressed("up_p" + player_num):
				Global.play_sound(Global.bip)
				cursor[cursor_pos] += 1
				if cursor_pos == 0:
					if cursor[cursor_pos] > $player_avatar.frames.get_frame_count("default") - 1:
						cursor[cursor_pos] = 0
				else:
					if cursor[cursor_pos] > letters.size() - 1:
						cursor[cursor_pos] = 0
			if Input.is_action_just_pressed("down_p" + player_num):
				Global.play_sound(Global.bip)
				cursor[cursor_pos] -= 1
				if cursor_pos == 0:
					if cursor[cursor_pos] < 0:
						cursor[cursor_pos] = $player_avatar.frames.get_frame_count("default") - 1
				else:
					if cursor[cursor_pos] < 0:
						cursor[cursor_pos] = letters.size() - 1
			
			inv_time -= 1 * delta
			if inv_time <= 0:
				inv_time = inv_time_total
				
				if cursor_pos == 0:
					$player_avatar.frame = cursor[cursor_pos]
					$player_avatar.visible = !$player_avatar.visible
					$char_1.visible = true
					$char_2.visible = true
					$char_3.visible = true
			
				if cursor_pos == 1:
					$player_avatar.visible = true
					$char_1.visible = !$char_1.visible
					$char_1.text = letters[cursor[cursor_pos]]
					$char_2.visible = true
					$char_3.visible = true
				if cursor_pos == 2:
					$player_avatar.visible = true
					$char_1.visible = true
					$char_2.visible = !$char_2.visible
					$char_2.text = letters[cursor[cursor_pos]]
					$char_3.visible = true
				if cursor_pos == 3:
					$player_avatar.visible = true
					$char_1.visible = true
					$char_2.visible = true
					$char_3.visible = !$char_3.visible
					$char_3.text = letters[cursor[cursor_pos]]
			
			$lbl_enter.visible = false
			$lbl_join.visible = true
			$lbl_player.visible = true
		
		if !active: 
			inv_time -= 1 * delta
			if inv_time <= 0:
				inv_time = inv_time_total
			
				$lbl_enter.visible = !$lbl_enter.visible
			
			if Input.is_action_just_pressed("acelerate_p" + player_num):
				if player_num == "1":
					Global.play_sound(Global.one)
				if player_num == "2":
					Global.play_sound(Global.two)
				if player_num == "3":
					Global.play_sound(Global.three)
				if player_num == "4":
					Global.play_sound(Global.four)
				active = true
				Global.PlayersJoined += 1
