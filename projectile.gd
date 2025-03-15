extends CharacterBody2D
@export var SPEED = 100

var direction: float
var spawn_position: Vector2
var spawn_rotation: float

func _ready() -> void:
	global_position = spawn_position
	global_rotation = spawn_rotation
	
func _physics_process(delta: float) -> void:
		velocity = Vector2(0, -SPEED).rotated(direction)
		move_and_slide()
		
