extends Area2D
var ttl = 30

func _on_Splat_body_entered(body):
	if body.is_in_group("cars"):
		body.do_slide()
		yield(get_tree().create_timer(1.2), "timeout")
		queue_free()
