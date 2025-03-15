extends CharacterBody2D

@onready var target1 = $"../Player"
@onready var target2 = $"../Player"
@onready var hurtbox = $hurtbox
@onready var blinker = $blinker
@onready var colision_box = $CollisionShape2D
@export var life: int = 10
@export var whiten_material: ShaderMaterial
@export var ATTACK_RANGE: int = 60
@export var ATTACK: int = 1
const whiten_duration: float = 0.15
const blinking_duration = 1

var target: Node2D = null
var speed = 150

func _ready():
	target = get_closest_target() # Sélection de la cible au début

func get_closest_target() -> Node2D:
	var dist1 = position.distance_to(target1.position)
	var dist2 = position.distance_to(target2.position)
	
	if dist1 < dist2:
		return target1
	else:
		return target2

func _physics_process(delta: float) -> void:
	if target: # Vérifie que la cible a été assignée
		var direction = (target.position - position).normalized()
		velocity = direction * speed
		look_at(target.position)
		move_and_slide()
		if position.distance_to(target.position) > ATTACK_RANGE:
			var direction = (target.position - position).normalized()
			velocity = direction * speed
			look_at(target.position)
			move_and_slide()
		else:
			target.take_damage(ATTACK)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	# TODO why calling the hurtbix function doesn't work ??
	area.queue_free()

	life -= 1
	if life == 0:
		self.queue_free()
	whiten_material.set_shader_parameter("whiten", true)
	await(get_tree().create_timer(whiten_duration)).timeout
	whiten_material.set_shader_parameter("whiten", false)
	blinker.start_blinking(self, blinking_duration)
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
