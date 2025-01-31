extends CharacterBody2D
class_name Creature

enum CreatureTypes {
	alive,
	lifeless,
	other
}

@export var stats_manager: Module
@export var moving_module: Module
@export var state_machine: Module
@export var weapon_module: Module

var creature_type: CreatureTypes

@export var allowed_states: Array[String]

func _physics_process(delta: float) -> void:
	if moving_module: 
		moving_module.moving_process(delta)
		move_and_slide()

func attack():
	if weapon_module:
		weapon_module.emit_signal("attack_s")
