extends Enchantable

class_name Weapon

@onready var attack_timer: Timer = $AttackTimer
@onready var fire_point: Marker2D = $Marker2D
@onready var sprite: Sprite2D = $Sprite2D

@export var projectile_scene: PackedScene
@export var base_damage: float
@export var base_attack_speed: float
@export var element: Element
@export var audio_player :AudioStreamPlayer

@onready var current_damage: float = base_damage
@onready var current_attack_speed: float = base_attack_speed

var can_attack: bool = true

func _ready():
	enchantment_texture = sprite.texture
	attack_timer.wait_time = 1.0 / current_attack_speed
	attack_timer.one_shot = true
	attack_timer.start()

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("fire"):
		attack()

func attack():
	if can_attack:
		audio_player.play()
		var projectile_instance = projectile_scene.instantiate()
		get_tree().root.add_child(projectile_instance)
		projectile_instance.global_position = fire_point.global_position
		
		projectile_instance.rotation = rotation
		can_attack = false
		attack_timer.start()

# Enchantments
func increase_damage(amount: float):
	current_damage += amount

func increase_attack_speed(amount: float):
	current_attack_speed += amount
	attack_timer.wait_time = 1.0 / current_attack_speed

func _on_attack_timer_timeout() -> void:
	can_attack = true
