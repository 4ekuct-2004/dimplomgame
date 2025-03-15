extends Area2D
class_name MeleeHitbox

@export var weapon: Weapon
@export var attack_cooldown: float = 0.5 

var _last_hits: Dictionary = {} 

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body == weapon.get_parent(): return false
	if not body is Creature: return
	
	var creature = body as Creature
	var current_time = Time.get_ticks_msec()
	
	if _can_hit(creature, current_time):
		creature.take_damage(weapon.damage, weapon.get_parent())
		_last_hits[creature] = current_time

func _can_hit(target: Creature, current_time: int) -> bool:
	if not is_instance_valid(target):
		_last_hits.erase(target)
		return false
	
	var last_hit_time = _last_hits.get(target, -1)
	var cooldown_ms = attack_cooldown * 1000
	
	return (last_hit_time == -1 || (current_time - last_hit_time) >= cooldown_ms)

func _process(delta):
	var to_remove = []
	for creature in _last_hits:
		if not is_instance_valid(creature):
			to_remove.append(creature)
	
	for creature in to_remove:
		_last_hits.erase(creature)
