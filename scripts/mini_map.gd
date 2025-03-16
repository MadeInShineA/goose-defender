extends CanvasLayer

@onready var sub_viewport_container: SubViewportContainer = $Ui/MarginContainer/SubViewportContainer
@onready var sub_viewport: SubViewport = $Ui/MarginContainer/SubViewportContainer/SubViewport
@onready var mini_map_camera: Camera2D = $Ui/MarginContainer/SubViewportContainer/SubViewport/MiniMapCamera
@onready var player_marker: ColorRect = $Ui/MarginContainer/SubViewportContainer/SubViewport/PlayerMarker

var player_node: Node2D
var enemy_markers: Dictionary  # Stores enemy -> marker references

func _ready() -> void:
	for tilemap in owner.get_node("map").get_children():
		if tilemap is TileMapLayer:
			var minimap_tilemap = tilemap.duplicate()
			setup_minimap(minimap_tilemap)

func _process(delta: float) -> void:
	if player_node:
		mini_map_camera.global_position = lerp(
			mini_map_camera.global_position, player_node.global_position, 0.2
		)
		player_marker.global_position = player_node.global_position
	
	# Update enemy markers
	var enemies = get_tree().get_nodes_in_group("EnemyGroup")
	for enemy in enemies:
		if enemy not in enemy_markers:
			create_enemy_marker(enemy)
		enemy_markers[enemy].global_position = enemy.global_position

	# Remove markers for destroyed enemies
	for enemy in enemy_markers.keys():
		if not is_instance_valid(enemy):
			enemy_markers[enemy].queue_free()
			enemy_markers.erase(enemy)

func setup_minimap(minimap_tilemap: TileMapLayer) -> void:
	sub_viewport.add_child(minimap_tilemap)

func create_enemy_marker(enemy: Node2D) -> void:
	var marker = ColorRect.new()
	marker.color = Color(1, 0, 0, 1)  # Red color
	marker.size = Vector2(75, 65)  # Adjust size if needed
	marker.position = enemy.global_position
	sub_viewport.add_child(marker)
	enemy_markers[enemy] = marker  # Store reference

func set_minimap_limits(used_rect: Rect2i) -> void:
	mini_map_camera.limit_left = used_rect.position.x * 16
	mini_map_camera.limit_top = used_rect.position.y * 16
	mini_map_camera.limit_right = (used_rect.position.x + used_rect.size.x) * 16
	mini_map_camera.limit_bottom = (used_rect.position.y + used_rect.size.y) * 16
