extends Node2D

var seasons
const ROTATION_SPEED = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	seasons = get_node("Seasons")

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_season_progress(delta)
	pass

func _season_progress(delta):
	seasons.rotation_degrees -= ROTATION_SPEED * delta

	var rot = -1 * int(rad_to_deg( seasons.get_rotation())- 45.0) % 360


	if rot >= 0 and rot < 90:
		Game.set_season(Game.Season.SPRING)
	elif rot >= 90 and rot < 180:
		Game.set_season(Game.Season.SUMMER)
	elif rot >= 180 and rot < 270:
		Game.set_season(Game.Season.FALL)
	elif rot >= 270 and rot < 360:
		Game.set_season(Game.Season.WINTER)

	pass
