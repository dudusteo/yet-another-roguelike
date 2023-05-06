extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect

func set_icon_texture(_texture) -> void:
	if texture_rect:
		texture_rect.texture = _texture
