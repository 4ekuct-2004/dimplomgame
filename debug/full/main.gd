extends Node2D
class_name Location

var map_generator = MapGenerator.new()
var map_builder = MapBuilder.new()

@onready var player = $Player
var enemies = load("res://objects/creatures/npc/enemies/ghost/enemy_ghost.tscn")

var paused = false
signal pause

func _ready() -> void:
	var map = map_generator.generate_map()
	map_builder.generate_from_map(map, self)
	
	player.position = map_builder.start_position
	print(player.position)
	pause.connect(on_pause)


func on_pause():
	paused = not paused
	
	var children = get_children()
	if paused:
		for child in children:
			if child is not Node or child is Control: continue
			child.set_process(false)
			child.set_physics_process(false)
	else:
		for child in children:
			if child is not Node or child is Control: continue
			child.set_process(true)
			child.set_physics_process(true)
