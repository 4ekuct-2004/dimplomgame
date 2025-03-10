extends Control


@export var player: Player

@onready var hp_bar = $HEALTH
@onready var cur_weapon_icon = $WEAPON/CURRENT


func _physics_process(delta: float) -> void:
	if player:
		hp_bar.value = player.health
