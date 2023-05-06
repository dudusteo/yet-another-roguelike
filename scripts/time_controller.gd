extends Sprite2D
class_name TimeComponent

signal turn_end()

@export var speed: float = 5
var time_stop: bool = true
@onready var time_manager: Node2D = get_tree().get_root().get_node("Root/TimeManager")


func _ready() -> void:
	self.connect("turn_end", time_manager._on_turn_end)


func end_turn() -> void:
	time_stop = true
	emit_signal("turn_end", self)

func _on_turn_start(_entity: Sprite2D) -> void:
	if self == _entity:
		print(self, "time_turn_start")
		time_stop = false
