extends Node2D

# Settings!
# Spawnrate is the probability that an item is harvested.
var spawnrate = 0.5
# Seasons the item is active.
var seasonsActive = [Game.Season.SPRING, Game.Season.SUMMER, Game.Season.FALL, Game.Season.WINTER]
# Season textures.
var textures = {
	0: Game.tree0,
	1: Game.tree1,
	2: Game.tree2,
	3: Game.tree3
}

# State!
@export var season = Game.Season.SPRING
# Harvestable determines if the item currently can be harvested.
var harvestable = true

@onready var texture = get_node("texture")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update harvestable to current season.
	_update_season(Game.season)

func _on_klick():
	randomize()
	var randVal = randf_range(0.0, 1.0)
	if randVal > spawnrate:
		# no harvest, return early
		return

	# TODO trigger a harvest/drop.

# _update_season sets the items season.
func _update_season(newSeason):
	if season == newSeason:
		return

	# Update harvestable state.
	if season not in seasonsActive:
		harvestable = false
	else:
		harvestable = true

	# Update item texture.
	texture.set_texture(textures[newSeason])

	season = newSeason
