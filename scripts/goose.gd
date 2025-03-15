extends Node2D

signal goose_interacted_with

@export var hp: float = 20.0

var animated_sprite: AnimatedSprite2D
var wave_over: bool = true

func _ready() -> void:
	animated_sprite = get_node("AnimatedSprite2D") as AnimatedSprite2D
	animated_sprite.play("idle")
	
func _process(delta: float) -> void:
	if wave_over:
		animated_sprite.play("wave_over")
	else:
		animated_sprite.play("idle")

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if wave_over:
		goose_interacted_with.emit()
		wave_over = not wave_over
