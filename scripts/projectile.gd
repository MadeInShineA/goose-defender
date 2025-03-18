extends Node2D

class_name Projectile

@export var SPEED = 100
@export var DAMAGE: int = 5
@onready var animated_sprite_2d = $AnimatedSprite2D

var SHOOTER
var is_hit = false

func _process(delta: float) -> void:
	if not is_hit:
		position += transform.x * SPEED * delta

func _ready():
	animated_sprite_2d.play("travel_animation")

func _on_area_entered(area):
	var target = area.get_parent()
	if (target.is_in_group("EnemyGroup") and not SHOOTER.is_in_group("EnemyGroup")) or (target.is_in_group("PlayerGroup") and not SHOOTER.is_in_group("PlayerGroup")) and not is_hit:  # Check if the projectile hits an enemy
		is_hit = true
		target.take_damage(DAMAGE)
		animated_sprite_2d.play("hit_animation")  # Play the hit animation
		SPEED = 0  # Stop movement
		await animated_sprite_2d.animation_finished  # Wait for the animation to finish
		queue_free()  # Despawn projectile

func _on_visible_on_screen_notifier_2d_screen_exited():
	if not is_hit:
		queue_free()
