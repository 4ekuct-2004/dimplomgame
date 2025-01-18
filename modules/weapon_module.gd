extends Module
class_name WeaponModule

@export var creature: Creature

@export var weapon: Weapon = Weapon.new()

signal attack_s()

var orbit_distance = 10 + weapon.orbit_range_correction

func _ready() -> void:
	attack_s.connect(attack)
	add_child(weapon)


func _process(delta: float) -> void:
	if weapon:
		var center_position = creature.position
		var cursor_position = get_global_mouse_position()
		var direction_to_cursor = (cursor_position - center_position).normalized()
		var angle = 0

		angle = wrapf(angle, 0, TAU)

		var orbit_position = center_position + direction_to_cursor.rotated(angle) * orbit_distance

		weapon.global_position = orbit_position
		weapon.look_at(cursor_position)

func attack():
	weapon.attack()
