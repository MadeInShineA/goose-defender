extends Node2D

signal open_menu

@export_category("Enchants")
@export var player: CharacterBody2D
@export var weapons: Array[Weapon]
@export var enchantments: Dictionary[String, Enchantment]

@export_category("UI")
@export var enchant_ui: Control

var enchantables: Array[Enchantable] = []

func _ready() -> void:
	for enchantable in get_tree().get_nodes_in_group("Enchantable"):
		enchantables.append(enchantable as Enchantable)
		
	enchant()

# Call when interacting with Goose
func enchant():
	open_menu.emit(enchantables, enchantments)
