extends Enchantment

class_name DamageEnchantment

func on_apply(target: Enchantable):
	if target.has_method("increase_damage"):
		target.increase_damage(enchantment_boost)

func on_remove(target: Enchantable):
	if target.has_method("increase_damage"):
		target.increase_damage(-enchantment_boost)
