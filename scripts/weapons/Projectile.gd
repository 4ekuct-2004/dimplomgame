extends Area2D
class_name Projectile

@export var speed: float = 1000.0
@export var max_distance: float = 2000.0

var velocity: Vector2 = Vector2.ZERO
var damage: float = 10.0
var shooter: Node = null
var _shooter_initial_pos: Vector2
var time = 0.0

func _ready() -> void:
	if body_entered.is_connected(_on_body_entered): return
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func initialize(base_velocity: Vector2, dmg: float, owner: Node):
	velocity = base_velocity
	damage = dmg
	shooter = owner
	if shooter:
		_shooter_initial_pos = shooter.global_position
	rotation = velocity.angle()

func _physics_process(delta):
	if time >= 10: queue_free()
	time += 0.02

	position += velocity * delta
	_check_distance()

func _check_distance():
	if shooter and is_instance_valid(shooter):
		if global_position.distance_to(shooter.global_position) > max_distance:
			queue_free()
	else:
		if global_position.distance_to(_shooter_initial_pos) > max_distance:
			queue_free()

func _on_body_entered(body: Node):
	if is_instance_valid(shooter) and body != shooter and body is Creature:
		body.take_damage(damage, shooter)
		queue_free()
	elif body is TileMapLayer: queue_free()

func _on_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if is_instance_valid(shooter) and body != shooter and body is Player:
		body.take_damage(damage, shooter)
		queue_free()
