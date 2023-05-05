extends Area2D
export var set_rotation: int = 0

func _on_ExplodeCheckpoint_body_entered(body):
	if body.is_in_group("cars"):
		body.add_checkpoint(self)
