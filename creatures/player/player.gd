extends Creature
class_name Player

@onready var label = $Label
@onready var sprite = $sprite

var prev_vel = Vector2.ZERO

var inventory = Inventory.new()

func _ready():
	allowed_states = ["idle", "walk", "attacks", "on_cooldown"]
	state_machine.state_switched.connect(on_state_switched)
	state_machine.emit_signal("state_switched")

	add_child(inventory)
	

func _process(delta):
	if state_machine and velocity != prev_vel:
		if velocity == Vector2.ZERO:
			state_machine.out_state("walk")
			state_machine.in_state("idle")
		else:
			state_machine.out_state("idle")
			state_machine.in_state("walk")
		prev_vel = velocity
		
func arr_to_str(strings: Array) -> String:
	var result = ""
	for i in range(strings.size()):
		result += strings[i]
		if i < strings.size() - 1:
			result += ", "
	return result

func on_state_switched():
	label.text = arr_to_str(state_machine.current_states)
