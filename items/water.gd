extends Node2D

func interact(area):
	if not Game.water_info_seen && area.is_in_group("player"):
		Game.water_info_seen = true
		Game.send_notify("Nicht das beste, aber immerhin nicht so kalkig wie in München.")
		return

	Game.inc_thirst()

