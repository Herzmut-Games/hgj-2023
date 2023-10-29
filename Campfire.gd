extends StaticBody2D

@onready var required_resources = $RequiredResources
@onready var player = $EatPlayer

var seen_info = false

func _ready():
	required_resources.set_required_icons({
		Game.Items.FOOD: 1
	})

func interact(_area):
	if not seen_info:
		seen_info = true
		Game.send_notify("Gegrillter Kürbis ist mein Leibgericht")
		return

	var diff = Game.MAX_HUNGER - Game.hunger_level

	if Game.has_item(Game.Items.FOOD, diff):
		Game.dec_item(Game.Items.FOOD, diff)
		Game.inc_hunger(diff)
		player.play()
	else:
		var curr = Game.get_item_count(Game.Items.FOOD)
		Game.dec_item(Game.Items.FOOD, curr)
		Game.inc_hunger(curr)
		if curr > 0:
			player.play()
