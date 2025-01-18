extends CharacterBody2D
class_name Creature

@export var health_module: Module
@export var moving_module: Module
@export var state_machine: Module
@export var weapon_module: Module

@export var allowed_states: Array[String]

func _physics_process(delta: float) -> void:
	if moving_module: 
		moving_module.moving_process(delta)
		move_and_slide()

func attack():
	weapon_module.emit_signal("attack_s")
