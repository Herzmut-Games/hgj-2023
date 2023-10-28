extends Node

enum Season { SPRING, SUMMER, FALL, WINTER }

const MAX_HUNGER = 10
const MAX_THIRST = 20
const MAX_TOOLS = 8

var season = Season.SPRING
var hunger_level = MAX_HUNGER
var thirst_level = MAX_THIRST
var house_level = 0
var fuel_left = 5

var tools = 0
var tools_unlocked = false

enum Items {
	WOOD, STONE, IRON, FOOD
}

var Inventory = {
	Items.WOOD: 0,
	Items.STONE: 0,
	Items.IRON: 0,
	Items.FOOD: 0,
}

# Preloaded sprites.
var tree0 = preload("res://assets/Trees and Bushes/Tree_Dark_2.png")
var tree1 = preload("res://assets/Trees and Bushes/Tree_Light_2.png")
var tree2 = preload("res://assets/Trees and Bushes/Tree_Red_2.png")
var tree3 = preload("res://assets/Trees and Bushes/Tree_Snow_2.png")

signal season_changed
signal fuel_changed
signal hunger_changed
signal thirst_changed
signal tools_changed
signal inventory_updated

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("season_changed", _season_changed)
	self.connect("fuel_changed", _fuel_changed)

func dec_thirst():
	thirst_level -= 1

	thirst_changed.emit(thirst_level)

	if thirst_level < 0:
		thirst_level = 0
		end_game()

func inc_thirst():
	thirst_level = MAX_THIRST
	thirst_changed.emit(thirst_level)

func dec_hunger():
	hunger_level -= 1

	hunger_changed.emit(hunger_level)

	if hunger_level < 0:
		hunger_level = 0
		end_game()

func inc_hunger():
	hunger_level += 1

	if hunger_level > MAX_HUNGER:
		hunger_level = MAX_HUNGER

	hunger_changed.emit(hunger_level)

func _fuel_changed(new_fuel):
	if new_fuel == 0 and season == Game.Season.WINTER or season == Game.Season.FALL:
		end_game()

func _season_changed(new_season):
	match new_season:
		Game.Season.WINTER:
			if house_level < 1:
				end_game()
			elif fuel_left == 0:
				end_game()
		Game.Season.FALL:
			if fuel_left == 0:
				end_game()

func set_season(s):
	if season != s:
		season = s
		season_changed.emit(season)

func get_item_name(item):
	match item:
		Items.WOOD: 	return "Holz"
		Items.STONE: 	return "Steine"
		Items.FOOD: 	return "Essen"
		Items.IRON: 	return "Eisen"
		_: 				return "Unknown"

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

func add_fuel():
	fuel_left += 1
	fuel_changed.emit(fuel_left)

func burn_fuel():
	if fuel_left > 0:
		fuel_left -= 1
		fuel_changed.emit(fuel_left)

func use_tool():
	if tools_unlocked and tools > 0:
		tools -= 1
		tools_changed.emit(tools)
		return true
	return false

func add_tools():
	tools += 3
	if tools > MAX_TOOLS:
		tools = MAX_TOOLS

	tools_changed.emit(tools)

func unlock_tools():
	tools_unlocked = true
	tools_changed.emit(tools)

func end_game():
	get_tree().change_scene_to_file("res://end.tscn")
