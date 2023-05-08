extends InventoryData
class_name InventoryDataEquip


func drop_item_data(_grabbed_item_data: ItemData, _index: int) -> ItemData:
	if _index == 0 and _grabbed_item_data.type.name == "Head":
		return super.drop_item_data(_grabbed_item_data, _index)
	elif _index == 1 and _grabbed_item_data.type.name == "Chest":
		return super.drop_item_data(_grabbed_item_data, _index)
	elif _index == 2 and _grabbed_item_data.type.name == "Hand":
		return super.drop_item_data(_grabbed_item_data, _index)
	elif _index == 3 and _grabbed_item_data.type.name == "Foot":
		return super.drop_item_data(_grabbed_item_data, _index)
	
	return _grabbed_item_data
