extends Node2D

@onready var progress_bar = $ProgressBar
@onready var timer = $Timer

@export var hunger_tickrate = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.connect("hunger_changed", _hunger_changed)

	timer.wait_time = hunger_tickrate
	timer.start()

func _hunger_changed(hunger_level):
	progress_bar.value = hunger_level

func _on_timer_timeout():
	Game.dec_hunger()

