extends Node2D
var ttl_total = 0.1
var ttl = 0

func random_color():
	var color1 = Color8(233, 136, 250)
	var color2 = Color8(73, 164, 255)
	var color3 = Color8(240, 196, 253)
	var color4 = Color8(102, 242, 216)
	var color5 = Color8(255, 255, 255)
	
	return Global.pick_random([color1, color2, color3, color4, color5])

func _physics_process(delta):
	ttl -= 1 * delta
	if ttl <= 0:
		ttl = ttl_total
		$background.color = random_color()
		$Label.add_color_override("font_color", random_color())

func _on_area_body_exited(body):
	if body.is_in_group("cars"):
		body.random_slot_item()
