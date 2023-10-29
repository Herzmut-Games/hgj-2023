extends StaticBody2D

@onready var texture = $texture

var info_seen = false

func _shake():
	var tween = get_tree().create_tween()
	var pos = self.position
	self.position.x += 1.5
	self.position.y += 1.2
	tween.tween_property(self, "position", pos, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.play()

func interact(_area):
	if not info_seen and not Game.tools_unlocked:
		info_seen = true
		Game.send_notify("Mit dem richtigen Werkzeug könnte ich vielleicht etwas Eisen abbauen")
		return

	if Game.use_tool():
		_shake()
		Game.inc_item(Game.Items.IRON)
