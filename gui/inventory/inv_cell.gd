extends TextureRect
class_name InvCell

var inv : Inventory

var pos_in_inv: Vector2

var cell_popup: CellPopup

var cell_empty_texture = preload("res://assets/gui/inv/inv_cell_empty.png")

var item : Item

var item_place : TextureRect = TextureRect.new()

var focused = false
var clicked = false

func _ready() -> void:
	inv = get_parent().get_parent().get_parent()

	expand_mode = EXPAND_IGNORE_SIZE
	texture_filter = TEXTURE_FILTER_LINEAR

	texture = cell_empty_texture
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _init(pos_in_inv: Vector2, size: Vector2 = Vector2(10, 10)):
	custom_minimum_size = size
	self.pos_in_inv = pos_in_inv
	if item:
		item_place.texture = item.icon
	item_place.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	item_place.texture_filter = TEXTURE_FILTER_LINEAR
	
	var size_1per = size / 100
	item_place.position = size_1per * 10
	item_place.custom_minimum_size = size_1per * 80
	
	add_child(item_place)

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or not focused: return
	
	if event.is_action_pressed("LMB"): 
		clicked = true;
		inv.cell_clicked = self
	elif event.is_action_released("LMB"): 
		clicked = false;
		inv.cell_clicked = null

func _mouse_entered():
	inv.cell_focused = self
	focused = true
	modulate = Color.LIGHT_GRAY
	
	if item: add_child(cell_popup)

func _mouse_exited():
	inv.cell_focused = null
	focused = false
	modulate = Color.WHITE
	
	if item: remove_child(cell_popup)

func cell_update():
	if item:
		item_place.texture = item.icon
		cell_popup = CellPopup.new(item.item_name, item.item_desc, self)

func is_empty():
	if item: return true
	else: return false
