extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory = Inventory.new(Vector2(100, 100), "INVENTORY", Vector2(5, 5))
	add_child(inventory)
	inventory.position = Vector2(50, 50)
