extends Control

@onready var item_list = $ItemList

var log_sprite = preload("res://assets/Props/Logs_1.png")
var food_sprite = preload("res://assets/Props/Plant_Pumpkin.png")
var stone_sprite = preload("res://assets/Rocks/Rock_Brown_4.png")

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
