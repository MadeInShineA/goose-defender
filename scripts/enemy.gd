extends CharacterBody2D

class_name Enemy

signal died

@export var SPEED: int
@export var ATTACK_RANGE: int = 60
@export var ATTACK_DAMAGE: int = 1
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
	if area.get_parent() is Player:
		pass
	else:
		life -= 1
		if life == 0:
			self.queue_free()
		else:
			whiten_material.set_shader_parameter("whiten", true)
			await(get_tree().create_timer(whiten_duration)).timeout
			whiten_material.set_shader_parameter("whiten", false)
			blinker.start_blinking(self, blinking_duration)
