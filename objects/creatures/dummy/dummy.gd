extends Creature

@onready var label = $Label

func _ready() -> void:
	damage_taken.connect(showdmg)
	incoming_damage_mods.append(Modifier.new("magic_resist_100", 0, Modifier.ModifyTypes.PERCENT, [Modifier.InputTypes.DAMAGE_MAGICAL]))

func showdmg(dmg):
	#label.text = str(dmg)
	health += dmg
