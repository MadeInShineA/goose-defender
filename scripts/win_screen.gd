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
	get_tree().quit()

func _on_won_game() -> void:
	get_tree().paused = true
	blur.show()
	show()
