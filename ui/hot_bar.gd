extends PanelContainer

const Slot = preload("res://ui/slot.tscn")

@onready var h_box_container = $MarginContainer/HBoxContainer

func set_inventory_data(_inventory_data: InventoryData) -> void:
	_inventory_data.inventory_updated.connect(populate_hot_bar)
	populate_hot_bar(_inventory_data)
	
func populate_hot_bar(_inventory_data: InventoryData) -> void:
	for child in h_box_container.get_children():
		child.queue_free()

	for item_data in _inventory_data.item_datas: 
		var slot = Slot.instantiate();
		h_box_container.add_child(slot)
		
		slot._slot_clicked.connect(_inventory_data._on_slot_clicked)
		
		if(item_data):
			slot.set_slot_data(item_data)
