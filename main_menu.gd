extends Control

@onready var visuals = $Panel/CheckBox


func _on_button_pressed():
	get_tree().change_scene_to_file("res://level.tscn")


func _on_check_box_toggled(button_pressed):
	Game.reduced_visuals = button_pressed
