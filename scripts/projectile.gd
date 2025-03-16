extends Node2D
@export var SPEED = 100
@onready var animated_sprite_2d = $AnimatedSprite2D

var is_hit = false

func _process(delta: float) -> void:
	if not is_hit:
		position += transform.x * SPEED * delta

func _ready():
	animated_sprite_2d.play("travel_animation")

func _on_area_entered(area):
	if area.get_parent().is_in_group("EnemyGroup") and not is_hit:  # Check if the projectile hits an enemy
		is_hit = true
		animated_sprite_2d.play("hit_animation")  # Play the hit animation
		SPEED = 0  # Stop movement
		await animated_sprite_2d.animation_finished  # Wait for the animation to finish
		queue_free()  # Despawn projectile

func _on_visible_on_screen_notifier_2d_screen_exited():
	if not is_hit:
		queue_free()
