extends Enchantable

class_name Weapon

@export var sprite: Sprite2D

@export var base_damage: float
@export var base_attack_speed: float

var current_damage: float = base_damage
var current_attack_speed: float = base_attack_speed

func increase_damage(amount: float):
	current_damage += amount
	#print("New ", name, " damage: ", current_damage)

func increase_attack_speed(amount: float):
	current_attack_speed += amount
	#print("New ", name, " speed: ", current_attack_speed)
