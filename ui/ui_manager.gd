extends CanvasLayer

var grabbed_item_data: ItemData

@onready var hot_bar = $MarginContainer/HotBar

func set_player_inventory_data(_inventory_data: InventoryData) -> void:
	_inventory_data.inventory_interact.connect(_on_inventory_interact)
	hot_bar.set_inventory_data(_inventory_data)

func _on_inventory_interact(_inventory_data: InventoryData, _index: int) -> void:	
	match [grabbed_item_data]: 
		[null]:
			grabbed_item_data = _inventory_data.grab_item_data(_index)
		[_]:
			grabbed_item_data = _inventory_data.drop_item_data(grabbed_item_data, _index)
