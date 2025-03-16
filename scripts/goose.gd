extends Node2D

class_name Goose

signal goose_interacted_with
signal goose_died
signal health_changed

@export var MAX_LIFE: int = 10

var animated_sprite: AnimatedSprite2D
var life: int = MAX_LIFE
var wave_over: bool = false

func _ready() -> void:
	animated_sprite = get_node("AnimatedSprite2D") as AnimatedSprite2D
	animated_sprite.play("idle")
	
func _process(delta: float) -> void:
	if wave_over:
		animated_sprite.play("wave_over")
	else:
		animated_sprite.play("idle")
		
func take_damage(damage_amount):
	life -= damage_amount
	if life <= 0:
		goose_died.emit()
	else:
		health_changed.emit()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if wave_over and _area.get_parent().is_in_group("PlayerGroup"):
		goose_interacted_with.emit()
		wave_over = not wave_over
	elif _area.get_parent().is_in_group("EnemyGroup"):
		goose_died.emit()

func _on_end_of_wave() -> void:
	life = MAX_LIFE
	wave_over = true
