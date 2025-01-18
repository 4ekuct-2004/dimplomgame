extends TextureRect
class_name InvCell

var inv : Inventory

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

func _init(size: Vector2 = Vector2(10, 10)):
	custom_minimum_size = size
	
	if item:
		item_place.texture = item.icon
	item_place.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	var size_1per = size / 100
	item_place.position = size_1per * 10
	item_place.custom_minimum_size = size_1per * 80
	
	add_child(item_place)

func _physics_process(delta: float) -> void:
	if focused: modulate = Color.LIGHT_GRAY
	else: modulate = Color.WHITE

func _mouse_entered():
	inv.cell_focused = self
	focused = true
	modulate = Color.LIGHT_GRAY

func _mouse_exited():
	inv.cell_focused = null
	focused = false
	modulate = Color.WHITE

func cell_update():
	if item:
		item_place.texture = item.icon

func hover_timer_timeout():
	print("hop!")
