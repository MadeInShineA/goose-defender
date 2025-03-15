extends Node2D

const PROJECTILE = preload("res://projectile.tscn")
@onready var fire_point: Marker2D = $Marker2D

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())	
	"""
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	"""
	if Input.is_action_just_pressed("fire"):
		var projectile_instance = PROJECTILE.instantiate()
		get_tree().root.add_child(projectile_instance)
		projectile_instance.global_position = fire_point.global_position
		projectile_instance.rotation = rotation
		
	
