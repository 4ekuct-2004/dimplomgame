extends Node2D
class_name Weapon

@export var damage: float = 10.0
@export var fire_rate: float = 0.5
@export var projectile_speed: float = 1000.0
@export var projectile_scene: PackedScene
@export var position_offset: Vector2 = Vector2(35, -5)
@export var is_automatic: bool = false
@export var recoil_distance: float = 5.0
@export var recoil_duration: float = 0.04
@export var recover_duration: float = 0.1
@export var base_spread_angle: float = 0.05
@export var movement_spread_multiplier: float = 0.001
@export var max_spread_angle: float = 0.2
@export var velocity_inheritance: float = 0.5

@export var y_muzzle_compensator = 0

@export var damage_type: Modifier.DamageTypes

@onready var sprite = $sprite
@onready var muzzle: Marker2D = $muzzle
@onready var particles_muzzleflash = $muzzle/particles_muzzleflash
@onready var particles_smoke = $muzzle/particles_smoke

var can_shoot: bool = true
var _timer: Timer
var _base_rotation: float
var shooter_velocity: Vector2 = Vector2.ZERO
var _is_trigger_pressed: bool = false
var _current_recoil_offset: Vector2 = Vector2.ZERO
var _base_offset: Vector2
var _base_muzzle_pos: Vector2

func _ready():
	_timer = Timer.new()
	_timer.wait_time = fire_rate
	_timer.one_shot = true
	_timer.timeout.connect(_on_shoot_cooldown)
	add_child(_timer)
	_base_rotation = rotation
	_base_offset = position_offset
	_base_muzzle_pos = muzzle.position

func update_aim(mouse_position: Vector2, character_position: Vector2, character_velocity: Vector2):
	var direction = (mouse_position - character_position).normalized()
	var is_facing_left = direction.x < 0
	var corrected_offset = _base_offset
	
	if sprite:
		sprite.flip_v = is_facing_left
		if is_facing_left:
			corrected_offset.y = -_base_offset.y
			muzzle.position.y = _base_muzzle_pos.y + y_muzzle_compensator
		else: muzzle.position.y = _base_muzzle_pos.y
	
	global_rotation = direction.angle()
	global_position = character_position + corrected_offset.rotated(global_rotation) + _current_recoil_offset

func shoot(shooter: Node, trigger_pressed: bool):
	_is_trigger_pressed = trigger_pressed
	
	if is_automatic:
		if trigger_pressed and can_shoot:
			_perform_shoot(shooter)
			_timer.start()
	else:
		if trigger_pressed and can_shoot:
			_perform_shoot(shooter)
			_timer.start()

func _perform_shoot(shooter: Node):
	can_shoot = false
	particles_muzzleflash.emitting = true
	particles_smoke.emitting = true
	
	var current_spread = base_spread_angle + shooter_velocity.length() * movement_spread_multiplier
	current_spread = clamp(current_spread, 0.0, max_spread_angle)
	var spread_angle = randf_range(-current_spread, current_spread)
	
	var projectile = projectile_scene.instantiate()
	var shoot_direction = Vector2.RIGHT.rotated(rotation + spread_angle)
	var inherited_velocity = shooter_velocity * velocity_inheritance
	
	var newdmg = damage
	for mod in shooter.attack_mods:
		newdmg = mod.modify(newdmg, damage_type)
	
	projectile.global_position = muzzle.global_position
	projectile.initialize(
		shoot_direction * projectile_speed + inherited_velocity,
		newdmg,
		shooter
	)
	get_tree().root.add_child(projectile)
	
	# Анимация отдачи только визуального смещения
	var recoil_tween = create_tween()
	recoil_tween.set_parallel(true)
	recoil_tween.tween_property(self, "_current_recoil_offset", 
		-shoot_direction * recoil_distance, 
		recoil_duration
	).set_ease(Tween.EASE_OUT)
	
	recoil_tween.chain().tween_property(self, "_current_recoil_offset", 
		Vector2.ZERO, 
		recover_duration
	).set_ease(Tween.EASE_IN_OUT)

func _on_shoot_cooldown():
	can_shoot = true
	if is_automatic and _is_trigger_pressed:
		_perform_shoot(get_parent())
		_timer.start()
