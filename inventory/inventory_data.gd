extends Resource
class_name InventoryData

signal inventory_updated(inventody_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int)

@export var item_datas: Array[ItemData]

func grab_item_data(_index: int) -> ItemData:
	var item_data: ItemData = item_datas[_index] 
	
	if item_data:
		item_datas[_index] = null
		inventory_updated.emit(self)
		return item_data
	else:
		return null

func drop_item_data(_grabbed_item_data: ItemData, _index: int) -> ItemData:
	var item_data: ItemData = item_datas[_index] 
	
	item_datas[_index] = _grabbed_item_data
	inventory_updated.emit(self)
	return item_data


func _on_slot_clicked(_index: int) -> void:
	emit_signal("inventory_interact", self, _index)
