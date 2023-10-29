extends Node

enum Season { SPRING, SUMMER, FALL, WINTER }

enum DeathReason {
	HUNGER,
	THIRST,
	FREEZE_HOUSE,
	FREEZE_FUEL
}

enum Items {
	WOOD, STONE, IRON, FOOD
}

const MAX_HUNGER = 10
const HARVEST_AMOUNT = 4

const MAX_THIRST = 25
const THIRST_RATE_SUMMER = 2
const THIRST_RATE_REGULAR = 4

const MAX_TOOLS = 10
const TOOLS_PRICE = 3
const TOOLS_AMOUNT = 5

const THUNDERSTORM_CHANCE = 0.5
const COLD_YEARS_START = 2

var season = Season.SPRING
var year = 0

var hunger_level = MAX_HUNGER
var thirst_level = MAX_THIRST
var house_level = 0

const START_FUEL = 5
var fuel_left = START_FUEL

var tools = 0
var tools_unlocked = false

var thunderstorm = false
var reduced_visuals = false

var Inventory = {
	Items.WOOD: 0,
	Items.STONE: 0,
	Items.IRON: 0,
	Items.FOOD: 0,
}

var death_by = null

var stone_info_seen = false
var water_info_seen = false

# Preloaded sprites.
var tree0 = preload("res://assets/Trees and Bushes/Tree_Dark_2.png")
var tree1 = preload("res://assets/Trees and Bushes/Tree_Light_2.png")
var tree2 = preload("res://assets/Trees and Bushes/Tree_Red_2.png")
var tree3 = preload("res://assets/Trees and Bushes/Tree_Snow_2.png")

signal season_changed
signal year_changed
signal fuel_changed
signal hunger_changed
signal thirst_changed
signal tools_changed
signal house_changed
signal inventory_updated
signal notify

func clear_state():
	season = Season.SPRING
	year = 0

	hunger_level = MAX_HUNGER
	thirst_level = MAX_THIRST
	house_level = 0
	fuel_left = START_FUEL

	tools = 0
	tools_unlocked = false

	thunderstorm = false

	Inventory = {
		Items.WOOD: 0,
		Items.STONE: 0,
		Items.IRON: 0,
		Items.FOOD: 0,
	}

	death_by = null

	stone_info_seen = false
	water_info_seen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("season_changed", _season_changed)
	self.connect("fuel_changed", _fuel_changed)
	self.connect("year_changed", _year_changed)
	self.connect("house_changed", _house_changed)


func dec_thirst():
	thirst_level -= 1

	thirst_changed.emit(thirst_level)

	if thirst_level < 0:
		thirst_level = 0
		end_game(DeathReason.THIRST)

func inc_thirst():
	thirst_level = MAX_THIRST
	thirst_changed.emit(thirst_level)

func dec_hunger():
	hunger_level -= 1

	hunger_changed.emit(hunger_level)

	if hunger_level < 0:
		hunger_level = 0
		end_game(DeathReason.HUNGER)

func inc_hunger(amount):
	hunger_level += amount

	if hunger_level > MAX_HUNGER:
		hunger_level = MAX_HUNGER

	hunger_changed.emit(hunger_level)

func _fuel_changed(new_fuel):
	if new_fuel == 0 and (season == Game.Season.WINTER or season == Game.Season.FALL):
		end_game(DeathReason.FREEZE_FUEL)

func _year_changed(new_year):
	match new_year:
		COLD_YEARS_START: if house_level < 2: send_notify("Den Winter hab ich so gerade geschafft, ein Haus mit Kamin brauche ich bis zum Herbst auf jeden Fall...")
		_: if house_level == 3: win_game()

func _house_changed(new_level):
	match new_level:
		2: send_notify("Ist ja eigentlich ganz nett hier, glaube wenn ich das Haus ausbause bin ich hier ganz glücklich")

var summer_info_seen = false

func _season_changed(new_season):
	if randf_range(0, 1) < THUNDERSTORM_CHANCE && new_season != Game.Season.SUMMER:
		thunderstorm = true
	else:
		thunderstorm = false

	match new_season:
		Game.Season.SPRING:
			_bump_year()
			_check_thunderstorm()
		Game.Season.SUMMER:
			# Only good weather during summer
			thunderstorm = false

			if not summer_info_seen:
				send_notify("Wahnsinn wie heiß es hier im Sommer ist, da muss ich dran denken immer genug zu trinken")
				summer_info_seen = true
		Game.Season.WINTER:
			if house_level < 1:
				end_game(DeathReason.FREEZE_HOUSE)
			if year >= COLD_YEARS_START and fuel_left == 0:
				end_game(DeathReason.FREEZE_FUEL)
			_check_thunderstorm()
		Game.Season.FALL:
			if house_level < 1:
				send_notify("Ich glaube der Winter wird kalt...")
			if year >= COLD_YEARS_START and fuel_left == 0:
				end_game(DeathReason.FREEZE_FUEL)
			_check_thunderstorm()

func _check_thunderstorm():
	if randf_range(0, 1) < THUNDERSTORM_CHANCE:
		thunderstorm = true
	else:
		thunderstorm = false

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

func get_item_count(item):
	return Inventory[item]

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
	tools += TOOLS_AMOUNT
	if tools > MAX_TOOLS:
		tools = MAX_TOOLS

	tools_changed.emit(tools)

func unlock_tools():
	tools_unlocked = true
	tools_changed.emit(tools)

func send_notify(text):
	notify.emit(text)

func _bump_year():
	year += 1
	year_changed.emit(year)

func _bump_house():
	house_level += 1
	house_changed.emit(house_level)

func win_game():
	print("juhu")

func end_game(reason):
	death_by = reason
	get_tree().change_scene_to_file("res://end.tscn")
