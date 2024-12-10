extends CharacterBody2D
class_name Dummy

var damage_text: Label
var damage_amount: int = 0
var is_damaging: bool = false
var damage_timer: Timer


func _ready():
	damage_text = Label.new()
	add_child(damage_text)

	damage_timer = Timer.new()
	damage_timer.wait_time = 1.0
	damage_timer.one_shot = true
	damage_timer.timeout.connect(_on_damage_timeout)
	add_child(damage_timer)

func take_damage(amount: int):
	damage_amount = amount
	damage_text.text = str(damage_amount)
	damage_text.show()
	is_damaging = true
	damage_timer.start()

func _on_damage_timeout():
	damage_text.hide()
	is_damaging = false

func _process(delta):
	if is_damaging:
		damage_text.position = Vector2(0, -50) 
