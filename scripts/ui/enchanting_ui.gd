extends Control

var spell_panels: Array[Panel] = []
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	hide()
	for spell_panel in get_tree().get_nodes_in_group("SpellPanel"):
		spell_panels.append(spell_panel as Panel)

func _on_enchant_manager_open_menu(
	enchantables: Array[Enchantable],
	enchantments: Dictionary[String, Enchantment]) -> void:
		
	# Generate random enchantments
	for spell_panel in spell_panels:
		# random enchantable (Player, weapon1, weapon2, ...)
		var rand_num = rng.randf_range(0, enchantables.size())
		
		var size = enchantments.size()
		var random_key = enchantments.keys()[randi() % size]
		var random_enchant = enchantments[random_key]
		
		spell_panel.set_enchant(enchantables[rand_num], random_enchant)
		
	show()
