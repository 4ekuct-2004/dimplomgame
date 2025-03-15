extends Node2D

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://locations/main_game/main.tscn")


func _on_settings_pressed() -> void:
	pass 


func _on_exit_pressed() -> void:
	get_tree().quit()
