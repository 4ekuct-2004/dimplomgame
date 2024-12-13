extends Sprite2D
class_name Weapon

enum Types {
	melee,
	range
}
enum DamageTypes {
	magic,
	blunt,
	sharp,
	penetrating
}
var emo_texture = preload("res://assets/emo_texture.png")

@onready var creature = get_parent().creature
@onready var creature_state_machine = get_parent().creature.state_machine

var damage = 10

var cooldown = 0.3
var cooldown_timer = Timer.new()
var active_cooldown = false

var attack_duration = 0.01
var attack_duration_timer = Timer.new()
var active_attack = false

var autofire = true

var dispersion = 0.01

var type: Types = Types.range
var dmg_type: DamageTypes = DamageTypes.penetrating

var orbit_range_correction = 0

var projectile_speed = 300

var on_colldown = false
var is_used = false

func _ready() -> void:
	texture = emo_texture
	scale = Vector2(0.1, 0.1)

	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(cooldown_timer_timeout)

	attack_duration_timer.autostart = false
	attack_duration_timer.one_shot = true
	attack_duration_timer.timeout.connect(attack_duration_timer_timeout)

	add_child(cooldown_timer)
	add_child(attack_duration_timer)

	
func attack():
	if active_attack or active_cooldown: return
	var proj = Projectile.new(self)
	add_child(proj)
	proj.del_timer.start(proj.lifetime)

	active_cooldown = true
	active_attack = true

	creature_state_machine.in_state("attacks")
	creature_state_machine.in_state("on_cooldown")

	cooldown_timer.start(cooldown)
	attack_duration_timer.start(attack_duration)

func _physics_process(delta: float) -> void:
	if autofire:
		if Input.is_action_pressed("LMB"):
			attack()
	else:
		if Input.is_action_just_pressed("LMB"):
			attack()

func cooldown_timer_timeout():
	creature_state_machine.out_state("on_cooldown")
	active_cooldown = false

func attack_duration_timer_timeout():
	creature_state_machine.out_state("attacks")
	active_attack = false