extends Weapon

class_name RangedWeapon

func attack():
	if can_attack and projectile_scene:
		var projectile_instance = projectile_scene.instantiate()
		get_tree().root.add_child(projectile_instance)
		projectile_instance.global_position = fire_point.global_position
		
		projectile_instance.rotation = get_parent().get_parent().rotation

func _on_attack_timer_timeout() -> void:
	print("TIMEOUT")
	if not can_attack:
		can_attack = true
