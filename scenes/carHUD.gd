extends Node2D
export var _CarObj: NodePath
onready var CarObj : Node2D = get_node(_CarObj) as Node2D
var player_num = ""

func _ready():
	$background.color = CarObj.color
	player_num = CarObj.player_num

func _physics_process(delta):
	if is_instance_valid(CarObj):
		$speed.text = str(round(CarObj.velocity.length()))
		$tires_bar.rect_size.x = CarObj.tires
