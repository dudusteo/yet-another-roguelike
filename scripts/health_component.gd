extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 10.0

var health: float

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH # Replace with function body.


func damage(attack: Attack):
	health -= attack.attack_damage

	if health <= 0:
		get_parent().queue_free()
