extends PanelContainer

const Slot = preload("res://ui/slot.tscn")

@onready var h_box_container = $MarginContainer/HBoxContainer

func set_inventory_data(_inventory_data: InventoryData) -> void:
	populate_hot_bar(_inventory_data.item_datas)
	
func populate_hot_bar(_item_datas: Array[ItemData]) -> void:
	for child in h_box_container.get_children():
		child.queue_free()

	for item_data in _item_datas: 
		var slot = Slot.instantiate();
		h_box_container.add_child(slot)
		
		if(item_data):
			slot.set_slot_data(item_data)
