extends Node2D

var item_list

var log_sprite = preload("res://assets/Props/Logs_1.png")
var food_sprite = preload("res://assets/Props/HayStack_1.png")
var stone_sprite = preload("res://assets/Rocks/Rock_Brown_4.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	item_list = get_node("Control/ItemList")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_render_items()
	pass

func _render_items():
	item_list.clear()

	for i in Game.items.keys():
		var item_name = i
		var amount = str(Game.items.get(i))
		var icon

		match item_name:
			Game.Items.WOOD:
				icon = log_sprite
			Game.Items.STONE:
				icon = stone_sprite
			Game.Items.FOOD:
				icon = food_sprite

		item_list.add_item(Game.get_item_name(item_name) + ": " + amount, icon, false)
