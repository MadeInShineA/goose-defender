extends Control

var blur: ColorRect

func _ready() -> void:
	blur = get_parent().get_node("Blur")
	hide()
	blur.hide()

func _on_replay_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

#TODO Add signal to show!
