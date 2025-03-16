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
		# random enchantable (weapon1, weapon2, ...)
		var probs: Array[float] = []
		
		# Assign weights
		for able in enchantables:
			if not able.is_unlocked:
				probs.append(0.1)
			else:
				probs.append(0.9)
		
		# Compute cumulative sum
		var cumulative_probs: Array[float] = []
		var total = 0.0
		for prob in probs:
			total += prob
			cumulative_probs.append(total)
		
		# Pick a random number between 0 and total weight
		var rand_value = randf() * total
		var rand_able = 0
		# Find which probability range rand_value falls into
		for i in range(cumulative_probs.size()):
			if rand_value <= cumulative_probs[i]:
				rand_able = i  # Return the selected index
				break
		
		var random_key = enchantments.keys()[randi() % enchantments.size()]
		var random_enchant = enchantments[random_key]
		
		spell_panel.set_enchant(enchantables[rand_able], random_enchant)
		
	blur.show()
	show()


func _on_enchant_selected(enchantable, enchantment) -> void:
	#print("Selected {enchantable_name}".format(enchantable))
	# TODO: apply enchantment to player or weapon
	if (not enchantable.is_unlocked):
		#print("New weapon unlocked")
		enchantable.is_unlocked = true
		
	enchantable.apply_enchantment(enchantment)
		
	apply_enchantment.emit()
	get_tree().paused = false
		
	blur.hide()
	hide()
