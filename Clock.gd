extends Node2D

@onready var seasons = $Seasons
@onready var season_label = $Label

const ROTATION_SPEED = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_season_progress(delta)

func _season_progress(delta):
	seasons.rotation_degrees -= ROTATION_SPEED * delta

	var rot = -1 * int(rad_to_deg( seasons.get_rotation())- 45.0) % 360
	var next_season

	if rot >= 0 and rot < 90:
		next_season = Game.Season.SPRING
	elif rot >= 90 and rot < 180:
		next_season = Game.Season.SUMMER
	elif rot >= 180 and rot < 270:
		next_season = Game.Season.FALL
	elif rot >= 270 and rot < 360:
		next_season = Game.Season.WINTER

	Game.set_season(next_season)
	season_label.text = _get_season_name(next_season)

func _get_season_name(season):
	match season:
		Game.Season.SPRING: return "Frühling"
		Game.Season.SUMMER: return "Sommer"
		Game.Season.FALL: return "Herbst"
		Game.Season.WINTER: return "Winter"
