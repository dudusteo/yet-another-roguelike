extends "res://scripts/time_controller.gd"

@onready var tile_manager: Node2D = get_tree().get_root().get_node("Root/TileManager")

var path: PackedVector2Array
var current_target: Vector2
var currentPathIndex: int = 0

func _ready() -> void:
	tile_manager.connect("new_movement_path_created", self._on_tile_manager_new_movement_path_created)
	super()
	current_target = position
	
func _process(_delta) -> void:
	if position == current_target && not time_stop:
		currentPathIndex += 1
		if (currentPathIndex >= path.size()):
			return
		current_target = path[currentPathIndex] + Vector2(16, 16)
	if not time_stop:
		position = position.move_toward(current_target, _delta * 200)
		if position == current_target:
			end_turn()


func _on_tile_manager_new_movement_path_created(_path: PackedVector2Array) -> void:
	currentPathIndex = 0;
	path = _path
