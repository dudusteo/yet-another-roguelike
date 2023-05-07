extends CanvasLayer

@onready var speed_bar = $MarginContainer/SpeedBar
@onready var hot_bar = $MarginContainer/HotBar

func set_player_inventory_data(_inventory_data: InventoryData) -> void:
	hot_bar.set_inventory_data(_inventory_data)
