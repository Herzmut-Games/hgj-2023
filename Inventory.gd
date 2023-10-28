extends Node2D

var item_list

var log_sprite = preload("res://assets/Props/Logs_1.png")
var food_sprite = preload("res://assets/Props/Plant_Pumpkin.png")
var stone_sprite = preload("res://assets/Rocks/Rock_Brown_4.png")
var water_sprite = preload("res://assets/Props/Barrel_3.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	item_list = get_node("Control/ItemList")
	Game.connect("inventory_updated", _render_items)
	_render_items(Game.Inventory)

func _render_items(items):
	item_list.clear()

	for i in items.keys():
		var item_name = i
		var amount = str(items[i])
		var icon

		match item_name:
			Game.Items.WOOD:
				icon = log_sprite
			Game.Items.STONE:
				icon = stone_sprite
			Game.Items.FOOD:
				icon = food_sprite
			Game.Items.WATER:
				icon = water_sprite

		item_list.add_item(Game.get_item_name(item_name) + ": " + amount, icon, false)
