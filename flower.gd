extends Node2D

var colors = ["black", "yellow", "red", "purple", "white", "blue"]
@onready var anim_sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	var color = colors[randi() % colors.size()]
	anim_sprite.animation = color
	Game.season_changed.connect(season_changed)

func season_changed(_season):
	if Game.thunderstorm:
		anim_sprite.play()
	else:
		anim_sprite.stop()
