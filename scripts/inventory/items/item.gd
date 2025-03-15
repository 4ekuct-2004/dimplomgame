extends Node2D
class_name Item

enum ItemTypes {
	ATTACK,
	PROTECTION,
	BOTH,
	OTHER
}

var item_ranks = {
	5: Color.GRAY,
	4: Color.WHITE,
	3: Color.GREEN,
	2: Color.YELLOW,
	1: Color.RED,
	0: Color.BLACK
}

var item_name = "noname"
var item_desc = "nothing"
var rank: int
var type: ItemTypes

var modifier: Modifier
var on_ground = false

var icon: Texture2D

var applied = false

func apply(target: Creature):
	applied = true
	match type:
		ItemTypes.ATTACK: target.attack_mods.append(modifier)
		ItemTypes.PROTECTION: target.incoming_damage_mods.append(modifier)
		ItemTypes.BOTH: 
			target.attack_mods.append(modifier)
			target.target.incoming_damage_mods.append(modifier)
		ItemTypes.OTHER: pass
