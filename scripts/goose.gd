extends Node2D

signal goose_interacted_with
signal goose_died

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
	if wave_over and _area.get_parent().is_in_group("PlayerGroup"):
		goose_interacted_with.emit()
		wave_over = not wave_over
	elif _area.get_parent().is_in_group("EnemyGroup"):
		goose_died.emit()
