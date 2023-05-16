extends KinematicBody2D
var ttl = 10
var pong_dir = Vector2.ZERO
var nohit_ttl = 0.1
var disc_speed = 900

func _ready():
	Global.play_sound(Global.drift_snd)
	pong_dir *= disc_speed
	
func set_color(color: Color):
	$sprite.material.set_shader_param("replacement_color", color)
	
func _physics_process(delta):
	$sprite.rotation_degrees += 1000 * delta
	
	var prev_velocity = pong_dir
	pong_dir = move_and_slide(pong_dir)
	
	if get_slide_count() > 0:
		Global.play_sound(Global.bump)
		pong_dir = prev_velocity.bounce(get_slide_collision(0).normal)

	nohit_ttl -= 1 * delta

	ttl -= 1 * delta
	if ttl <= 0:
		queue_free()

func _on_area_body_entered(body):
	if nohit_ttl <= 0:
		if body.is_in_group("cars"):
			body.explode()
			queue_free()
