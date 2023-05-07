extends PanelContainer

const Slot = preload("res://ui/slot.tscn")

@onready var h_box_container = $MarginContainer/HBoxContainer

func set_invetory_data(inventory_data: InventoryData) -> void:
	

func populate_hot_bar() -> void:
	for child in h_box_container.get_children():
		child.queue_free()
	
	
