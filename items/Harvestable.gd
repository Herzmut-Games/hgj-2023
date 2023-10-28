extends Node2D

# Settings!
# Spawnrate is the probability that an item is harvested.
var spawnrate = 0.5
# Seasons the item is active.
var seasonsActive = [Game.Season.SPRING, Game.Season.SUMMER, Game.Season.FALL, Game.Season.WINTER]

# State!
# Harvestable determines if the item currently can be harvested.
var harvestable = true

@export var season = Game.Season.SPRING

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	_update_season(Game.season)

# _update_season sets the items season.
func _update_season(newSeason):
	if season == newSeason:
		return

	season = newSeason

	# Update harvestable state.
	if season not in seasonsActive:
		harvestable = false
	else:
		harvestable = true


func _on_klick():
	randomize()
	var randVal = randf_range(0.0, 1.0)
	if randVal > spawnrate:
		# no harvest, return early
		return

	# TODO trigger a harvest/drop.

