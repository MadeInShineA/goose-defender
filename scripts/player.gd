extends CharacterBody2D

class_name Player

const MAX_SPEED: int = 100
const ACCELERATION: int = 10000
const FRICTION: int = 100000

@export var MAX_LIFE: int = 10
@export var whiten_material: ShaderMaterial

@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapons: Array[Weapon] = []
@onready var current_weapon: Weapon
@onready var hurtbox = $hurtbox
@onready var blinker = $blinker

const whiten_duration: float = 0.15
const blinking_duration: float = 1.0
const invincibility_duration: int = 2
var is_invincible: bool = false
const stun_duration: float = 1.0
var is_stuned: bool = false
var life: int = MAX_LIFE
var weapon_index: int = 0

signal health_changed

func _ready() -> void:
	for weapon in $Weapons.get_children():
		print(weapon.name)
		weapon.set_process(false)
		weapon.hide()
		weapons.append(weapon)
	
	# Select random weapon on start
	print(weapons)
	current_weapon = weapons[randi() % weapons.size()]
	show_weapon(current_weapon)

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
		animation_player.play("left")
	else:
		animation_player.play("right")

func handle_invincibility(invincibility_duration: float):
	is_invincible = true
	await (get_tree().create_timer(invincibility_duration)).timeout
	is_invincible = false
	
func handle_stun(stun_duration: float):
	is_stuned = true
	current_weapon.set_deferred("visible", false)  # Hide the staff
	current_weapon.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)  # Disable processing
	animation_player.play("stun")
	await get_tree().create_timer(stun_duration).timeout
	
	is_stuned = false
	current_weapon.set_deferred("visible", true)  # Show the staff again
	current_weapon.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	life = MAX_LIFE
	health_changed.emit()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var unlocked_weapons = weapons.filter(func(w): return w.is_unlocked)
		
		# Prevent invalid access
		if unlocked_weapons.is_empty():
			print("No unlocked weapons!")  # Debugging
			return  # Exit early

		# Find the current weapon in unlocked list
		var current_weapon = weapons[weapon_index] if weapon_index < weapons.size() else null
		var current_unlocked_index = unlocked_weapons.find(current_weapon)

		# Default to first unlocked weapon if the current one isn't found
		if current_unlocked_index == -1:
			current_unlocked_index = 0  

		# Change index based on scroll direction
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_unlocked_index += 1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_unlocked_index -= 1
		else:
			return
		# Wrap around
		current_unlocked_index = posmod(current_unlocked_index, unlocked_weapons.size())

		# Get new weapon index in full weapon list
		weapon_index = weapons.find(unlocked_weapons[current_unlocked_index])
		
		# Get new weapon index in full weapon listsapon_index])
		hide_weapon(current_weapon)
		var next_weapon = weapons[weapon_index]
		current_weapon = next_weapon
		show_weapon(current_weapon)
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	pass
	
func take_damage(damage_amount):
	if is_invincible:
		return
	life -= damage_amount
	health_changed.emit()
	if life <= 0:
		handle_stun(stun_duration)
	else:
		handle_invincibility(invincibility_duration)
		whiten_material.set_shader_parameter("whiten", true)
		await(get_tree().create_timer(whiten_duration)).timeout
		whiten_material.set_shader_parameter("whiten", false)
		blinker.start_blinking(self, blinking_duration)

func show_weapon(weapon):
	weapon.set_process(true)
	weapon.show()
	if not weapon.is_unlocked:
		weapon.is_unlocked = true
	
func hide_weapon(weapon):
	weapon.set_process(false)
	weapon.hide()
