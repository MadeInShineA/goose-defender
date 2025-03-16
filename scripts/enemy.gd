extends CharacterBody2D

class_name Enemy

signal died

@export var SPEED: int
@export var ATTACK_RANGE: int = 60
@export var ATTACK_DAMAGE: int = 1
@onready var hurtbox = $hurtbox
@onready var blinker = $blinker
@onready var colision_box = $CollisionShape2D
@export var life: int = 10
@export var target: CharacterBody2D
@export var whiten_material: ShaderMaterial

@onready var blinker: Blinker = $blinker

const whiten_duration: float = 0.15
const blinking_duration = 1

func take_damage(amount):
	life -= amount
	if life <= 0:
		died.emit()
		queue_free()
	else:
		whiten_material.set_shader_parameter("whiten", true)
		await(get_tree().create_timer(whiten_duration)).timeout
		whiten_material.set_shader_parameter("whiten", false)
		blinker.start_blinking(self, blinking_duration)
		
=======
@export var ATTACK_RANGE: int = 60
@export var ATTACK: int = 1
const whiten_duration: float = 0.15
const blinking_duration = 1
signal died

var speed = 150
var target: CharacterBody2D

func  _ready() -> void:
	var player: Player = get_tree().get_first_node_in_group("PlayerGroup")
	target = player
  
func _physics_process(delta: float) -> void:
	if target:
		if position.distance_to(target.position) > ATTACK_RANGE:
			var direction = (target.position - position).normalized()
			velocity = direction * SPEED
			look_at(target.position)
			move_and_slide()
		else:
			pass
			#target.take_damage(ATTACK)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player or area.get_parent() is Enemy:
		pass
	else:
		life -= 1
		if life == 0:
			self.queue_free()
			died.emit()
		else:
			whiten_material.set_shader_parameter("whiten", true)
			await(get_tree().create_timer(whiten_duration)).timeout
			whiten_material.set_shader_parameter("whiten", false)
			blinker.start_blinking(self, blinking_duration)
