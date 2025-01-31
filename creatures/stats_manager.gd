extends Module
class_name StatsManager

var creature: Creature

signal damage_taken(attacker: Creature, dmg: int)
signal killed(killer: Creature)

signal stat_increased(stat: String, val: int)
signal stat_decreased(stat: String, val: int)

var immortality = false

var main_stats = {
	"health": 1,
	"strength": 1,
	"agility": 1,
	"intelligence": 1
}
var secondary_stats = {
	"armor": 1,
	"magic_resist": 1,
	"health_regeneration": 1,
	"melee_damage": 1,
	"range_damage": 1,
	"attack_speed": 1,
	"move_speed": 1,
	"exp_mul": 1,
	"invul_time": 1,
}

func increase_main_stat(stat: String, num: int):
	if not main_stats[stat]: return
	main_stats[stat] += num
func decrease_main_stat(stat: String, num: int):
	if not main_stats[stat]: return
	main_stats[stat] -= num
func increase_secondary_stat(stat: String, num: int):
	if not secondary_stats[stat]: return
	secondary_stats[stat] += num
func decrease_secondary_stat(stat: String, num: int):
	if not secondary_stats[stat]: return
	secondary_stats[stat] -= num
