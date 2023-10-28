extends Node2D

@onready var small_plants = $SmallPlants
@onready var medium_plants = $MediumPlants
@onready var large_plants = $LargePlants

var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.connect("season_changed", _season_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_draw_plants()

func interact(area):
	if Game.season != Game.Season.WINTER && state == 0:
		state += 1
	if Game.season == Game.Season.FALL && state == 3:
		state = 0

		match Game.use_tool():
			true: Game.inc_item(Game.Items.FOOD, 10)
			false: Game.inc_item(Game.Items.FOOD, 5)


func _season_changed(season):
	if Game.season != Game.Season.WINTER && state != 0:
		state += 1
	elif Game.season == Game.Season.WINTER:
		state = 0

func _draw_plants():
	if state == 0:
		_show_no_plants()
	elif state == 1:
		_show_small_plants()
	elif state == 2:
		_show_medium_plants()
	elif state == 3:
		_show_large_plants()

func _show_no_plants():
	for i in small_plants.get_children():
		i.visible = false
	for i in medium_plants.get_children():
		i.visible = false
	for i in large_plants.get_children():
		i.visible = false

func _show_small_plants():
	for i in small_plants.get_children():
		i.visible = true
	for i in medium_plants.get_children():
		i.visible = false
	for i in large_plants.get_children():
		i.visible = false

func _show_medium_plants():
	for i in small_plants.get_children():
		i.visible = false
	for i in medium_plants.get_children():
		i.visible = true
	for i in large_plants.get_children():
		i.visible = false

func _show_large_plants():
	for i in small_plants.get_children():
		i.visible = false
	for i in medium_plants.get_children():
		i.visible = false
	for i in large_plants.get_children():
		i.visible = true
