extends StaticBody2D

@onready var required_resources = $RequiredResources

@export var required_build = {
	Game.Items.WOOD: 10,
	Game.Items.STONE: 10,
}

@export var required_use = {
	Game.Items.STONE: Game.TOOLS_PRICE
}

var seen_info = false

func _ready():
	required_resources.set_required(required_build)

func interact(_area):
	if not seen_info:
		seen_info = true
		Game.send_notify("Mit ein paar Werkzeugen wäre ich vermutlich effizienter")

	if not Game.tools_unlocked and Game.has_items(required_build):
		Game.dec_items(required_build)
		Game.tools_unlocked = true
		Game.add_tools()
		required_resources.set_required(required_use)
	elif Game.tools_unlocked and Game.has_items(required_use):
		Game.dec_items(required_use)
		Game.add_tools()
