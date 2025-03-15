extends Resource

class_name Enchantment

@export var enchantment_name: String = "Unknown Enchantment"
@export var enchantment_boost: float

func on_apply(target: Enchantable):
	print(target.name, " enchanted with ", enchantment_name)

func on_update(target: Enchantable, delta: float):
	pass  # Override this for time-based effects

func on_remove(target: Enchantable):
	print(enchantment_name, " removed from ", target.name)
