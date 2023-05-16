extends KinematicBody2D
export var color: Color
var slide = 0
var slide_total = 2
var shield_time = 0
var shield_time_total = 7.5
var in_boxes = false
var tire_decay = 250.00
var tires = 100
var fake_brake = 0
var boost_start_value = 0
var bump_played = false
var boosts = 0
var inactive_time = 0
var rotation_speed_boost = 160
var rotation_speed_original = 100
var rotation_speed = rotation_speed_original
var drifting_time = 0
var drifting_time_total = 0.6
var pitch = 0
var pitch_max = 2
var item = ""
var discObj = preload("res://scenes/Disc.tscn")
var splatObj = preload("res://scenes/Splat.tscn")

var engine_power = 650
var engine_boost = 0
var engine_boost_total = 3500
var engine_boost_decrease = 8500

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var friction = -0.9
var drag = -0.001
var respawn_point = Vector2.ZERO
var prev_velocity = Vector2.ZERO
var explode_speed = 425.0
export var player_num = ""
var car_name = ""
var audio_stream_player = AudioStreamPlayer.new()
export var _LapObj: NodePath
onready var LapObj : Node2D = get_node(_LapObj) as Node2D

func _ready():	
	if player_num == "p1":
		if Global.CAR_NAME1 == "":
			queue_free()
			return 
		
		car_name = Global.CAR_NAME1
	if player_num == "p2":
		if Global.CAR_NAME2 == "":
			queue_free()
			return 
		
		car_name = Global.CAR_NAME2
	if player_num == "p3":
		if Global.CAR_NAME3 == "":
			queue_free()
			return 
		
		car_name = Global.CAR_NAME3
	if player_num == "p4":
		if Global.CAR_NAME4 == "":
			queue_free()
			return 
		
		car_name = Global.CAR_NAME4
		
	audio_stream_player.stream = Global.engine
	audio_stream_player.bus = "engineSFX" + player_num
	add_child(audio_stream_player)
		
	trail_visible(false)
	$TrailParticles.emitting = false
	add_to_group("cars")
	$sprite.material.set_shader_param("replacement_color", color)
	
func has_item():
	return (item != "" and item != "randomize")
	
func do_item_action():
	if item == "ray":
		if Global.hand_nodamage == "":
			do_ray()
			item = ""
	if item == "shield":
		do_shield()
		item = ""
	if item == "disc":
		do_disc()
		item = ""
	if item == "splat":
		do_splat()
		item = ""
		
func do_slide():
	slide = slide_total

func do_splat():
	var splat = splatObj.instance()
	Global.TileObj.add_child(splat)
	splat.global_position = $splat_position.global_position

func do_ray():
	if Global.hand_nodamage == "":
		Global.hand_nodamage = player_num
		Global.hand_animation.play("New Anim")
	
func do_shield():
	shield_time = shield_time_total
	
func do_disc():
	var disc = discObj.instance()
	disc.pong_dir = Vector2(cos(rotation), sin(rotation))
	var root = get_parent()
	root.add_child(disc)
	disc.global_position = $disc_position.global_position
	disc.set_color(color)
	
func set_item(itm):
	if itm == 1:
		item = "ray"
	if itm == 2:
		item = "shield"
	if itm == 3:
		item = "disc"
	if itm == 4:
		item = "splat"
	
func random_slot_item():
	if item == "":
		item = "randomize"
	
func boxes(val):
	velocity = Vector2.ZERO
	acceleration = Vector2.ZERO
	rotation_degrees = 0
	trail_visible(false)
	$TrailParticles.emitting = false
	in_boxes = val
	if !val:
		tires = 100
		$tipi1.visible = false
		$tipi2.visible = false
		$tipi3.visible = false
		$tipi4.visible = false
	else:
		$tipi1.visible = true
		$tipi2.visible = true
		$tipi3.visible = true
		$tipi4.visible = true
		
func add_lap():
	LapObj.add_lap(car_name)
	
func dec_lap():
	LapObj.dec_lap(car_name)
	
func add_checkpoint(obj):
	respawn_point = obj
	
