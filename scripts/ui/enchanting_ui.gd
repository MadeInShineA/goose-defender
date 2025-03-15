extends Control

signal apply_enchantment

var spell_panels: Array[Panel] = []
# var rng = RandomNumberGenerator.new()
var blur: ColorRect

func _ready() -> void:
	blur = get_parent().get_node("Blur")
	hide()
	blur.hide()
	for spell_panel in get_tree().get_nodes_in_group("SpellPanel"):
		spell_panels.append(spell_panel as Panel)

func _on_enchant_manager_open_menu(
	enchantables: Array[Enchantable],
	enchantments: Dictionary[String, Enchantment]) -> void:
		
	# Generate random enchantments
	for spell_panel in spell_panels:
		# random enchantable (Player, weapon1, weapon2, ...)
		var rand_able = randi() % enchantables.size() # rng.randf_range(0, enchantables.size())
		
		var random_key = enchantments.keys()[randi() % enchantments.size()]
		var random_enchant = enchantments[random_key]
		
		spell_panel.set_enchant(enchantables[rand_able], random_enchant)
		
	blur.show()
	show()


func _on_enchant_selected(enchantable, enchantment) -> void:
	print("Selected {enchantable_name}".format(enchantable))
	# TODO: apply enchantment to player or weapon
	apply_enchantment.emit()
	get_tree().paused = false
	
	blur.hide()
	hide()

# INFO: sadas 
