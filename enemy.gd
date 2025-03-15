extends CharacterBody2D

@onready var target1 = $"../Player"
@onready var target2 = $"../Goose"
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
