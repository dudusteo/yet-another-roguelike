extends Control

const Icon = preload("res://ui/icon/icon.tscn")

@onready var line: Panel = $Line/LineFill
@onready var time_manager: Node2D = get_tree().get_root().get_node("Root/TimeManager")

var max_speed_bar: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_manager.connect("entity_enter", self.create_bar_icon)
	time_manager.connect("entity_speed_changed", self.update_bar_position)
	max_speed_bar = time_manager.max_speed_bar

func create_bar_icon(_entity: Sprite2D) -> void:
	var icon = Icon.instantiate()
	var line_rect: Rect2 = line.get_rect()
	var ratio: float = _entity.speed / max_speed_bar
	var x_pos: float = line_rect.position.x + line_rect.size.x / 2
	var y_pos: float = line_rect.position.y + line_rect.size.y * ratio
	icon.set_position(Vector2(x_pos, y_pos) - icon.size / 2)
	add_child(icon)
	icon.set_component(_entity)

func update_bar_position(_entity: Sprite2D, _current_speed: float) -> void:
	for child in get_children():
		if child is Icon and child.sprite == _entity:
			var line_rect: Rect2 = line.get_rect()
			var ratio: float = _current_speed / max_speed_bar
			var x_pos: float = line_rect.position.x + line_rect.size.x / 2
			var y_pos: float = line_rect.position.y + line_rect.size.y * ratio
			child.set_position(Vector2(x_pos, y_pos) - child.size / 2)
