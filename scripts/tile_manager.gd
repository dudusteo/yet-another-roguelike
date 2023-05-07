extends TileMap

signal new_movement_path_created(path)

@export var grid_space: Rect2i

@onready var player: Sprite2D = get_tree().get_root().get_node("Root/Player")

enum Tileset {TILES}
enum Layer {GROUND, COLLISION, OVERLAY, INTERACTABLE}
const WALL: Vector2i = Vector2i(0, 0)
const FLOOR: Vector2i = Vector2i(1, 1)

var rooms: Array[Rect2i] = []
var astar_grid: AStarGrid2D = AStarGrid2D.new()
var used_collision_cells: Array[Vector2i] = []

func _ready() -> void:
	randomize()
	build_level()
	used_collision_cells = get_used_cells(Layer.COLLISION)

func build_level() -> void:
	rooms.clear()
	split_space(grid_space, 3)
	
	var prevRoom: Rect2i = rooms[0]
	for room in rooms:
		if prevRoom != room:
			generate_corridors(prevRoom, room)
			prevRoom = room
	generate_walls(self)

func split_space(_space: Rect2i, _iterations: int) -> void:
	if _iterations == 0:
		generate_room(_space)
		return
		
	var splitVertically: int = randi() % 2
	var splitPosition: float = randf_range(0.3, 0.7)

	var leftSpace: Rect2i
	var rightSpace: Rect2i
	if splitVertically:
		var splitX: int = roundi(_space.position.x + _space.size.x * splitPosition)
		leftSpace = Rect2i(_space.position.x, _space.position.y, splitX - _space.position.x, _space.size.y)
		rightSpace = Rect2i(splitX, _space.position.y, _space.size.x - (splitX - _space.position.x), _space.size.y)
	else:
		var splitY: int = roundi(_space.position.y + _space.size.y * splitPosition)
		leftSpace = Rect2i(_space.position.x, _space.position.y, _space.size.x, splitY - _space.position.y)
		rightSpace = Rect2i(_space.position.x, splitY, _space.size.x, _space.size.y - (splitY - _space.position.y))
		
	split_space(leftSpace, _iterations - 1)
	split_space(rightSpace, _iterations - 1)
	
func generate_room(_space: Rect2i) -> void:
	rooms.append(_space)
	for x in range(_space.size.x - 2):
		for y in range(_space.size.y - 2):
			set_cell(Layer.GROUND, Vector2i(x + 1, y + 1) + _space.position, Tileset.TILES, FLOOR)
	
func generate_walls(_tile_map: TileMap) -> void:
	var tiles: Array[Vector2i] = _tile_map.get_used_cells(Layer.GROUND)
	for tile in tiles:
		var neighbors: Array[Vector2i] = _tile_map.get_surrounding_cells(tile)
		for neighbor in neighbors:
			if !_tile_map.get_cell_tile_data(0, neighbor):
				_tile_map.set_cell(Layer.COLLISION, neighbor, Tileset.TILES, WALL)
	
func generate_corridors(_start: Rect2i, _end: Rect2i) -> void:
	var start: Vector2i = Vector2i(_start.position.x + _start.size.x / 2, _start.position.y + _start.size.y / 2)
	var end: Vector2i = Vector2i(_end.position.x + _end.size.x / 2, _end.position.y + _end.size.y / 2)
	
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.set_region(grid_space)
	astar_grid.cell_size = tile_set.tile_size
	astar_grid.update()
	
	var path: Array[Vector2i] = astar_grid.get_id_path(start, end)
	
	for coords in path:
		set_cell(Layer.GROUND, coords, Tileset.TILES, FLOOR)

var lastCellPosition: Vector2i

func _input(_event) -> void:
	if _event is InputEventScreenTouch and _event.pressed:
		var mouseWorldPosition: Vector2 = get_global_mouse_position()
		var cellPosition: Vector2i = local_to_map(mouseWorldPosition)
		
		var data: TileData = get_cell_tile_data(Layer.GROUND, cellPosition)
		if data:
			astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
			astar_grid.set_region(get_used_rect())
			astar_grid.set_cell_size(tile_set.tile_size)
			astar_grid.update()
			
			for cell_pos in used_collision_cells:
				var cost: float = 100
				astar_grid.set_point_weight_scale(cell_pos, cost)
			
			var path: PackedVector2Array = astar_grid.get_point_path(local_to_map(player.position), cellPosition)
			#Check if 2nd click
			if lastCellPosition == cellPosition:
				clear_layer(Layer.OVERLAY)
				emit_signal("new_movement_path_created", path)
			else:
				clear_layer(Layer.OVERLAY)
				set_cell(Layer.OVERLAY, cellPosition, Tileset.TILES, Vector2i(0, 1))
				lastCellPosition = cellPosition
