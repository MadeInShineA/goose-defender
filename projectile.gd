extends Node2D
@export var SPEED = 100
@onready var animated_sprite_2d = $AnimatedSprite2D


func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _ready():
	animated_sprite_2d.play("default")
