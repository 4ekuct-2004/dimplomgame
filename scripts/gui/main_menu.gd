extends Node2D

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://debug/full/main.tscn")


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
