extends Creature
class_name Enemy

enum AttackType {MELEE, RANGED}
enum BehaviorType {ATTACK, PATROL, DEFAULT}

@export_category("Поведение")
@export var attack_type: AttackType = AttackType.MELEE
@export var behavior_type: BehaviorType = BehaviorType.DEFAULT
@export var circle_speed: float = 200.0
@export var circle_radius: float = 80.0
@export var direction_change_time: Vector2 = Vector2(0.5, 1.5)
@export var retreat_multiplier: float = 0.75

var circle_direction: int = 1  # 1 или -1 для направления движения
var direction_timer: float = 0.0

@export_category("Всячина")
@export var animated_sprite: AnimatedSprite2D
@export var vision_area: Area2D
@export var hitbox: Area2D
@export var collision: CollisionShape2D

@export_category("Территории")
@export var attack_radius: float = 50.0
@export var patrol_area: Dictionary = {"min": Vector2(-100, -100), "max": Vector2(100, 100)}

@export_category("Оружие")
@export var weapon_sc: PackedScene
var weapon: Weapon

var target: Creature
var patrol_target: Vector2
var is_patrol_waiting: bool = false

func _ready() -> void:
	vision_area.body_entered.connect(_on_body_detected)
	weapon = weapon_sc.instantiate()
	add_child(weapon)
	dead.connect(_on_death)

func _physics_process(delta: float) -> void:
	if not alive: return
	
	moving_process(delta)
	move_and_slide()

func _on_body_detected(body: Node) -> void:
	if body is Creature and body != self and body is not Enemy:
		target = body
		behavior_type = BehaviorType.ATTACK

func _on_death() -> void:
	alive = false
	animated_sprite.play("dead")
	behavior_type = BehaviorType.DEFAULT
	remove_child(weapon)
	collision.queue_free()
	hitbox.queue_free()

func moving_process(delta: float) -> void:
	if not alive: return
	
	if velocity != Vector2.ZERO: animated_sprite.play("walk")
	else: animated_sprite.play("idle")
	
	match behavior_type:
		BehaviorType.DEFAULT:
			velocity = Vector2.ZERO
		
		BehaviorType.PATROL:
			patrol_behavior(delta)
		
		BehaviorType.ATTACK:
			attack_behavior(delta)

func patrol_behavior(delta: float) -> void:
	if position.distance_to(patrol_target) < 5.0 or patrol_target == Vector2.ZERO:
		if not is_patrol_waiting:
			is_patrol_waiting = true
			# Ждем перед выбором новой точки
			await get_tree().create_timer(3.0).timeout
			patrol_target = Vector2(
				randf_range(patrol_area["min"].x, patrol_area["max"].x),
				randf_range(patrol_area["min"].y, patrol_area["max"].y)
			)
			is_patrol_waiting = false
	else:
		var direction = (patrol_target - position).normalized()
		velocity = direction * base_stats["move_speed"]

func attack_behavior(delta: float) -> void:
	if not is_instance_valid(target):
		behavior_type = BehaviorType.PATROL
		return
	
	var to_target = target.global_position - global_position
	var distance = to_target.length()
	var desired_distance = attack_radius * retreat_multiplier
	
	var target_velocity = Vector2.ZERO
	var acceleration = additional_stats["acceleration"]
	
	# Обновляем таймер смены направления
	direction_timer -= delta
	if direction_timer <= 0:
		circle_direction *= -1
		direction_timer = randf_range(direction_change_time.x, direction_change_time.y)
	
	if distance > attack_radius:
		# Движение к цели
		target_velocity = to_target.normalized() * base_stats["move_speed"]
	elif distance < desired_distance:
		# Отступление
		target_velocity = -to_target.normalized() * base_stats["move_speed"]
	else:
		# Круговое движение
		var tangent = to_target.normalized().rotated(circle_direction * PI/2)
		var desired_position = target.global_position + tangent * circle_radius
		var circle_direction = (desired_position - global_position).normalized()
		target_velocity = circle_direction * circle_speed
	
	# Плавное изменение скорости
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	
	# Поворот оружия и стрельба
	weapon.update_aim(target.global_position, global_position, Vector2.ZERO)
	if distance <= attack_radius:
		weapon.shoot(self, true)
	
	# Поворот спрайта в сторону цели
	animated_sprite.flip_h = to_target.x < 0
