extends Panel

@export_category("Hover animations")
@export var intensity: float = 0.1
@export var duration: float = 0.2

var nameLabel: Label
var spellImage: TextureRect
var descriptionLabel: Label

func _ready() -> void:
	nameLabel = get_node("Button/Name")
	spellImage = get_node("Button/SpellIcon")
	descriptionLabel = get_node("Button/Description")
	
func set_enchant(able: Enchantable, e: Enchantment) -> void:
	nameLabel.text = able.enchantable_name
	spellImage.texture = able.enchantment_texture
	descriptionLabel.text = "+{enchantment_boost} {enchantment_name}".format(e)
	
func _process(delta: float) -> void:
	# Get all the children buttons of this Node
	for button: Button in get_children():
		button.pivot_offset = button.size / 2
		if button.is_hovered():
			button.scale = button.scale.lerp(scale + Vector2.ONE * intensity, duration)
		else:
			button.scale = button.scale.lerp(Vector2.ONE, duration)

func start_tween(object: Object, property: NodePath, final_val: Variant, duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)
	await tween.finished
	tween.kill()
