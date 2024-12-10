extends Sprite2D
class_name Projectile

var speed: int = 300
var lifetime: int = 1

var velocity = Vector2(speed, 0)

var rnd = RandomNumberGenerator.new()

var del_timer = Timer.new()

func _init(weapon: Weapon):
	position = weapon.global_position
	speed = weapon.projectile_speed

func _ready() -> void:
	set_as_top_level(true)
	var dir = get_parent().rotation + rnd.randf_range(-get_parent().dispersion, get_parent().dispersion)
	velocity = velocity.rotated(dir)
	rotation = dir
	texture = preload("res://assets/emo_texture.png")

	scale = Vector2(0.01, 0.01)

	del_timer.one_shot = true
	del_timer.autostart = false
	del_timer.timeout.connect(on_del_timer_timeout)
	add_child(del_timer)

	var hitbox = Area2D.new()
	var hitbox_shape = CollisionShape2D.new()
	hitbox_shape.shape = RectangleShape2D.new()
	hitbox_shape.shape.size = texture.get_size()
	hitbox.body_entered.connect(body_entered)
	hitbox.area_entered.connect(body_entered)

	add_child(hitbox)
	hitbox.add_child(hitbox_shape)

func on_del_timer_timeout():
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func body_entered(body):
	if body is not Creature and body is not Dummy: return

	if body is Dummy: body.take_damage(get_parent().damage)