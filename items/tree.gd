extends StaticBody2D

@onready var season_swap_timer = $SeasonSwapTimer
@onready var regrow_timer = $RegrowTimer
@onready var texture = $texture
@onready var stump = $Stump

var TREE_REGROW_WAIT = 1
var chopped = false

# Season textures.
@export var season = Game.Season.SPRING
var textures = {
	0: Game.tree0,
	1: Game.tree1,
	2: Game.tree2,
	3: Game.tree3
}

func _ready():
	regrow_timer.wait_time = TREE_REGROW_WAIT

func _process(delta):
	_update_season(Game.season)
	if chopped:
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
	season_swap_timer.wait_time = randf_range(0, 5)
	season_swap_timer.start()
	
	if newSeason != Game.Season.SPRING:
		regrow_timer.stop()
	else:
		regrow_timer.start()


	season = newSeason

func _chop():
	chopped = true
	Game.inc_item(Game.Items.WOOD)

func _grow():
	chopped = false

func _shake():
	var tween = get_tree().create_tween()
	var pos = self.position
	self.position.x += 1.5
	self.position.y += 1.5
	tween.tween_property(self, "position", pos, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.play()

func interact(area):
	if area.is_in_group("player") && !chopped:
		_shake()
		if randf_range(0, 1) > 0.5:
			_chop()

func _on_timer_timeout():
	texture.set_texture(textures[Game.season])


func _on_regrow_timer_timeout():
	if randf_range(0, 1) < 0.2:
		_grow()
