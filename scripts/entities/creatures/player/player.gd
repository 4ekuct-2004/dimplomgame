extends Creature
class_name Player

var inv = Inventory.new(Vector2(2, 3))
var weapons = [load("res://objects/weapons/weapon_akm.tscn").instantiate(), load("res://objects/weapons/weapon_revolver.tscn").instantiate()]

@onready var weapon = weapons[0]
@onready var sprite = $sprite

var mouse_pos = Vector2.ZERO
var lmb_pressed = false
var locked = false

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
	add_child(weapon)
	add_child(inv)      
	inv.hide()
	inv.position = Vector2((-get_viewport_rect().size.x/2/3), -100)
	
	attack_mods.append(Modifier.new("double_damage", 2, Modifier.ModTypes.PERCENT, [Modifier.DamageTypes.ALL]))
	
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
	if not weapon: return
	
	weapon.update_aim(mouse_pos, global_position, velocity)

func _input(event):
	if weapon:
		if event.is_action_pressed("LMB"):
			weapon.shoot(self, true)
		if event.is_action_released("LMB"):
			weapon.shoot(self, false)

		if event.is_action_pressed("UMW"): switch_weapon(weapon, weapons.back())
		elif event.is_action_pressed("DMW"): switch_weapon(weapon, weapons.front())
	if event.is_action_pressed("space"):
		if inv.visible: 
			inv.hide()
			locked = false
			sprite.play("idle")
		else: 
			inv.show()
			locked = true
			sprite.pause()

func switch_weapon(old_weapon, new_weapon):
	remove_child(old_weapon)
	weapon = new_weapon
	add_child(weapon)
