extends Node
class_name Modifier

enum ModifyTypes {
	FLAT,
	PERCENT
}
enum InputTypes {
	DAMAGE_PHYS_PENETRATING,
	DAMAGE_PHYS_BLUNT,
	DAMAGE_MAGICAL,
	DAMAGE_PURE,
	DAMAGE_ALL,
	STAT,
	OTHER,
	ALL
}

var _modifier_name: String
var _modifier: float
var _modifier_type: ModifyTypes
var _modifiable_types: Array[InputTypes]

func _init(modifier_name: String, modifier: float, modifier_type: ModifyTypes, modifiable_types: Array[InputTypes]) -> void:
	_modifier_name = modifier_name
	_modifier = modifier
	_modifier_type = modifier_type
	_modifiable_types = modifiable_types

func modify(val: int, input_type: InputTypes) -> float:
	if not _modifiable_types.has(input_type) and not input_type == InputTypes.ALL: return val
	
	if _modifier_type == ModifyTypes.FLAT: return val + _modifier
	else: return val * _modifier
