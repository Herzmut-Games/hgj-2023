extends StaticBody2D

func interact(area):
	if area.is_in_group("player"):
		if Game.has_item(Game.Items.FOOD, 1):
			Game.dec_item(Game.Items.FOOD)
			Game.inc_hunger()
