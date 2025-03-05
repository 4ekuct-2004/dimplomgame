extends Entity
class_name Creature

@export var health = 100
@export var blood_particles: GPUParticles2D

@export_category("статы")
@export var base_stats = {
	"max_hp" = 100,
	"armor" = 0,
	"move_speed" = 300
}
@export var additional_stats = {
	"acceleration" = 3000,
	"friction" = 1500
}

var incoming_damage_mods: Array[Modifier]
var attack_mods: Array[Modifier]

var alive = true

signal damage_taken(dmg: int)
signal dead(killer: Entity)

signal moved

func take_damage(damage: int, attacker: Entity):
	if not alive: return
	if blood_particles: blood_particles.emitting = true
	for mod in incoming_damage_mods:
		damage = mod.modify(damage, attacker.weapon.damage_type)
	health -= damage
	if health <= 0: be_dead(attacker)
	damage_taken.emit(damage)
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
func be_dead(killer: Entity):
	alive = false
	z_index -= 1
	dead.emit()

func move(target_position: Vector2, delta):
	while position != target_position:
		var direction = (target_position - position).normalized()
		velocity = velocity.move_toward(direction * base_stats["move_speed"], additional_stats["acceleration"] * delta)
	velocity = velocity.move_toward(Vector2.ZERO, additional_stats["friction"] * delta)
	moved.emit()
