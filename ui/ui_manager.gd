extends CanvasLayer

var grabbed_item_data: ItemData

@onready var inventory = $MarginContainer/Inventory
@onready var equip_inventory = $MarginContainer/EquipInventory

func set_inventory_data(_inventory_data: InventoryData) -> void:
	_inventory_data.inventory_interact.connect(_on_inventory_interact)
	inventory.set_inventory_data(_inventory_data)
	
func set_equip_inventory_data(_inventory_data: InventoryData) -> void:
	_inventory_data.inventory_interact.connect(_on_inventory_interact)
	equip_inventory.set_inventory_data(_inventory_data)

func _on_inventory_interact(_inventory_data: InventoryData, _index: int) -> void:	
	match [grabbed_item_data]: 
		[null]:
			grabbed_item_data = _inventory_data.grab_item_data(_index)
		[_]:
			grabbed_item_data = _inventory_data.drop_item_data(grabbed_item_data, _index)
