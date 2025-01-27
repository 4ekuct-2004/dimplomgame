extends Node2D


@onready var p_row = $Control/Panel/p_row
@onready var m_row = $Control/Panel/m_row
@onready var p_col = $Control/Panel/p_col
@onready var m_col = $Control/Panel/m_col

@onready var name_text = $Control/Panel/name
@onready var change_name_b = $Control/Panel/change_name

var inventory : Inventory

func _ready() -> void:
	inventory = Inventory.new(Vector2(100, 100), "INVENTORY", Vector2(5, 5))
	add_child(inventory)
	inventory.position = Vector2(50, 50)
	
	inventory.add_item_arr([ItemBananas.new(), ItemDuck.new(), ItemChips.new(), ItemWatermelon.new()])

	p_row.pressed.connect(plus_row)
	m_row.pressed.connect(minus_row)
	p_col.pressed.connect(plus_col)
	m_col.pressed.connect(minus_col)
	change_name_b.pressed.connect(change_name)

func plus_row():
	var new_size = Vector2(inventory.inv_size.x, inventory.inv_size.y + 1)
	var new_inv = Inventory.new(inventory.cell_min_size, inventory.inv_name, new_size)
	remove_child(inventory)

	inventory = new_inv
	inventory.position = Vector2(50, 50)
	add_child(inventory)


	
func minus_row():
	var new_size = Vector2(inventory.inv_size.x, inventory.inv_size.y - 1)
	var new_inv = Inventory.new(inventory.cell_min_size, inventory.inv_name, new_size)
	remove_child(inventory)

	inventory = new_inv
	inventory.position = Vector2(50, 50)
	add_child(inventory)



func plus_col():
	var new_size = Vector2(inventory.inv_size.x + 1, inventory.inv_size.y)
	var new_inv = Inventory.new(inventory.cell_min_size, inventory.inv_name, new_size)
	remove_child(inventory)

	inventory = new_inv
	inventory.position = Vector2(50, 50)
	add_child(inventory)


func minus_col():
	var new_size = Vector2(inventory.inv_size.x - 1, inventory.inv_size.y)
	var new_inv = Inventory.new(inventory.cell_min_size, inventory.inv_name, new_size)
	remove_child(inventory)

	inventory = new_inv
	inventory.position = Vector2(50, 50)
	add_child(inventory)

func change_name():
	var new_inv = Inventory.new(inventory.cell_min_size, name_text.text, inventory.inv_size)
	remove_child(inventory)

	inventory = new_inv
	inventory.position = Vector2(50, 50)
	add_child(inventory)


func _on_upd_pressed() -> void:
	for row in inventory.cells:
		for cell in row:
			print(str(cell.pos_in_inv) + " => " + str((cell.item.item_name if cell.is_empty() else "empty")))
