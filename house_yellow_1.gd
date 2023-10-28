extends StaticBody2D

@onready var building_sprite = $Building

@onready var level_1_normal_sprite = $Level1Normal
@onready var level_1_winter_sprite = $Level1Winter

@onready var level_2_normal_sprite = $Level2Normal
@onready var level_2_winter_sprite = $Level2Winter
@onready var level_2_collision = $Level2Collision

@onready var level_3_normal_sprite = $Level3Normal
@onready var level_3_winter_sprite = $Level3Winter
@onready var level_3_collision = $Level3Collision

@onready var required_tooltip = $RequiredResources

@export var level_one_resources = {
	Game.Items.WOOD: 1,
}

@export var level_two_resources = {
	Game.Items.WOOD: 2,
	Game.Items.STONE: 1
}

@export var level_three_resources = {
	Game.Items.WOOD: 3,
	Game.Items.STONE: 2,
	Game.Items.IRON: 1
}

func _ready():
	# State at game start, for sanity
	_hide_all_sprites()
	_set_collision()

	building_sprite.visible = true
	required_tooltip.visible = true

	required_tooltip.set_required(_get_required_items())

	Game.connect("season_changed", _season_changed)

func interact(_area):
	if Game.house_level >= 3:
		return

	var required_resources = _get_required_items()

	if Game.has_items(required_resources):
		Game.dec_items(required_resources)
		Game.house_level += 1

		if Game.house_level < 3:
			required_tooltip.set_required(_get_required_items())
		else:
			required_tooltip.visible = false

		# rerender house
		_season_changed(Game.season)

func _season_changed(season):
	# Normalize, don't care about state
	_hide_all_sprites()
	_set_collision()

	match season:
		Game.Season.WINTER:
			match Game.house_level:
				0: building_sprite.visible = true
				1: level_1_winter_sprite.visible = true
				2: level_2_winter_sprite.visible = true
				3: level_3_winter_sprite.visible = true
				_: pass
		_:
			match Game.house_level:
				0: building_sprite.visible = true
				1: level_1_normal_sprite.visible = true
				2: level_2_normal_sprite.visible = true
				3: level_3_normal_sprite.visible = true
				_: pass

func _hide_all_sprites():
	building_sprite.visible = false

	level_1_normal_sprite.visible = false
	level_1_winter_sprite.visible = false

	level_2_normal_sprite.visible = false
	level_2_winter_sprite.visible = false

	level_3_normal_sprite.visible = false
	level_3_winter_sprite.visible = false

func _set_collision():
	# normalize
	level_2_collision.disabled = true
	level_3_collision.disabled = true

	if Game.house_level > 1:
		level_2_collision.disabled = false

	if Game.house_level > 2:
		level_3_collision.disabled = false

func _get_required_items():
	match Game.house_level:
		0: return level_one_resources
		1: return level_two_resources
		2: return level_three_resources
		_: return {}
