extends Node2D

@onready var current_level = 1
@onready var dead_enemies = 0

@onready var monster = preload("res://scenes/enemy.tscn")
@onready var random_generator = RandomNumberGenerator.new()


func get_number_of_enemy_for_current_level():
	return current_level * 3

func handle_enemy_death():
	dead_enemies += 1
	if dead_enemies == get_number_of_enemy_for_current_level():
		dead_enemies = 0
		current_level += 1
		$InBetweenWavesTimer.start()
		
	
func spawn_ennemies():
	for i in range(get_number_of_enemy_for_current_level()):
		var monster = monster.instantiate()
		
		var spawners: Array =  get_tree().get_nodes_in_group("MobSpawner")
		var random_spawner_number = random_generator.randi_range(0, spawners.size() - 1)		
		var random_spawner = spawners[random_spawner_number]
		
		monster.position = random_spawner.position
		var player: Player = get_tree().get_first_node_in_group("PlayerGroup")
		monster.target = player
		
		monster.died.connect(self._on_enemy_died)
		add_child(monster)
		await (get_tree().create_timer(1.0)).timeout
				
		
func update_level():
		spawn_ennemies()


func _on_in_between_waves_timer_timeout() -> void:
	update_level()


func _on_enemy_died() -> void:
	handle_enemy_death()
