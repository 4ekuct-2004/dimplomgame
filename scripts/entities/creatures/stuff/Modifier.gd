extends Node
class_name Modifier

enum ModTypes {
	FLAT,
	PERCENT
}

var _modifier_name: String
var _modifier: float
var _modifier_type: ModTypes

func _init(modifier_name: String, modifier: float, modifier_type: ModTypes) -> void:
	_modifier_name = modifier_name
	_modifier = modifier
	_modifier_type = modifier_type

func modify(val: int) -> float:
	if _modifier_type == ModTypes.FLAT: return val + _modifier
	else: return val * _modifier
