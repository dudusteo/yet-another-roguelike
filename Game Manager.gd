extends Node2D

signal new_movement_path_created(path)
signal player_turn_start()

@export var grid_space: Rect2i


@onready var tile_map: TileMap = $TileMap
@onready var player: Sprite2D = $Player

enum Layer {GROUND, COLLISION, OVERLAY}

var rooms = []
var astar_grid = AStarGrid2D.new()
var used_collision_cells = []
var time_stop: bool = false

func _ready():
	randomize()
	build_level()
	used_collision_cells = tile_map.get_used_cells(Layer.COLLISION)
	
	
@export var game_speed: float = 10
var player_speed = 0
@export var speed_bar: float = 100

func _process(delta):
	if not time_stop:
		player_speed += player.speed * delta * game_speed
		player_speed = min(player_speed, speed_bar)
		print(player_speed)
		if player_speed == speed_bar:
			time_stop = true
			emit_signal("player_turn_start") 

func build_level():
	rooms.clear()
	split_space(grid_space, 3)
	
	var prevRoom = rooms[0]
	for room in rooms:
		if prevRoom != room:
			generate_corridors(prevRoom, room)
			prevRoom = room
	generate_walls(tile_map)

func split_space(_space: Rect2i, _iterations: int):
	if _iterations == 0:
		generate_room(_space)
		return
		
	var splitVertically = randi() % 2
	var splitPosition = randf_range(0.3, 0.7)

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
	
func generate_room(_space: Rect2i):
	rooms.append(_space)
	for x in range(_space.size.x - 2):
		for y in range(_space.size.y - 2):
			tile_map.set_cell(Layer.GROUND, Vector2i(x + 1, y + 1) + _space.position, 1, Vector2i(1, 2))
	
func generate_walls(_tile_map: TileMap):
	var tiles = _tile_map.get_used_cells(Layer.GROUND)
	for tile in tiles:
		var neighbors = _tile_map.get_surrounding_cells(tile)
		for neighbor in neighbors:
			if !_tile_map.get_cell_tile_data(0, neighbor):
				_tile_map.set_cell(Layer.COLLISION, neighbor, 1, Vector2i(1, 1))
	
func generate_corridors(_start: Rect2i, _end: Rect2i):
	var start: Vector2i = Vector2i(_start.position.x + _start.size.x / 2, _start.position.y + _start.size.y / 2)
	var end: Vector2i = Vector2i(_end.position.x + _end.size.x / 2, _end.position.y + _end.size.y / 2)
	
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.set_region(grid_space)
	astar_grid.cell_size = tile_map.tile_set.tile_size
	astar_grid.update()
	
	var path = astar_grid.get_id_path(start, end)
	
	for id in path:
		tile_map.set_cell(Layer.GROUND, id, 1, Vector2i(1, 2))

	
var lastCellPosition: Vector2i

func _input(_event):
	if _event is InputEventScreenTouch and _event.pressed:
		var mouseWorldPosition = get_global_mouse_position()
		var cellPosition = tile_map.local_to_map(mouseWorldPosition)
		
		var data = tile_map.get_cell_tile_data(Layer.GROUND, cellPosition)
		if data:
			astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
			astar_grid.set_region(tile_map.get_used_rect())
			astar_grid.set_cell_size(tile_map.tile_set.tile_size)
			astar_grid.update()
			
			for cell_pos in used_collision_cells:
				var cost = 100
				astar_grid.set_point_weight_scale(cell_pos, cost)
			
			var path = astar_grid.get_point_path(tile_map.local_to_map(player.position), cellPosition)
			#Check if 2nd click
			if lastCellPosition == cellPosition:
				tile_map.clear_layer(Layer.OVERLAY)
				emit_signal("new_movement_path_created", path)
			else:
				tile_map.clear_layer(Layer.OVERLAY)
				for cell_pos in path:
					if cell_pos != path[0]:
						cell_pos = tile_map.local_to_map(cell_pos)
						tile_map.set_cell(Layer.OVERLAY, cell_pos, 1, Vector2i(4, 5))
				lastCellPosition = cellPosition


func _on_turn_end():
	print("player_turn_end")
	player_speed = 0
	time_stop = false
	pass
