extends Creature

@onready var label = $Label

func _ready() -> void:
	damage_taken.connect(showdmg)
	incoming_damage_mod.append(Modifier.new("armor_mk1", -5, Modifier.ModTypes.FLAT))
	incoming_damage_mod.append(Modifier.new("debuff_dmg_x2", 2, Modifier.ModTypes.PERCENT))
	incoming_damage_mod.append(Modifier.new("armor_mk2", -10, Modifier.ModTypes.FLAT))

func showdmg(dmg):
	label.text = str(dmg)
