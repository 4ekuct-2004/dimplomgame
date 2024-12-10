extends Node2D
class_name PlayerMovingModule

@export var creature: Creature

@export var speed = 200
var friction: int = floor(100 + 300000 / (speed + 1))


func moving_process(delta):
	var input_vector = Vector2.ZERO
	if InputEventAction:
		input_vector = Input.get_vector("left", "right", "up", "down")

	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		creature.velocity = input_vector * speed
	else:
		creature.velocity = creature.velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if creature.sprite:
		if get_global_mouse_position().x < creature.global_position.x: creature.sprite.flip_h = true
		elif get_global_mouse_position().x > creature.global_position.x: creature.sprite.flip_h = false

func change_speed(val: int):
	speed = speed + val
	friction = floor(100 + 150000 / (speed + 1))
