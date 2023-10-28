extends StaticBody2D

@onready var required_resources = $RequiredResources

func _ready():
	required_resources.set_required({
		Game.Items.FOOD: 1
	})

func interact(area):
	if area.is_in_group("player"):
		if Game.has_item(Game.Items.FOOD, 1):
			Game.dec_item(Game.Items.FOOD)
			Game.inc_hunger()
