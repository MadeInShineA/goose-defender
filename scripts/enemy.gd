extends CharacterBody2D

class_name Enemy

signal health_changed
signal died

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var weapon: Weapon

@export var MAX_LIFE: int = 10

@export var SPEED: int
@export var ATTACK_RANGE: int = 5
@export var ATTACK_DAMAGE: int = 1
@onready var hurtbox = $hurtbox
@onready var blinker = $blinker
@onready var colision_box = $CollisionShape2D

@export var target: Node2D
@export var whiten_material: ShaderMaterial

const whiten_duration: float = 0.15
const blinking_duration = 1
var life: int = 5


func  _ready() -> void:
	call_deferred("enemy_setup")
	var goose = get_tree().get_first_node_in_group("GooseGroup")
	var weapons = $Weapons.get_children()
		
	# Select random weapon on start
	weapon = weapons[randi() % weapons.size()]
	weapon.show()
	weapon.SHOOTER = self
	
	target = goose
	navigation_agent_2d.target_desired_distance = ATTACK_RANGE - 5
	
	
func enemy_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position
  
func _physics_process(delta: float) -> void:
	if target:
		navigation_agent_2d.target_position = target.global_position
	if navigation_agent_2d.is_navigation_finished():
		return
	weapon.attack()
		
	
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * SPEED
	
	move_and_slide()
	
	if position.distance_to(target.position) < ATTACK_RANGE:
		target.take_damage(ATTACK_DAMAGE)

func make_path():
	navigation_agent_2d.target_position = target.global_position

func take_damage(damage_amount):
	life -= damage_amount
	if life <= 0:
		died.emit()
		queue_free()
	else:
		print(life)
		health_changed.emit()
		show_blink()
		
func _on_hurtbox_area_entered(area: Area2D) -> void:
	pass
			
func show_blink():
	whiten_material.set_shader_parameter("whiten", true)
	await(get_tree().create_timer(whiten_duration)).timeout
	whiten_material.set_shader_parameter("whiten", false)
	blinker.start_blinking(self, blinking_duration)

func _on_timer_timeout() -> void:
	make_path()

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity


func update() -> void:
	pass # Replace with function body.
