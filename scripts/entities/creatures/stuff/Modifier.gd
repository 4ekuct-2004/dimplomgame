extends Node
class_name Modifier

enum ModTypes {
	FLAT,
	PERCENT
}
enum DamageTypes {
	PHYS_PENETRATING,
	PHYS_BLUNT,
	MAGICAL,
	PURE,
	ALL
}

var _modifier_name: String
var _modifier: float
var _modifier_type: ModTypes
var _modifiable_damage_types: Array[DamageTypes]

func _init(modifier_name: String, modifier: float, modifier_type: ModTypes, modifiable_damage_types: Array[DamageTypes]) -> void:
	_modifier_name = modifier_name
	_modifier = modifier
	_modifier_type = modifier_type
	_modifiable_damage_types = modifiable_damage_types

func modify(val: int, input_damage_type: DamageTypes) -> float:
	if not _modifiable_damage_types.has(input_damage_type) and not input_damage_type == DamageTypes.ALL: return val
	
	if _modifier_type == ModTypes.FLAT: return val + _modifier
	else: return val * _modifier
