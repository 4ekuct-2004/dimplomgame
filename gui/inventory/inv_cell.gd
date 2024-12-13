extends TextureRect
class_name InvCell

var inv : Inventory

var cell_empty_texture = preload("res://assets/gui/inv_cell_empty.png")

var contains : Item

var focused = false

func _ready() -> void:
	inv = get_parent().get_parent().get_parent()

	expand_mode = EXPAND_IGNORE_SIZE
	texture_filter = TEXTURE_FILTER_LINEAR

	texture = cell_empty_texture
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _init(size: Vector2 = Vector2(10, 10)):
	custom_minimum_size = size

func _physics_process(delta: float) -> void:
	if focused: modulate = Color.LIGHT_GRAY
	else: modulate = Color.WHITE

func _mouse_entered():
	inv.cell_focused = self
	focused = true
	
func _mouse_exited():
	inv.cell_focused = null
	focused = false
