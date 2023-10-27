extends Node2D

var seasons
const ROTATION_SPEED = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	seasons = get_node("Seasons")

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	seasons.set_rotation(seasons.get_rotation() - ROTATION_SPEED * delta)
	pass

func _season_progress(delta):
	seasons.set_rotation(seasons.get_rotation() - ROTATION_SPEED * delta)

	var rot = seasons.get_rotation()

	if rot >= 0 and rot < 90:
		Game.set_season(Game.Season.SPRING)
	elif rot >= 90 and rot < 180:
		Game.set_season(Game.Season.SUMMER)
	elif rot >= 180 and rot < 270:
		Game.set_season(Game.Season.FALL)
	elif rot >= 270 and rot < 360:
		Game.set_season(Game.Season.WINTER)

	pass
