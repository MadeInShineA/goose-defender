extends Node

class_name Enchantable

@export var enchantable_name: String
@export var enchantment_texture: Texture2D
@export var enchantments: Array[Enchantment] = []

func apply_enchantment(enchantment: Enchantment):
	if enchantment not in enchantments:
		enchantments.append(enchantment)
		enchantment.on_apply(self)
		
func update_enchantments(delta: float):
	for enchantment in enchantments:
		enchantment.on_update(self, delta)
