extends Node

@onready var blink_timer = $blinkerTimer
@onready var duration_timer = $durationTimer
var blink_object: Node2D

func start_blinking(object, duration):
	blink_object = object
	duration_timer.wait_time = duration
	duration_timer.start()
	blink_timer.start()


func _on_blinker_timer_timeout() -> void:
	blink_object.visible = !blink_object.visible


func _on_duration_timer_timeout() -> void:
	blink_timer.stop()
	blink_object.visible = true
