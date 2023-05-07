extends Node

@onready var player = $Player
@onready var ui = $UI


# Called when the node enters the scene tree for the first time.
func _ready():
	ui.set_player_inventory_data(player.inventory_data)
