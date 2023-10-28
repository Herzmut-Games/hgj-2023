extends StaticBody2D

@onready var regrow_timer = $RegrowTimer
@onready var texture = $texture
@onready var stump = $Stump

var IRON_REGROW_WAIT = 1
var mined = false

# Season textures.
@export var season = Game.Season.SPRING

func _ready():
	regrow_timer.wait_time = IRON_REGROW_WAIT

func _process(delta):
	_update_season(Game.season)
	if mined:
		stump.visible = true
	else:
		stump.visible = false

# _update_season sets the items season.
func _update_season(newSeason):
	if season == newSeason:
		return

	if regrow_timer.is_stopped():
		regrow_timer.start()

	season = newSeason

func _shake():
	var tween = get_tree().create_tween()
	var pos = self.position
	self.position.x += 1.5
	self.position.y += 1.2
	tween.tween_property(self, "position", pos, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.play()

func interact(area):
	# TODO only with correct tool!
	if area.is_in_group("player") && !mined:
		_shake()
		if randf_range(0, 1) > 0.9:
			_mine()

func _mine():
	mined = true
	Game.inc_item(Game.Items.IRON)

func _grow():
	mined = false

func _on_regrow_timer_timeout():
	if randf_range(0, 1) < 0.05:
		_grow()
