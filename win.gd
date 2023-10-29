extends Control

func _on_button_pressed():
	Game.clear_state()
	get_tree().change_scene_to_file("res://level.tscn")
