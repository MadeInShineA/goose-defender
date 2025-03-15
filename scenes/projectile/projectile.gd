extends Node2D
@export var SPEED = 100
@onready var animated_sprite_2d = $AnimatedSprite2D


func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _ready():
	animated_sprite_2d.play("default")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	self.queue_free()
