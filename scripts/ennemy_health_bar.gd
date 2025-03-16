extends TextureProgressBar

@onready var enemy = get_parent()

func _ready() -> void:
	enemy.health_changed.connect(update)
	update()
	
func update():
	print(enemy.life * 100 / enemy.MAX_LIFE)
	value = enemy.life * 100 / enemy.MAX_LIFE
	
