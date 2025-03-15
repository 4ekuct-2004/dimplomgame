extends Node2D
class_name MapBuilder

const segment_size = Vector2(384, 384)
var segments = {
	"plus_type": load("res://locations/segments/segment_plus_type.tscn"),
	"minus_type": load("res://locations/segments/segment_minus_type.tscn"),
	"L_type": load("res://locations/segments/segment_L_type.tscn"),
	"T_type": load("res://locations/segments/segment_t_type.tscn"),
	"deadend_type": load("res://locations/segments/segment_deadend.tscn")
}

var deadend_positions = []
var start_position = Vector2.ZERO
var start_pos_finded = false

var _world

const directions = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

func generate_from_map(map_array, world):
	_world = world
	deadend_positions.clear()
	start_position = Vector2.ZERO
	var plased_corridors = 0
	
	for y in range(map_array.size()):
		for x in range(map_array[y].size()):
			var cell = map_array[y][x]
			var grid_pos = Vector2(x, y)
			
			if cell == "C":
				if not start_pos_finded: start_position = grid_pos * segment_size
				plased_corridors += 1
				var connections = check_connections(grid_pos, map_array)
				var segment_data = determine_segment(connections)
				place_segment(segment_data, grid_pos)
				
			elif cell == "S":
				plased_corridors += 1
				start_position = grid_pos * segment_size
				start_pos_finded = true
				var segment_data = {
					"type": "plus_type",
					"rotation": 0 
				}
				place_segment(segment_data, grid_pos)

func check_connections(pos, map):
	var connections = []
	for dir in directions:
		var check_pos = pos + dir
		if check_pos.x >= 0 and check_pos.y >= 0 \
		and check_pos.y < map.size() and check_pos.x < map[check_pos.y].size():
			connections.append(map[check_pos.y][check_pos.x] in ["C", "S"]) # Учитываем оба типа
		else:
			connections.append(false)
	return connections

func determine_segment(connections):
	var type = "plus_type"
	var rotation = 0
	var connection_count = connections.count(true)
	
	match connection_count:
		1:
			type = "deadend_type"
			rotation = get_deadend_rotation(connections)
		2:
			if (connections[0] && connections[2]) || (connections[1] && connections[3]):
				type = "minus_type"
				rotation = 90 if connections[0] else 0
			else:
				type = "L_type"
				rotation = get_L_rotation(connections)
		3:
			type = "T_type"
			rotation = get_T_rotation(connections)
		4:
			type = "plus_type"
	return {"type": type, "rotation": rotation}

func get_deadend_rotation(conn):
	for i in 4:
		if conn[i]:
			return (i + 2) % 4 * 90
	return 0

func get_L_rotation(conn):
	if conn[0] && conn[1]: return 0
	elif conn[1] && conn[2]: return 90
	elif conn[2] && conn[3]: return 180
	elif conn[3] && conn[0]: return 270
	for i in 4:
		if conn[i] && conn[(i+1)%4]: return i * 90
	return 0

func get_T_rotation(conn):
	for i in 4:
		if !conn[i] && conn[(i+1)%4] && conn[(i+3)%4]: return (i + 2) % 4 * 90
	return 0

func place_segment(data, grid_pos):
	var segment = segments[data.type].instantiate()
	segment.position = grid_pos * segment_size
	segment.rotation_degrees = data.rotation
	_world.add_child(segment)
	
	if data.type == "deadend_type":
		deadend_positions.append({
			"position": segment.position,
			"grid_coords": grid_pos,
			"rotation": data.rotation
		})
