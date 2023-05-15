extends Node2D
export var _CarObj: NodePath
onready var CarObj : Node2D = get_node(_CarObj) as Node2D
var player_num = ""
var randomizing = 0
var randomizing_total = 1.2
var random_item = -1

func _ready():
	$lbl_turbo.add_color_override("font_color", Color8(100, 100, 100))
	$background.color = CarObj.color
	player_num = CarObj.player_num
	if player_num == "p1":
		if Global.CAR_AVATAR1 != -1:
			$lbl_playername.text = Global.CAR_NAME1
			$avatar.visible = true
			$avatar.frame = Global.CAR_AVATAR1
	if player_num == "p2":
		if Global.CAR_AVATAR2 != -1:
			$lbl_playername.text = Global.CAR_NAME2
			$avatar.visible = true
			$avatar.frame = Global.CAR_AVATAR2
	if player_num == "p3":
		if Global.CAR_AVATAR3 != -1:
			$lbl_playername.text = Global.CAR_NAME3
			$avatar.visible = true
			$avatar.frame = Global.CAR_AVATAR3
	if player_num == "p4":
		if Global.CAR_AVATAR4 != -1:
			$lbl_playername.text = Global.CAR_NAME4
			$avatar.visible = true
			$avatar.frame = Global.CAR_AVATAR4

func _physics_process(delta):
	if is_instance_valid(CarObj):
		if CarObj.engine_boost > 0 or CarObj.boosts > 0:
			var R = randi() % 256
			var G = randi() % 256
			var B = randi() % 256
			$lbl_turbo.add_color_override("font_color", Color8(R, G, B))
		else:
			$lbl_turbo.add_color_override("font_color", Color8(100, 100, 100))
		
		if CarObj.item == "randomize" and !$item.playing:
			randomizing = randomizing_total
			random_item = -1
			$item.playing = true
			
		if $item.playing:
			randomizing -= 1 * delta
			if randomizing <= 0:
				randomizing = randomizing_total
				random_item = -1
				$item.playing = false
				$item.frame = Global.pick_random([1, 2, 3])
				CarObj.set_item($item.frame)
		
		$speed.text = str(round(CarObj.velocity.length()))
		$tires_bar.rect_size.x = CarObj.tires
