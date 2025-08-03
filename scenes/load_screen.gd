extends Control

const WORLD = preload("res://scenes/world.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)
