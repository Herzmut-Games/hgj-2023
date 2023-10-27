extends StaticBody2D

@onready var winter_sprite = $Winter

func _process(_delta):
	winter_sprite.visible = Game.season == Game.Season.WINTER
