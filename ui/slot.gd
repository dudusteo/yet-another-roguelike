extends PanelContainer

signal _slot_clicked(index: int)

@onready var texture_rect = $MarginContainer/TextureRect

func set_slot_data(_item_data: ItemData) -> void:
	texture_rect.texture = _item_data.texture

func _on_gui_input(_event: InputEvent) -> void:
	if _event is InputEventMouseButton and _event.pressed:
		emit_signal("_slot_clicked", get_index())
