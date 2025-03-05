extends Creature
class_name EnemyWarrior

@onready var sprite = $sprite

func _ready() -> void:
	dead.connect(play_dead_anim)

func play_dead_anim():
	sprite.play("dead")
