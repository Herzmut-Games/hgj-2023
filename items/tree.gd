extends StaticBody2D

@onready var timer = $Timer
@onready var texture = $texture
@onready var stump = $Stump


var chopped = false

# Season textures.
@export var season = Game.Season.SPRING
var textures = {
	0: Game.tree0,
	1: Game.tree1,
	2: Game.tree2,
	3: Game.tree3
}

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
	timer.wait_time = randf_range(0, 5)
	timer.start()


	season = newSeason
	
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
			chopped = true

func _on_timer_timeout():
	texture.set_texture(textures[Game.season])
