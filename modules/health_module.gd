extends Node
class_name HealthModule

@export var creature: Creature

@export var health = 1
@export var health_regen = 1
@export var armor = 0
@export var immortality_time = 300 # ms

var timer = Timer.new()

var immortality = false
var alive = true

signal killed(killer: Creature)
signal damage_taken(attacker: Creature, damage: int, damage_type: Weapon.DamageTypes)

func _ready():
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(imm_timer_timeout)
	add_child(timer)

func take_damage(damage: int, attacker: Creature):
	emit_signal("damage_taken", attacker, damage)
	if immortality: return

	immortality = true
	timer.start(immortality_time)

	health -= damage
	if health <= damage:
		dead(attacker)

func dead(killer: Creature):
	emit_signal("killed", killer)

func imm_timer_timeout():
	immortality = false