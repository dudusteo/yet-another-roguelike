extends Sprite2D

@onready var camera: Camera2D = $Camera2D
@onready var tile_map: TileMap = get_node("../TileMap")
var astar_grid = AStarGrid2D.new()
var path: PackedVector2Array
var current_target: Vector2
var currentPathIndex = 0

func _ready():
	position = tile_map.map_to_local(Vector2i(25, 25))
	current_target = position
	
func _process(_delta):
	if (position == current_target):
		currentPathIndex += 1
		if (currentPathIndex >= path.size()):
			return
		current_target = path[currentPathIndex] + Vector2(tile_map.tile_set.tile_size / 2)
		
	position = position.move_toward(current_target, _delta * 200)

func _input(_event):
	if _event is InputEventScreenTouch and _event.pressed:
		var mouseWorldPosition = get_global_mouse_position()
		var cellPosition = tile_map.local_to_map(mouseWorldPosition)

		var data = tile_map.get_cell_tile_data(0, cellPosition)
		if data:
			astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
			astar_grid.set_region(tile_map.get_used_rect())
			astar_grid.set_cell_size(tile_map.tile_set.tile_size)
			astar_grid.update()
			for cell_pos in tile_map.get_used_cells(1):
				var cost = 100
				astar_grid.set_point_weight_scale(cell_pos, cost)
			
			path = astar_grid.get_point_path(tile_map.local_to_map(position), cellPosition)
			currentPathIndex = 0;
