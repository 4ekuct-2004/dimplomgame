extends Creature

@onready var label = $Label

func _ready() -> void:
	damage_taken.connect(showdmg)

func showdmg(dmg):
	label.text = str(dmg)
	health += dmg
