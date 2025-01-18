extends Control
class_name Inventory

var cells: Array
var cell_focused: InvCell
var items: Array[Item]

var cell_size : Vector2
var inv_name : String
var inv_size : Vector2
var contr_size : Vector2
var grid_separator : int
var panel_margin : int

var grid = GridContainer.new()
var panel = Panel.new()

var name_panel = Panel.new()
var name_label = Label.new()

var cell_min_size: Vector2

var name_panel_min_size = 30
var name_panel_max_size = 50

var font_min_size = 25
var font_max_size = 45

func _init(cell_size: Vector2 = Vector2(100, 100), inv_name: String = "INVENTORY", inv_size: Vector2 = Vector2(5, 5), contr_size: Vector2 = Vector2(100, 100), 
			grid_separator: int = 3, panel_margin: int = 10, items: Array[Item] = []):
	
	if not cell_size or (cell_size.x <= 0 or cell_size.y <= 0):
		var usable_width = contr_size.x - 2 * panel_margin - grid_separator * (inv_size.x - 1)
		var usable_height = contr_size.y - 2 * panel_margin - grid_separator * (inv_size.y - 1)
		cell_min_size = Vector2(usable_width / inv_size.x, usable_height / inv_size.y)
		size = contr_size
	else: 
		cell_min_size = cell_size
		size = Vector2((inv_size.x * cell_size.x) + (grid_separator * (inv_size.x - 1)) + (panel_margin * 2), 
					(inv_size.y * cell_size.y) + (grid_separator * (inv_size.y - 1)) + (panel_margin * 2))

	self.cell_size = cell_size
	self.inv_name = inv_name
	self.inv_size = inv_size
	self.contr_size = contr_size
	self.grid_separator = grid_separator
	self.panel_margin = panel_margin
	self.items = items

	grid.columns = inv_size.x
	grid.size = size - Vector2(panel_margin, panel_margin)
	grid.position = Vector2(panel_margin, panel_margin)
	grid.add_theme_constant_override("h_separation", grid_separator)
	grid.add_theme_constant_override("v_separation", grid_separator)

	var panel_style_box = StyleBoxFlat.new()
	panel_style_box.bg_color = Color.BLACK
	panel.add_theme_stylebox_override("panel", panel_style_box)
	panel.size = size

	if not name == null or not name == "":
		name_panel.add_theme_stylebox_override("panel", panel_style_box)

		if size.y / 100 * 5 < name_panel_min_size: name_panel.size = Vector2(size.x / 2, name_panel_min_size)
		elif size.y / 100 * 5 > name_panel_max_size: name_panel.size = Vector2(size.x / 2, name_panel_max_size)
		else: name_panel.size = Vector2(size.x / 2, size.y / 100 * 5)
		name_panel.position = Vector2(self.size.x / 4, -name_panel.size.y)

		name_label.text = inv_name
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		name_label.size = name_panel.size
		if name_panel.size.y - 5 < font_min_size: name_label.add_theme_font_size_override("font_size", font_min_size)
		elif name_panel.size.y - 5 > font_max_size: name_label.add_theme_font_size_override("font_size", font_max_size)
		else: name_label.add_theme_font_size_override("font_size", name_panel.size.y - 5)

		add_child(name_panel)
		name_panel.add_child(name_label)

	add_child(panel)
	
	panel.add_child(grid)
	
	inv_update(true)

func add_item(item: Item):
	items.append(item)
	inv_update(false)

func add_item_arr(n_items: Array[Item]):
	for item in n_items:
		items.append(item)
	inv_update(false)

func remove_item(item: Item):
	items.erase(item)
	inv_update(false)

func inv_update(first: bool):
	if first:
		var non_sorted_items = items
		for i in range(inv_size.y):
			var row = []
			for j in range(inv_size.x):
				var cell = InvCell.new(cell_min_size)
				if not non_sorted_items.is_empty():
					var current_item = non_sorted_items.front()
					print("item added " + current_item.item_name)
					cell.item = current_item
					non_sorted_items.erase(current_item)
				cell.cell_update()
				row.append(cell)
				grid.add_child(cell)
			cells.append(row)
	else:
		var non_sorted_items = items
		for row in cells:
			for cell in row:
				cell.item = null
				print(non_sorted_items)
				if not non_sorted_items.is_empty():
					var current_item = non_sorted_items.front()
					print("item added " + current_item.item_name)
					cell.item = current_item
					non_sorted_items.erase(current_item)
				cell.cell_update()
	

func inv_show():
	pass

func inv_hide():
	pass
