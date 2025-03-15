extends CharacterBody2D

const MAX_SPEED: int = 50
const ACCELERATION: int = 10000
const FRICTION: int = 100000

@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var staff: Node2D = $staff
@onready var right_staff_position: Node2D = $right_staff_position
@onready var left_staff_position: Node2D = $left_staff_position

func _process(delta: float) -> void:
	var direction = Input.get_vector("moving_left", "moving_right", "moving_up", "moving_down")

	if direction.length() > 0:
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction.x, ACCELERATION * delta)
		velocity.y = move_toward(velocity.y, MAX_SPEED * direction.y, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)

	move_and_slide()

	# Determine direction based on mouse position
	var mouse_position = get_global_mouse_position()
	if mouse_position.x < global_position.x:
		animation_player.play("right")
		staff.position = left_staff_position.position
	else:
		animation_player.play("left")
		staff.position = right_staff_position.position
