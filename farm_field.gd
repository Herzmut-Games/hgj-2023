extends Node2D

@onready var small_plants = $SmallPlants
@onready var medium_plants = $MediumPlants
@onready var large_plants = $LargePlants

var state = 0

var seen_info = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.connect("season_changed", _season_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_draw_plants()

func interact(_area):
	if not seen_info:
		seen_info = true
		Game.send_notify("Hier könnte man etwas anbauen, ich glaube aber nicht dass irgendeine Pflanze den Winter überleben würde.")

	if Game.season != Game.Season.WINTER && state == 0:
		state += 1
	if Game.season == Game.Season.FALL && state == 3:
		state = 0

		match Game.use_tool():
			true: Game.inc_item(Game.Items.FOOD, Game.HARVEST_AMOUNT * 2)
			false: Game.inc_item(Game.Items.FOOD, Game.HARVEST_AMOUNT)


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
