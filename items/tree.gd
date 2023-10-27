extends StaticBody2D

@onready var timer = $Timer

# Season textures.
@export var season = Game.Season.SPRING
var textures = {
	0: Game.tree0,
	1: Game.tree1,
	2: Game.tree2,
	3: Game.tree3
}

@onready var texture = get_node("texture")

func _process(delta):
	_update_season(Game.season)

# _update_season sets the items season.
func _update_season(newSeason):
	if season == newSeason:
		return

	# Update item texture.
	timer.wait_time = randf_range(0, 5)
	timer.start()


	season = newSeason


func _on_timer_timeout():
	texture.set_texture(textures[Game.season])
