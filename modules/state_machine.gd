extends Module
class_name StateMachine

@export var creature: Creature

@onready var allowed_states = creature.allowed_states

var current_states: Array[String]

signal state_switched

func in_state(state: String):
	allowed_states = creature.allowed_states
	if state in current_states or state not in allowed_states: return

	current_states.append(state)
	emit_signal("state_switched")

func out_state(state: String):
	allowed_states = creature.allowed_states
	if not current_states.has(state): return
	
	current_states.erase(state)
	emit_signal("state_switched")
