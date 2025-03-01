extends Node
class_name StatManager

var OWNER: Creature

var STATS = {}

var ACTIVE_MODIFIERS: Array[Modifier]

func _init(own: Creature, base_stats: Dictionary) -> void:
	STATS = base_stats

func recalculate_stats():
	STATS = OWNER.base_stats
	for mod in ACTIVE_MODIFIERS:
		if not STATS.has(mod.target_stat): continue
		STATS[mod.target_stat] = mod.Modify(STATS[mod.target_stat])
