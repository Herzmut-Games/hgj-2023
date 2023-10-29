extends Node2D

@onready var player = $AudioStreamPlayer

func interact(area):
	if not Game.water_info_seen && area.is_in_group("player"):
		Game.water_info_seen = true
		Game.send_notify("Nicht das beste, aber immerhin nicht so kalkig wie in München.")
		return

	player.play()
	Game.inc_thirst()

