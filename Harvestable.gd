extends Node2D

# harvestable determines if the item currently can be harvested.
var harvestable = true
# spawnrate is the probability that an item is harvested.
var spawnrate = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_klick():
	randomize()
	var randVal = randf_range(0.0, 1.0)
	if randVal > spawnrate:
		# no harvest, return early
		return
		
	# TODO trigger a harvest/drop.
