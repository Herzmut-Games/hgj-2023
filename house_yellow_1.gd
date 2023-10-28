extends StaticBody2D

@onready var winter_sprite = $Winter
@onready var normal_sprite = $Normal
@onready var building_sprite = $Building

@export var required_wood = 5
@export var required_stone = 0

func _ready():
	# State at game start
	winter_sprite.visible = false
	normal_sprite.visible = false
	building_sprite.visible = true

func _process(_delta):
	if Game.has_house:
		_set_season_sprite()


func interact(_area):
	var required_resources = {
		Game.Items.WOOD: required_wood,
		Game.Items.STONE: required_stone
	}

	if not Game.has_house and Game.has_items(required_resources):
		Game.dec_items(required_resources)

		Game.has_house = true
		building_sprite.visible = false

func _set_season_sprite():
	winter_sprite.visible = Game.season == Game.Season.WINTER
	normal_sprite.visible = Game.season != Game.Season.WINTER
