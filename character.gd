extends Node2D

@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = load("res://projectile.tscn")
	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed:
		print("Mouse Click/Unclick at: ", event.position)
		shoot(global_position.angle_to_point(event.position))

func shoot(direction: float):
	var instance = projectile.instantiate()
	instance.direction = direction
	instance.spawn_position = global_position
	instance.spawn_rotation = direction
	main.add_child.call_deferred(instance)
	
func _physics_process(delta: float) -> void:
	pass
	#rotation_degrees += 50 * delta
