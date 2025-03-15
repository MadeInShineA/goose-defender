extends Button

var parent

func _ready() -> void:
	parent = get_node("..")
	print(parent.name)

func _pressed() -> void:
	pass
