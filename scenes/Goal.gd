extends Area2D

func _on_Goal_body_entered(body):
	if body.is_in_group("cars"):
		pass


func _on_Goal_body_exited(body):
	if body.is_in_group("cars"):
		if body.position.x > position.x:
			body.add_lap()
		else:
			body.dec_lap()
