extends Entity
class_name Creature

@export var health = 100
var incoming_damage_mod: Array[Modifier]

@export var allowed_states: Array[String]
var state: String

signal damage_taken(dmg: int)

var base_stats = {
	"max_hp" = 100,
	"armor" = 0,
	"move_speed" = 300
}
var additional_stats = {}

func take_damage(damage: int):
	print("===DEF-DMG===")
	for mod in incoming_damage_mod:
		damage = mod.modify(damage)
	health -= damage
	damage_taken.emit(damage)
