extends "res://Time Controller.gd"

var path: PackedVector2Array
var current_target: Vector2
var currentPathIndex = 0

func _ready():
	super()
	current_target = position
	
func _process(_delta):
	if (position == current_target && not time_stop):
		currentPathIndex += 1
		if (currentPathIndex >= path.size()):
			return
		current_target = path[currentPathIndex] + Vector2(16, 16)
		time_stop = true
		emit_signal("turn_end")
	position = position.move_toward(current_target, _delta * 200)


func _on_game_manager_player_turn_start():
	time_stop = false


func _on_game_manager_new_movement_path_created(_path):
	currentPathIndex = 0;
	path = _path
