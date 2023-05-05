extends Sprite2D

signal turn_end()

@export var speed: float = 5
var time_stop: bool = true
@onready var game_manager: Node2D = get_tree().get_root().get_node("GameManager")


func _ready():
	self.connect("turn_end", game_manager._on_turn_end)


func end_turn():
	time_stop = true
	emit_signal("turn_end", self)

func _on_turn_start(_entity: Sprite2D):
	if self == _entity:
		print(self, "time_turn_start")
		time_stop = false