extends Node2D

@onready var regrow_timer = $RegrowTimer

var WATER_REGROW_WAIT = 1
var scooped = false

# Season textures.
@export var season = Game.Season.SPRING

func _ready():
	regrow_timer.wait_time = WATER_REGROW_WAIT

func _process(delta):
	if regrow_timer.is_stopped():
		regrow_timer.start()
	

func _on_timer_timeout():
	pass

func interact(area):
	if area.is_in_group("player") && !scooped:
		if randf_range(0, 1) > 0.8:
			_scoop()

func _scoop():
	scooped = true
	# TODO add water.
	Game.inc_item(Game.Items.FOOD)

func _grow():
	scooped = false

func _on_regrow_timer_timeout():
	if randf_range(0, 1) < 0.8:
		_grow()
