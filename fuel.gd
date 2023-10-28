extends StaticBody2D

var log_sprite = preload("res://assets/Props/Logs_1.png")

@onready var fuel_tick = $FuelTick
@onready var progress = $ProgressBar
@onready var fuel_display = $FuelDisplay

const STATE_MAX = 5

@export var tickrate = 5
@export var state = STATE_MAX


# Called when the node enters the scene tree for the first time.
func _ready():
	fuel_tick.set_wait_time(tickrate)
	fuel_tick.stop()

	progress.max_value = STATE_MAX
	progress.value = STATE_MAX
	_update_fuel_display(Game.fuel_left)

	Game.connect("season_changed", _on_season_changed)
	Game.connect("fuel_changed", _update_fuel_display)

	# Force timer to start if in correct season
	_on_season_changed(Game.season)


func interact(_area):
	if Game.has_item(Game.Items.WOOD, 1):
		Game.dec_item(Game.Items.WOOD)
		Game.add_fuel()

func _on_season_changed(season):
	if Game.house_level < 2:
		return

	match season:
		Game.Season.SPRING:
			fuel_tick.stop()
		Game.Season.FALL:
			fuel_tick.start()

func _on_fuel_tick_timeout():
	_tick_state()

	if state <= 0:
		state = STATE_MAX
		progress.value = STATE_MAX

		Game.burn_fuel()


func _tick_state():
	state -= 1
	progress.value = state

func _update_fuel_display(fuel):
	fuel_display.clear()
	fuel_display.add_item(str(fuel), log_sprite, false)
