extends Enchantment

class_name SpeedEnchantment

func on_apply(target: Enchantable):
	if target.has_method("increase_attack_speed"):
		target.increase_attack_speed(enchantment_boost)

func on_remove(target: Enchantable):
	if target.has_method("increase_attack_speed"):
		target.increase_attack_speed(-enchantment_boost)
