extends CharacterBody2D

@onready var hurtbox = $hurtbox
@onready var blinker = $blinker
@onready var colision_box = $CollisionShape2D
@export var life: int = 10
@export var whiten_material: ShaderMaterial
@export var ATTACK_RANGE: int = 60
@export var ATTACK: int = 1
const whiten_duration: float = 0.15
const blinking_duration = 1
signal died

var speed = 150
var target: CharacterBody2D

func _physics_process(delta: float) -> void:
	if target: # Vérifie que la cible a été assignée
		if position.distance_to(target.position) > ATTACK_RANGE:
			var direction = (target.position - position).normalized()
			velocity = direction * speed
			look_at(target.position)
			move_and_slide()
		else:
			target.take_damage(ATTACK)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	# TODO why calling the hurtbix function doesn't work ??
	if area.get_parent() is Player:
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
