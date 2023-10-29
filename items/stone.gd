extends StaticBody2D

@onready var season_swap_timer = $SeasonSwapTimer
@onready var regrow_timer = $RegrowTimer
@onready var texture = $texture
@onready var stump = $Stump

var STONE_REGROW_WAIT = 1
var mined = false

# Season textures.
@export var season = Game.Season.SPRING
var textures = {
	0: PreloadAssets.stone0,
	1: PreloadAssets.stone1,
	2: PreloadAssets.stone2,
	3: PreloadAssets.stone3
}

func _ready():
	regrow_timer.wait_time = STONE_REGROW_WAIT

func _process(delta):
	_update_season(Game.season)
	if mined:
		stump.visible = true
		texture.visible = false
	else:
		stump.visible = false
		texture.visible = true

# _update_season sets the items season.
func _update_season(newSeason):
	if season == newSeason:
		return

	# Update item texture.
	season_swap_timer.wait_time = randf_range(0, 3)
	season_swap_timer.start()

	if newSeason != Game.Season.WINTER:
		regrow_timer.stop()
	else:
		regrow_timer.start()

	season = newSeason


func _on_timer_timeout():
	texture.set_texture(textures[Game.season])

func _shake():
	var tween = get_tree().create_tween()
	var pos = self.position
	self.position.x += 1.5
	self.position.y += 1.5
	tween.tween_property(self, "position", pos, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.play()

func interact(area):
	if Game.season == Game.Season.WINTER and not Game.stone_info_seen:
		Game.stone_info_seen = true
		Game.send_notify("Der Stein ist wie gefroren, den bekomm ich nicht kaputt.")
		pass

	if area.is_in_group("player") && !mined && season != Game.Season.WINTER:
		_shake()
		if randf_range(0, 1) > 0.5:
			_mine()

func _mine():
	mined = true

	match Game.use_tool():
		true: Game.inc_item(Game.Items.STONE, 2)
		false: Game.inc_item(Game.Items.STONE)


func _grow():
	mined = false

func _on_regrow_timer_timeout():
	if randf_range(0, 1) < 0.2:
		_grow()
