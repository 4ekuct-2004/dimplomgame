extends Panel
class_name CellPopup

var item_name_label = Label.new()
var item_desc = RichTextLabel.new()

var margin_cont = MarginContainer.new()
var vbox = VBoxContainer.new()

var popup_pos: Vector2

func _init(item_name: String, desc: String, cell: InvCell) -> void:
	item_name_label.text = item_name
	item_name_label.uppercase = true
	
	item_name_label.add_theme_color_override("font_color", cell.item.item_ranks[cell.item.rank])
	item_name_label.add_theme_color_override("font_shadow_color", Color.WHITE)
	item_desc.text = desc
	
	set_as_top_level(true)
	
	position.x = cell.inv.position.x + cell.inv.size.x + cell.inv.grid_separator
	position.y = cell.inv.position.y
	
	self.size.x = 300
	self.size.y = cell.inv.size.y
	item_desc.fit_content = true
	
	z_index = 1
	
	margin_cont.size = size
	var margin_value = size.x / 25
	margin_cont.add_theme_constant_override("margin_top", margin_value)
	margin_cont.add_theme_constant_override("margin_left", margin_value)
	margin_cont.add_theme_constant_override("margin_bottom", margin_value)
	margin_cont.add_theme_constant_override("margin_right", margin_value)
	
	add_child(margin_cont)
	margin_cont.add_child(vbox)
	vbox.add_child(item_name_label)
	vbox.add_child(item_desc)
