extends Node2D

func interact(_area):
	if not Game.water_info_seen:
		Game.water_info_seen = true
		Game.send_notify("Nicht das beste, aber immerhin nicht so kalkig wie in München.")
		pass

	Game.inc_thirst()

