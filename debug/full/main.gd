extends Node2D
class_name Location

var map_generator = MapGenerator.new()
var map_builder = MapBuilder.new()

@onready var player = $Player
var enemies = load("res://objects/creatures/npc/enemies/ghost/enemy_ghost.tscn")

func _ready() -> void:
	var map = map_generator.generate_map()
	map_builder.generate_from_map(map, self)
	
	player.position = map_builder.start_position
	var enemy = enemies.instantiate()
	add_child(enemy)
	enemy.position = player.position + Vector2(500, 0)
