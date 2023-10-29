extends Control

@onready var death_text: Label = $Panel/DeathText

# Called when the node enters the scene tree for the first time.
func _ready():
	death_text.text = _get_death_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://level.tscn")

func _get_death_text():
	match Game.death_by:
		Game.DeathReason.HUNGER: return "Du bist verhungert. Iss vielleicht nächstes mal was."
		Game.DeathReason.THIRST: return "Trink zwischendurch mal nen Schluck Wasser."
		Game.DeathReason.FREEZE_HOUSE: return "Im Winter draußen schlafen ist auch ein bisschen unangenehm."
		Game.DeathReason.FREEZE_FUEL: return "Ein Kamin befeuert sich auch nicht von selbst, guck dass in Herbst und Winter Holz da ist."
		_: return "Du bist gestorben. Keine Ahnung warum. Vermutlich ein Bug, mach vielleicht mal ein Ticket auf."