func respawn():
	$sprite.animation = "default"
	$sprite.playing = false
	$TrailParticles.emitting = false
	position = respawn_point.position
	rotation_degrees = respawn_point.set_rotation
	inactive_time = 1.2
	boosts = 0
	pitch = 0
	audio_stream_player.pitch_scale = pitch
	
func explode():
	var options = {"pitch_scale": 0.7}
	Global.play_sound(Global.explosion, options)
	audio_stream_player.stop()
	pitch = 0
	audio_stream_player.pitch_scale = pitch
	boosts = 0
	acceleration = Vector2.ZERO
	velocity = Vector2.ZERO
	engine_boost = 0
	$sprite.animation = "explode"
	$sprite.playing = true
	$TrailParticles.emitting = false

func apply_friction(debuff = 0):
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * (friction - debuff)
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force
	
func trail_visible(_visible, normalbrake = true):
	if boosts <= 0 and _visible and !normalbrake:
		Global.play_sound(Global.boost_snd)
		boosts = 1
	$Trail_Point1/Trail.restart(_visible)
	$Trail_Point2/Trail.restart(_visible)
	
func drifting():
	if Input.is_action_pressed("right_" + player_num) or Input.is_action_pressed("left_" + player_num):
		if velocity.length() >= (explode_speed / 2.0) and Input.is_action_pressed("acelerate_" + player_num) and Input.is_action_pressed("brake_" + player_num):
			return true
			
	return false
	
func just_stoped_drifting():
		if Input.is_action_just_released("right_" + player_num) or Input.is_action_just_released("left_" + player_num) or Input.is_action_just_released("acelerate_" + player_num) or Input.is_action_just_released("brake_" + player_num):
			return true
		else:
			return false
			
func is_a_car(name):
	return (name == "carB" or name == "carB2" or name == "carB3" or name == "carB4")

func do_boost():
	if boosts > 0 and engine_boost <= 0:
		if !Input.is_action_pressed("acelerate_" + player_num) and !Input.is_action_pressed("brake_" + player_num):
			return true
	
	return false

