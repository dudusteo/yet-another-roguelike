extends Control

const Icon = preload("res://ui/icon.tscn")

@onready var line = $Line/LineFill
@onready var game_manager: Node2D = get_tree().get_root().get_node("GameManager")

var max_speed_bar: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.connect("entity_enter", self.create_bar_icon)
	game_manager.connect("entity_speed_changed", self.update_bar_position)
	max_speed_bar = game_manager.max_speed_bar

func create_bar_icon(_entity: Sprite2D) -> void:
	var icon = Icon.instantiate()	
	icon.set_icon_texture(_entity.texture)
	var line_rect: Rect2 = line.get_rect()
	var ratio = _entity.speed / max_speed_bar
	var x_pos = line_rect.position.x + line_rect.size.x / 2
	var y_pos = line_rect.position.y + line_rect.size.y * ratio
	icon.set_position(Vector2(x_pos, y_pos) - icon.size / 2)
	add_child(icon)

func update_bar_position(_entity: Sprite2D, _current_speed: float) -> void:
	var line_rect: Rect2 = line.get_rect()
	var ratio = _current_speed / max_speed_bar
	var x_pos = line_rect.position.x + line_rect.size.x / 2
	var y_pos = line_rect.position.y + line_rect.size.y * ratio
	#player.set_position(Vector2(x_pos, y_pos) - player.size / 2)
