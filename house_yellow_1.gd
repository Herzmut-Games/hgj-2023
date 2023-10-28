extends StaticBody2D

@onready var winter_sprite = $Winter

func _ready():
	self.visible = false

func _process(_delta):
	winter_sprite.visible = Game.season == Game.Season.WINTER

	if Game.has_house:
		self.visible = true


