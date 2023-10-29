extends Control

@onready var item_list = $ItemList

var log_sprite = preload("res://assets/Props/Logs_1.png")
var food_sprite = preload("res://assets/Props/Plant_Pumpkin.png")
var stone_sprite = preload("res://assets/Rocks/Rock_Brown_4.png")
var iron_sprite = preload("res://assets/Rocks/Rock_Gray_4.png")

var bobble_distance = 10

# Takes dictionary
func set_required(items):
	item_list.clear()

	for key in items.keys():
		var amount = items[key]
		var icon

		match key:
			Game.Items.WOOD:
				icon = log_sprite
			Game.Items.STONE:
				icon = stone_sprite
			Game.Items.FOOD:
				icon = food_sprite

		item_list.add_item(str(amount), icon, false)

func set_required_icons(items):
	item_list.clear()

	for item in items:
		var icon

		match item:
			Game.Items.WOOD:
				icon = log_sprite
			Game.Items.STONE:
				icon = stone_sprite
			Game.Items.FOOD:
				icon = food_sprite
			Game.Items.IRON:
				icon = iron_sprite

		item_list.add_icon_item(icon, false)
