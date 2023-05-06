extends PanelContainer
class_name Icon

@onready var texture_rect = $MarginContainer/TextureRect

@export var sprite: TimeComponent

func set_component(_sprite: TimeComponent) -> void:
	sprite = _sprite
	texture_rect.texture = _sprite.texture
