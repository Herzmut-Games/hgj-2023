extends StaticBody2D

func interact(area):
	if area.is_in_group("player"):
		if Game.items[Game.Items.FOOD] > 0:
			Game.dec_item(Game.Items.FOOD)
			Game.inc_hunger()
