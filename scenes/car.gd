extends KinematicBody2D
var wheel_animation_speed = 0

var wheel_base = 70
var steering_angle = 45
var engine_power = 500
var engine_boost = 0
var friction = -0.9
var drag = -0.001
var max_speed_reverse = 250

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_direction
export var color: Color

func _ready():
	$sprite.material.set_shader_param("replacement_color", color)
	
func explode():
	pass

func _physics_process(delta):
	acceleration = Vector2.ZERO
	if engine_boost > 0:
		steering_angle = 20
		engine_boost -= 7000 * delta
		if engine_boost <= 0:
			engine_boost = 0
			steering_angle = 45
			
	
	get_input(delta)
	
	if wheel_animation_speed < 0:
		wheel_animation_speed = 0
		
	if wheel_animation_speed > 5:
		wheel_animation_speed = 5
		
	$sprite.speed_scale = wheel_animation_speed
	$sprite.playing = wheel_animation_speed != 0
	
	apply_friction()
	calculate_steering(delta)
	
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func get_input(delta):
	var turn = 0
	if Input.is_action_pressed("right"):
		turn += 1
	if Input.is_action_pressed("left"):
		turn -= 1
	
	steer_direction = turn * deg2rad(steering_angle)
	if engine_boost <= 0 and Input.is_action_just_pressed("boost"):
		engine_boost = 3500
	
	if Input.is_action_pressed("acelerate"):
		wheel_animation_speed += 1 * delta
		acceleration = transform.x * (engine_power + engine_boost)
	else:
		wheel_animation_speed -= 1 * delta
	
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
