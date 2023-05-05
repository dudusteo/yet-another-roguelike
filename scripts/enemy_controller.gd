extends "res://scripts/time_controller.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not time_stop:
		end_turn()
