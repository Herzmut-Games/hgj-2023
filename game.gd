extends Node

enum Season { SPRING, SUMMER, FALL, WINTER }

var season = Season.SPRING
var hunger_level = 10

var hunger_rate = 0.1

var has_house = false

enum Items {
	WOOD, STONE, FOOD
}

var Inventory = {
	Items.WOOD: 0,
	Items.STONE: 0,
	Items.FOOD: 0,
}

# Preloaded sprites.
var tree0 = preload("res://assets/Trees and Bushes/Tree_Dark_2.png")
var tree1 = preload("res://assets/Trees and Bushes/Tree_Light_2.png")
var tree2 = preload("res://assets/Trees and Bushes/Tree_Red_2.png")
var tree3 = preload("res://assets/Trees and Bushes/Tree_Snow_2.png")

signal season_changed
signal inventory_updated

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_tick_hunger(delta)
	pass

func _tick_hunger(delta):
	hunger_level -= hunger_rate * delta
	if hunger_level < 0:
		hunger_level = 0

func set_season(s):
	if season != s:
		season = s
		season_changed.emit(season)

func get_item_name(item):
	if item == Items.WOOD:
		return "Wood"
	elif item == Items.STONE:
		return "Stone"
	elif item == Items.FOOD:
		return "Food"
	else:
		return "Unknown"

func has_item(item, amount):
	return Inventory[item] >= amount

# Takes dictionary of items and amounts
func has_items(req_items):
	for item in req_items:
		if not has_item(item, req_items[item]):
			return false
	return true

func inc_item(item, amount = 1):
	Inventory[item] += amount
	inventory_updated.emit(Inventory)

func dec_item(item, amount = 1):
	if Inventory[item] >= amount:
		Inventory[item] -= amount
		inventory_updated.emit(Inventory)

# Takes dictionary of items and amounts
func dec_items(req_items):
	for item in req_items:
		var amount = req_items[item]
		if Inventory[item] >= amount:
			Inventory[item] -= amount
	inventory_updated.emit(Inventory)
