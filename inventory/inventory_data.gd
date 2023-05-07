extends Resource
class_name InventoryData

@export var item_datas: Array[ItemData]

func _on_slot_clicked(index: int) -> void:
	print("inventory interact")
