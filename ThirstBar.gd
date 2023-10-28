extends Node2D

@onready var progress_bar = $ProgressBar
@onready var timer = $Timer

@export var thirst_tickrate = Game.THIRST_RATE_REGULAR

func _ready():
	Game.connect("thirst_changed", _thirst_changed)
	Game.connect("season_changed", _season_changed)

	progress_bar.max_value = Game.MAX_THIRST
	progress_bar.value = Game.thirst_level

	timer.wait_time = thirst_tickrate
	timer.start()


func _thirst_changed(thirst_level):
	progress_bar.value = thirst_level

func _season_changed(season):
	match season:
		Game.Season.SUMMER: thirst_tickrate = Game.THIRST_RATE_SUMMER
		_: thirst_tickrate = Game.THIRST_RATE_REGULAR

func _on_timer_timeout():
	Game.dec_thirst()
