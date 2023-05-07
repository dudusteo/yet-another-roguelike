extends PanelContainer

signal slot_clicked(index: int)

@onready var texture_rect = $MarginContainer/TextureRect

func set_slot_data(item_data: ItemData) -> void:
	texture_rect.texture = item_data.texture

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		print(get_index())
		emit_signal("slot_clicked", get_index())
