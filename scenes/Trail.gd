extends Line2D

var point

func _ready():
	set_as_toplevel(true)
	
func restart(_visible):
	visible = _visible
	if !_visible:
		clear_points()
	
func _physics_process(delta):
	if visible:
		point = get_parent().global_position
		add_point(point)
		if points.size() > 40:
			remove_point(0)
	else:
		clear_points()
