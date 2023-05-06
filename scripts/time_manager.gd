extends Node2D

signal entity_turn_start(entity)
signal entity_enter(entity)
signal entity_speed_changed(entity, current_speed)

var time_stop: bool = false

class SpeedData:
	var data: Sprite2D
	var current_speed: float
	func _init(_data: Sprite2D, _current_speed: float):
		self.data = _data
		self.current_speed = _current_speed
		

@export var game_speed: float = 10
@export var max_speed_bar: float = 100

var speed_bars: Array[SpeedData] = []

func _ready() -> void:
	for child in get_tree().get_root().get_node("Root").get_children():
		if child is Entity:
			self.connect("entity_turn_start", child._on_turn_start)
			speed_bars.append(SpeedData.new(child, child.speed))
			emit_signal("entity_enter", child)

func _process(_delta) -> void:
	for entity in speed_bars:
		if not time_stop:
			entity.current_speed += entity.data.speed * _delta * game_speed
			entity.current_speed = min(entity.current_speed, max_speed_bar)
			emit_signal("entity_speed_changed", entity.data, entity.current_speed)
			if entity.current_speed == max_speed_bar:
				time_stop = true
				emit_signal("entity_turn_start", entity.data) 


func _on_turn_end(_entity) -> void:
	for entity in speed_bars:
		if entity.data == _entity:
			print(_entity, "turn end")
			entity.current_speed = 0
			time_stop = false
