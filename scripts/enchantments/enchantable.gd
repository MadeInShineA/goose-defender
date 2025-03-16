extends Node2D

class_name Enchantable

@export var enchantable_name: String
@export var enchantment_texture: Texture2D
@export var enchantments: Array[Enchantment] = []

var is_unlocked: bool = false

func apply_enchantment(enchantment: Enchantment):
	if enchantment not in enchantments:
		enchantments.append(enchantment)
		enchantment.on_apply(self)
		
func update_enchantments(delta: float):
	for enchantment in enchantments:
		enchantment.on_update(self, delta)
