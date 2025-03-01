extends Creature
class_name Player

var inv = Inventory.new(Vector2(2, 3))
var weapons = []

@onready var current_weapon_scene = load("res://objects/weapons/weapon_akm.tscn")
@onready var sprite = $sprite
var current_weapon: Node2D

var mouse_pos = Vector2.ZERO
var lmb_pressed = false

var attack_mods: Array[Modifier]

func _ready() -> void:
	base_stats = {
		"health" = 10,
		"armor" = 0,
		"move_speed" = 300
	}
	additional_stats = {
		"acceleration" = 3000,
		"friction" = 1500
	}
	
	current_weapon = current_weapon_scene.instantiate()
	add_child(current_weapon)
	
	attack_mods.append(Modifier.new("double_damage", 2, Modifier.ModTypes.PERCENT))
	
	can_interaction = false

func _physics_process(delta):
	mouse_pos = get_global_mouse_position()
	moving_process(delta)
	weapon_process(delta)
	
	move_and_slide()

func moving_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	sprite.flip_h = true if mouse_pos.x < global_position.x else false
	
	if direction.length() > 0:
		velocity = velocity.move_toward(direction * base_stats["move_speed"], additional_stats["acceleration"] * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, additional_stats["friction"] * delta)

func weapon_process(delta):
	if not current_weapon: return
	
	current_weapon.update_aim(mouse_pos, global_position, velocity)

func _input(event):
	if current_weapon:
		if event.is_action_pressed("LMB"):
			current_weapon.shoot(self, true)
		if event.is_action_released("LMB"):
			current_weapon.shoot(self, false)
