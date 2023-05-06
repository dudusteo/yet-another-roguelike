extends PanelContainer
class_name Icon

@onready var texture_rect = $MarginContainer/TextureRect

@export var sprite: Entity

func set_component(_sprite: Entity) -> void:
	sprite = _sprite
	texture_rect.texture = _sprite.texture
