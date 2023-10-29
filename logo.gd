extends Control

func _on_timer_timeout():
	$Label.visible = true


func _on_timer_2_timeout():
	Audioplayer.play()
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_timer_3_timeout():
	$AudioStreamPlayer.play()
