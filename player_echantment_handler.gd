extends Enchantable

class_name PlayerEnchantable

@onready var invincibility_timer = $CharacterBody2D/Timer
@onready var hurtbox = $CharacterBody2D/hurtbox
@onready var blinker = $CharacterBody2D/blinker
@onready var weapon: Weapon = $CharacterBody2D/Weapons/Staff1

@export var whiten_material: ShaderMaterial

@export_category("Stats")
@export var base_speed: float = 200.0
@export var base_health: float = 10.0

var current_speed: float = base_speed
var current_health: float = base_health
var current_max_health: float = current_health

const whiten_duration: float = 0.15
const blinking_duration: float = 1.0
const invincibility_duration: int = 2
const stun_duration: float = 1.0
var is_stuned: bool = false

func handle_stun(stun_duration: float):
	is_stuned = true
	weapon.set_deferred("visible", false)  # Hide the staff
	weapon.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)  # Disable processing
	get_child(0).animation_player.play("stun")
	await get_tree().create_timer(stun_duration).timeout
	
	is_stuned = false
	weapon.set_deferred("visible", true)  # Show the staff again
	weapon.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	current_health = current_max_health
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	pass

func take_damage(damage_amount):
	await (get_tree().create_timer(invincibility_duration)).timeout
	invincibility_timer.start(invincibility_duration)
	current_health -= damage_amount
	if current_health <= 0:
		handle_stun(stun_duration)
	else:
		play_stun()

func play_stun():
	whiten_material.set_shader_parameter("whiten", true)
	await(get_tree().create_timer(whiten_duration)).timeout
	whiten_material.set_shader_parameter("whiten", false)
	blinker.start_blinking(self, blinking_duration)
