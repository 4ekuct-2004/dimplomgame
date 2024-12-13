extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory = Inventory.new(Vector2(6, 6), Vector2(1000, 700))
	add_child(inventory)
	inventory.position = Vector2(10, 10)