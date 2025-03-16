extends TextureProgressBar

@onready var goose: = get_parent()

func _ready() -> void:
	goose.health_changed.connect(update)
	update()
	
func update():
	value = goose.life * 100 / goose.MAX_LIFE
	
