extends Node2D

signal open_menu

@export_category("Enchantables")
@export var enchantments: Dictionary[String, Enchantment]

@export_category("UI")
@export var enchant_ui: Control

var enchantables: Array[Enchantable] = []

func _ready() -> void:
	for enchantable in get_tree().get_nodes_in_group("Enchantable"):
		enchantables.append(enchantable as Enchantable)

# Call when interacting with Goose
func enchant():
	open_menu.emit(enchantables, enchantments)
	get_tree().paused = true
	
func _on_goose_interacted_with() -> void:
	enchant()
