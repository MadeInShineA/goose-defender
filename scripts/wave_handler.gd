extends Node2D

signal end_of_wave

@onready var dead_enemies = 0
@onready var random_generator = RandomNumberGenerator.new()
@onready var wave_timer = $WavesTimer # autostart on
@onready var spawn_timer = $SpawnTimer

@export var waves: Array[Wave]

signal won_game

var current_wave: int = 0
var last_wave: int

func _ready() -> void:
	wave_timer.wait_time = 15
	last_wave = waves.size()
	
func start_wave(wave: Wave):
	for seq in wave.enemy_sequences:
		for i in range(seq.amount):
			#print("Spawning enemy")
			var enemy = seq.type.instantiate()
			enemy.position = get_random_spawner()
			enemy.died.connect(self._on_enemy_died)
			add_child(enemy)  # Spawn enemy
			
			spawn_timer.wait_time = seq.time  # Set spawn delay
			spawn_timer.start()
			await spawn_timer.timeout  # Wait before spawning the next enemy
		
func get_number_of_enemy_for_current_level():
	var enemy_count = 0
	for seq in waves[current_wave].enemy_sequences:
		enemy_count += seq.amount
	return enemy_count

func handle_enemy_death():
	dead_enemies += 1
	if dead_enemies == get_number_of_enemy_for_current_level():
		dead_enemies = 0
		end_of_wave.emit()
		current_wave += 1
		if current_wave == last_wave:
			won_game.emit()
			print("VICTORY")
			wave_timer.queue_free()
			return
		wave_timer.start()

func get_random_spawner() -> Vector2:	
	var spawners: Array =  get_tree().get_nodes_in_group("MobSpawner")
	var random_spawner_number = random_generator.randi_range(0, spawners.size() - 1)		
	var random_spawner: Node2D = spawners[random_spawner_number]
	return random_spawner.position

func _on_enemy_died() -> void:
	handle_enemy_death()

func _on_wave_start() -> void:
	print("Starting wave number ", current_wave)
	start_wave(waves[current_wave])
