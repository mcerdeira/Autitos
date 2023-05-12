extends KinematicBody2D
export var color: Color
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
		
	add_child(audio_stream_player)
	audio_stream_player.stream = Global.engine
	audio_stream_player.bus = "engineSFX" + player_num
	add_child(audio_stream_player)
		
	trail_visible(false)
	$TrailParticles.emitting = false
	add_to_group("cars")
	$sprite.material.set_shader_param("replacement_color", color)
	
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
	Global.play_sound(Global.explosion)
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
			Global.play_sound(Global.drift_snd)
			trail_visible(true, true)
			boost_start_value = 0
			fake_brake = 2.1
		
		acceleration = Vector2.ZERO
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
			
			if boosts > 0 and engine_boost <= 0 and Input.is_action_just_pressed("boost_" + player_num):
				engine_boost = engine_boost_total
				boosts -= 1
				
			if drifting():
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
				
			pitch -= 1 * delta
			if pitch <= 0:
				pitch = 0

			if Input.is_action_pressed("acelerate_" + player_num) or engine_boost != 0:
				if !audio_stream_player.playing:
					audio_stream_player.play()
									
				if engine_boost <=0:
					pitch += 2 * delta
					if pitch > pitch_max:
						pitch = pitch_max
				
				acceleration = transform.x * (engine_power + engine_boost)
				
			audio_stream_player.pitch_scale = pitch
				
			if fake_brake > 0 or  Input.is_action_pressed("brake_" + player_num):
				if fake_brake > 0:
					rotation_degrees += rand_range(-4, 4)
					Global.play_sound(Global.drift_snd)
					fake_brake -= 1 * delta
					trail_visible(true, true)
					if randi() % 10 == 0:
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
				
				elif prev_velocity.length() > explode_speed:
					bump_played = false
					explode()
				else:
					if !bump_played:
						bump_played = true
						Global.play_sound(Global.bump)
			else:
				bump_played = false

func _on_sprite_animation_finished():
	if $sprite.animation == "explode":
		respawn()
