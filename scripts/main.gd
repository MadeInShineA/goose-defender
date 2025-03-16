extends Node2D

@onready var player: Player = $Player
@onready var mini_map: CanvasLayer = $MiniMap

func _ready() -> void:
	if mini_map and player:
		mini_map.player_node = player
