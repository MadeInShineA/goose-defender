extends CharacterBody2D

class_name Player

const MAX_SPEED: int = 300
const ACCELERATION: int = 10000
const FRICTION: int = 100000

@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var staff: Node2D = $staff
@onready var right_staff_position: Node2D = $right_staff_position
@onready var left_staff_position: Node2D = $left_staff_position

@onready var hurtbox = $hurtbox
@onready var blinker = $blinker

@export var MAX_LIFE: int = 10
@export var whiten_material: ShaderMaterial
const whiten_duration: float = 0.15
const blinking_duration: float = 1.0
const invincibility_duration: int = 2
var is_invincible: bool = false
const stun_duration: float = 1.0
var is_stuned: bool = false
var life: int = MAX_LIFE

func _ready():
	add_to_group("PlayerGroup")

func _process(delta: float) -> void:
	if is_stuned:
		return
		
	var direction = Input.get_vector("moving_left", "moving_right", "moving_up", "moving_down")

	if direction.length() > 0:
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction.x, ACCELERATION * delta)
		velocity.y = move_toward(velocity.y, MAX_SPEED * direction.y, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)

	move_and_slide()

	# Determine direction based on mouse position
	var mouse_position = get_global_mouse_position()
	if mouse_position.x < global_position.x:
		animation_player.play("right")
		staff.position = left_staff_position.position
	else:
		animation_player.play("left")
		staff.position = right_staff_position.position

func handle_invincibility(invincibility_duration: float):
	is_invincible = true
	await (get_tree().create_timer(invincibility_duration)).timeout
	is_invincible = false
	
func handle_stun(stun_duration: float):
	is_stuned = true
	staff.set_deferred("visible", false)  # Hide the staff
	staff.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)  # Disable processing
	animation_player.play("stun")
	await get_tree().create_timer(stun_duration).timeout
	
	is_stuned = false
	staff.set_deferred("visible", true)  # Show the staff again
	staff.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	life = MAX_LIFE
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	pass
	
	
func take_damage(damage_amount):
	if is_invincible:
		return
	life -= damage_amount
	if life <= 0:
		handle_stun(stun_duration)
	else:
		handle_invincibility(invincibility_duration)
		whiten_material.set_shader_parameter("whiten", true)
		await(get_tree().create_timer(whiten_duration)).timeout
		whiten_material.set_shader_parameter("whiten", false)
		blinker.start_blinking(self, blinking_duration)
