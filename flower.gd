extends Node2D

var colors = ["black", "yellow", "red", "purple", "white", "blue"]
@onready var anim_sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	var color = colors[randi() % colors.size()]
	anim_sprite.animation = color
	Game.connect("thunderstorm_started", thunderstorm_started)
	Game.connect("season_changed", season_changed)

func thunderstorm_started():
	anim_sprite.play()

func season_changed(season):
	anim_sprite.stop()
