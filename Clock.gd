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
