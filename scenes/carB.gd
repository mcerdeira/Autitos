extends KinematicBody2D
export var color: Color
var rotation_speed = 100
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var engine_power = 650
var engine_boost = 0
var friction = -0.9
var drag = -0.001
var respawn_point = Vector2.ZERO
var prev_velocity = Vector2.ZERO
export var _LapObj: NodePath
onready var LapObj : Node2D = get_node(_LapObj) as Node2D

func _ready():
	add_to_group("cars")
	$sprite.material.set_shader_param("replacement_color", color)
	
func add_lap():
	LapObj.add_lap()
	
func dec_lap():
	LapObj.dec_lap()
	
func add_checkpoint(obj):
	respawn_point = obj
	
func respawn():
	$sprite.animation = "default"
	$sprite.playing = false
	position = respawn_point.position
	rotation_degrees = respawn_point.set_rotation
	
func explode():
	acceleration = Vector2.ZERO
	velocity = Vector2.ZERO
	$sprite.animation = "explode"
	$sprite.playing = true

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func _physics_process(delta):
	acceleration = Vector2.ZERO
	
	if prev_velocity.length() > 330:
		rotation_speed = 160
	else:
		rotation_speed = 100
	
	if $sprite.animation == "default":
		if engine_boost > 0:
			engine_boost -= 7000 * delta
			if engine_boost <= 0:
				engine_boost = 0
		
		if engine_boost <= 0 and Input.is_action_just_pressed("boost"):
			engine_boost = 3500
		
		if Input.is_action_pressed("right"):
			rotation_degrees += rotation_speed * delta
		if Input.is_action_pressed("left"):
			rotation_degrees -= rotation_speed * delta

		if Input.is_action_pressed("acelerate") or engine_boost != 0:
			acceleration = transform.x * (engine_power + engine_boost)
			
		if Input.is_action_pressed("brake"):
			apply_friction()
			apply_friction()

		apply_friction()

		velocity += acceleration * delta
		prev_velocity = velocity
		velocity = move_and_slide(velocity)
		
		if get_slide_count() > 0 and prev_velocity.length() > 330:
			explode()

func _on_sprite_animation_finished():
	if $sprite.animation == "explode":
		respawn()
