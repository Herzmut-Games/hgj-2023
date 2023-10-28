extends Node2D

@onready var progress_bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.max_value = Game.MAX_TOOLS
	# You need to unlock tools
	progress_bar.visible = false

	Game.connect("tools_changed", _on_tools_changed)

func _on_tools_changed(tools):
	# When unlocked, tools emit once
	progress_bar.visible = true

	progress_bar.value = tools
