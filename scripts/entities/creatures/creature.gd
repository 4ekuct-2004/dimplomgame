extends Entity
class_name Creature

@export var health = 100
var incoming_damage_mod: Array[Modifier]

@export var allowed_states: Array[String]
var state: String
var alive = true

signal damage_taken(dmg: int)
signal dead(killer: Entity)

var base_stats = {
	"max_hp" = 100,
	"armor" = 0,
	"move_speed" = 300
}
var additional_stats = {}

func take_damage(damage: int, attacker: Entity):
	if not alive: return
	for mod in incoming_damage_mod:
		damage = mod.modify(damage)
	health -= damage
	if health <= 0: be_dead(attacker)
	damage_taken.emit(damage)
	
func be_dead(killer: Entity):
	alive = false
	dead.emit()
