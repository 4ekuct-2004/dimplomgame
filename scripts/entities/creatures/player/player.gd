extends Creature
class_name Player

var inv = Inventory.new(Vector2(2, 3))
var weapons = [load("res://objects/weapons/weapon_akm.tscn").instantiate(), load("res://objects/weapons/weapon_revolver.tscn").instantiate()]

@onready var current_weapon = weapons[0]
@onready var sprite = $sprite

var mouse_pos = Vector2.ZERO
var lmb_pressed = false
var locked = false

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
	add_child(current_weapon)
	add_child(inv)
	inv.hide()
	print(get_viewport_rect().size)
	inv.position = Vector2((-get_viewport_rect().size.x/2)/3, -100)
	print(inv.position)
	
	attack_mods.append(Modifier.new("double_damage", 2, Modifier.ModTypes.PERCENT))
	
	can_interaction = false

func _physics_process(delta):
	if locked: return
	mouse_pos = get_global_mouse_position()
	moving_process(delta)
	weapon_process(delta)
	
	move_and_slide()

func moving_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction: sprite.play("walk")
	else: sprite.play("idle")
	
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
		if event.is_action_pressed("UMW"):
			remove_child(current_weapon)
			current_weapon = weapons.back()
			add_child(current_weapon)
		if event.is_action_pressed("DMW"):
			remove_child(current_weapon)
			current_weapon = weapons.front()
			add_child(current_weapon)
	if event.is_action_pressed("space"):
		if inv.visible: 
			inv.hide()
			locked = false
			sprite.play("idle")
		else: 
			inv.show()
			locked = true
			sprite.pause()
