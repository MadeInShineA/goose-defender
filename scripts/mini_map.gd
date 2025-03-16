extends CanvasLayer

@export var player: Player
@export var tile_map: TileMap

@onready var sub_viewport = $SubViewportContainer/SubViewport

var minimap_player

func _ready() -> void:
	minimap_player = player.duplicate() 
	
	sub_viewport.add_child(tile_map.duplicate())
	sub_viewport.add_child(minimap_player)
	
func _process(delta) -> void:
	minimap_player.position = player.position
	
