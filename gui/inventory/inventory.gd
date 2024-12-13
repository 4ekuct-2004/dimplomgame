extends Control
class_name Inventory

var cells: Array
var cell_focused: InvCell

var grid = GridContainer.new()
var panel = Panel.new()

var cell_min_size: Vector2

func _init(inv_size: Vector2 = Vector2(5, 5), contr_size: Vector2 = Vector2(100, 100), 
			grid_separator: int = 3, panel_margin: int = 10, inv_name: String = "INVENTORY", items: Array[Item] = []):
	
	var usable_width = contr_size.x - 2 * panel_margin - grid_separator * (inv_size.x - 1)
	var usable_height = contr_size.y - 2 * panel_margin - grid_separator * (inv_size.y - 1)
	cell_min_size = Vector2(usable_width / inv_size.x, usable_height / inv_size.y)
	
	size = contr_size
	
	grid.columns = inv_size.x
	grid.size = size - Vector2(panel_margin, panel_margin)
	grid.position = Vector2(panel_margin, panel_margin)
	grid.add_theme_constant_override("h_separation", grid_separator)
	grid.add_theme_constant_override("v_separation", grid_separator)

	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color.BLACK
	panel.add_theme_stylebox_override("panel", style_box)

	panel.size = size

	add_child(panel)
	panel.add_child(grid)
	for i in range(inv_size.y):
		var row = []
		for j in range(inv_size.x):
			var cell = InvCell.new(cell_min_size)
			row.append(cell)
			grid.add_child(cell)
		cells.append(row)

func inv_show():
	pass

func inv_hide():
	pass