func _physics_process(delta):
	if !Global.STARTED:
		if audio_stream_player.playing:
			pitch -= 1 * delta
			if pitch <= 0:
				pitch = 0
		
		if Input.is_action_pressed("acelerate_" + player_num):
			boost_start_value += 1 * delta
			
			if !audio_stream_player.playing:
				audio_stream_player.play()
								
			pitch += 2 * delta
			if pitch > pitch_max:
				pitch = pitch_max
		else:
			boost_start_value -= 1 * delta
			if boost_start_value <= 0:
				boost_start_value = 0
			
		audio_stream_player.pitch_scale = pitch
	else:
		if boost_start_value > 0 and boost_start_value > 1.6 and boost_start_value <= 1.9:
			#GOOD!
			boost_start_value = 0
			engine_boost = engine_boost_total
		
		if boost_start_value >= 2.7:
			#BAD
			hurt_tires(5)
			Global.play_sound(Global.drift_snd)
			trail_visible(true, true)
			boost_start_value = 0
			fake_brake = 2.1
			
		if tires <= 0:
			fake_brake = 1
		
		acceleration = Vector2.ZERO
		
		if in_boxes:
			pitch -= 1 * delta
			if pitch <= 0:
				pitch = 0
			audio_stream_player.pitch_scale = pitch
			return
				
		if inactive_time > 0:
			$sprite.animation = "inactive"
			$sprite.playing = true
			inactive_time -= 1 * delta
			if inactive_time <= 0:
				$sprite.animation = "default"
				$sprite.playing = false
		
		if prev_velocity.length() > explode_speed:
			rotation_speed = rotation_speed_boost
		else:
			rotation_speed = rotation_speed_original
			
		if $sprite.animation == "default" and inactive_time <= 0:
			if boosts > 0:
				$sprite.playing = true
			
			if engine_boost > 0:
				pitch = pitch_max
				if !$TrailParticles.emitting:
					$TrailParticles.emitting = true
					Global.play_sound(Global.explosion)
					
				$sprite.playing = true
				engine_boost -= engine_boost_decrease * delta
				pitch = pitch_max * 2
				if engine_boost <= 0:
					$TrailParticles.emitting = false
					$sprite.playing = false
					$sprite.frame = 0
					pitch = pitch_max
					engine_boost = 0
					
			if do_boost():
				engine_boost = engine_boost_total
				boosts -= 1
				
			if drifting():
				hurt_tires((velocity.length() / tire_decay) * delta)
				drifting_time += 1 * delta
			else:
				drifting_time = 0
				
			if just_stoped_drifting():
				drifting_time = 0
				
			if drifting_time > drifting_time_total:
				Global.play_sound(Global.drift_snd)
				trail_visible(true, false)
			else:
				if fake_brake <= 0:
					trail_visible(false)
				
			if Input.is_action_pressed("right_" + player_num):
				rotation_degrees += rotation_speed * delta
			if Input.is_action_pressed("left_" + player_num):
				rotation_degrees -= rotation_speed * delta
				
			if has_item() and Input.is_action_just_pressed("boost_" + player_num):
				do_item_action()
				
			pitch -= 1 * delta
			if pitch <= 0:
				pitch = 0
				
			if shield_time > 0:
				shield_time -= 1 * delta
				$shield.visible = true
				if shield_time <= 0:
					$shield.visible = false

			if Input.is_action_pressed("acelerate_" + player_num) or engine_boost != 0:
				if !audio_stream_player.playing:
					audio_stream_player.play()
									
				if engine_boost <=0:
					pitch += 2 * delta
					if pitch > pitch_max:
						pitch = pitch_max
				
				acceleration = transform.x * (engine_power + engine_boost)
				
			audio_stream_player.pitch_scale = pitch
			
			if slide > 0:
				rotation_degrees += 1000 * delta
				apply_friction()
				apply_friction()
				if randi() % 10 == 0:
					Global.play_sound(Global.drift_snd)
					trail_visible(true, true)
					
				slide -= 1 * delta
				if slide <= 0:
					trail_visible(false)
				
			if fake_brake > 0 or  Input.is_action_pressed("brake_" + player_num):
				hurt_tires((velocity.length() / tire_decay) * delta)
				
				if fake_brake > 0:
					rotation_degrees += rand_range(-4, 4)
					if tires > 0:
						Global.play_sound(Global.drift_snd)
					fake_brake -= 1 * delta
					trail_visible(true, true)
					if randi() % 10 == 0:
						if tires > 0:
							Global.play_sound(Global.drift_snd)
					if fake_brake <= 0:
						trail_visible(false)
					
				if drifting_time <= 0:
					#double friction by braking
					apply_friction()
					apply_friction()
					if velocity.length() > 250:
						Global.play_sound(Global.drift_snd)
				else:
					apply_friction(-0.2)
					
			#normal friction
			apply_friction()

			velocity += acceleration * delta
			prev_velocity = velocity
			velocity = move_and_slide(velocity)
			
			hurt_tires((velocity.length() / tire_decay) * delta)
		
			if get_slide_count() > 0:
				var col = get_slide_collision(0)
				if is_a_car(col.collider.name):
					if !bump_played:
						
						var collision = col
						if collision:
							var other_body = collision.collider
							var push_direction = collision.normal.normalized()
							var push_force = velocity.length()
							var my_push = push_direction * push_force * delta
							var other_push = -push_direction * push_force * delta
							move_and_collide(my_push)
							other_body.move_and_collide(other_push)

						rotation_degrees += rand_range(-1, 1)
						bump_played = true
						Global.play_sound(Global.bump)
				
				elif shield_time <= 0 and prev_velocity.length() > explode_speed:
					bump_played = false
					hurt_tires(5)
					explode()
				else:
					if !bump_played:
						bump_played = true
						Global.play_sound(Global.bump)
			else:
				bump_played = false
				
func hurt_tires(amount):
	tires -= amount
	if tires <= 0:
		tires = 0

func _on_sprite_animation_finished():
	if $sprite.animation == "explode":
		respawn()
