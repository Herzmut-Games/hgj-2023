extends Node2D

var progress_bar

@export var hunger_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = get_node("ProgressBar")
	hunger_level = Game.hunger_level
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_check_hunger()
	pass

func _check_hunger():
	hunger_level = Game.hunger_level
	progress_bar.value = hunger_level
