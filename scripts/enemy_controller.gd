extends "res://scripts/time_controller.gd"

var current_target: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	randomize()
	current_target = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if not time_stop:
		var direction: int = randi() % 5
		if direction == 1:
			current_target += Vector2(-32, 0)
		elif direction == 2:
			current_target += Vector2(0, 32)
		elif direction == 3:
			current_target += Vector2(32, 0)
		elif direction == 4:
			current_target += Vector2(0, -32)
		end_turn()
	position = position.move_toward(current_target, _delta * 200)
