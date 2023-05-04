extends Sprite2D

signal turn_end()

@export var speed: float = 5
var time_stop: bool = true
@onready var game_manager: Node2D = get_tree().get_root().get_node("GameManager")


func _ready():
	self.connect("turn_end", game_manager._on_turn_end)
