extends CharacterBody2D
class_name Creature

@export var health_module: HealthModule
@export var moving_module: PlayerMovingModule
@export var state_machine: StateMachine
@export var weapon_module: WeaponModule

@export var allowed_states: Array[String]

func _physics_process(delta: float) -> void:
	if moving_module: 
		moving_module.moving_process(delta)
		move_and_slide()

func attack():
	weapon_module.emit_signal("attack_s")