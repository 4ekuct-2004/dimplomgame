extends Node2D
class_name MapGenerator

var map_size := Vector2i(10, 10)
var map: Array = []
var vertical_segments: Array = []
var horizontal_segments: Array = []

var init_position: Vector2

var deadzone: Array[Vector2i]

var s_pos: Vector2

@export var max_length: int = 20
@export var required_corridors: int = 30
@export var max_attempts: int = 1000
@export var min_distance: int = 3

func generate_map():
	_init_map()
	get_deadzone()
	_create_initial_corridors()
	_generate_additional_corridors()
	return map

func _init_map() -> void:
	map = []
	for x in map_size.x:
		map.append([])
		map[x].resize(map_size.y)
		for y in map_size.y:
			map[x][y] = ' '
	

func get_deadzone():
	var deadzone = []
	var rows = map.size()
	if rows == 0:
		return deadzone
	var cols = map[0].size()
	
	for x in range(cols):
		deadzone.append(Vector2(x, 0))
		deadzone.append(Vector2(x, rows - 1))
	
	for y in range(1, rows - 1): 
		deadzone.append(Vector2(0, y)) 
		deadzone.append(Vector2(cols - 1, y)) 

func _create_initial_corridors() -> void:
	var mid = Vector2(randi_range(1,map_size.x - 1), randi_range(1,map_size.y - 1))
	init_position = mid
	
	vertical_segments.append({
		"start": Vector2i(mid.x, 1),
		"end": Vector2i(mid.x, map_size.y-2)
	})

	horizontal_segments.append({
		"start": Vector2i(1, mid.y),
		"end": Vector2i(map_size.x-2, mid.y)
	})
	
	for y in map_size.y:
		map[mid.x][y] = 'C'
	for x in map_size.x:
		map[x][mid.y] = 'C'
	map[mid.x][mid.y] = 'S'
	s_pos = Vector2(mid.x, mid.y)

func _generate_additional_corridors() -> void:
	var attempts = 0
	var generated = 0
	
	while generated < required_corridors and attempts < max_attempts:
		attempts += 1
		
		var base_segment = _get_random_base_segment()
		if not base_segment: continue
		
		var start_pos = _get_random_position(base_segment)
		var result = _try_create_corridor(start_pos, base_segment.type)
		
		if result:
			generated += 1

func _get_random_base_segment() -> Dictionary:
	var vertical_prob = 0.5 if vertical_segments.size() > 0 else 0.0
	if randf() < vertical_prob:
		return { "type": "vertical", "segment": vertical_segments.pick_random() }
	elif horizontal_segments.size() > 0:
		return { "type": "horizontal", "segment": horizontal_segments.pick_random() }
	return {}

func _get_random_position(segment_info: Dictionary) -> Vector2i:
	var segment = segment_info.segment
	if segment_info.type == "vertical":
		var y = randi_range(segment.start.y, segment.end.y)
		return Vector2i(segment.start.x, y)
	else:
		var x = randi_range(segment.start.x, segment.end.x)
		return Vector2i(x, segment.start.y)

func _try_create_corridor(start_pos: Vector2i, base_type: String) -> bool:
	var corridor_type = "horizontal" if base_type == "vertical" else "vertical"
	var direction = _get_random_direction(corridor_type)
	var length = randi_range(1, max_length)
	
	var cells = _build_corridor(start_pos, corridor_type, direction, length)
	if cells.size() == 0: return false
	
	_register_corridor(cells, corridor_type)
	return true

func _get_random_direction(corridor_type: String) -> Vector2i:
	match corridor_type:
		"horizontal": return Vector2i.RIGHT if randf() > 0.5 else Vector2i.LEFT
		"vertical": return Vector2i.DOWN if randf() > 0.5 else Vector2i.UP
	return Vector2i.ZERO

func _build_corridor(start: Vector2i, corridor_type: String, direction: Vector2i, length: int) -> Array:
	var current = start
	var cells = [current]
	
	for _i in range(length-1):
		current += direction
		if deadzone.has(current): return cells
		
		if not _is_in_bounds(current): break
		if not _check_distance(current, corridor_type): return []
		
		cells.append(current)
	
	return cells

func _is_in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 && pos.x < map_size.x && pos.y >= 0 && pos.y < map_size.y

func _check_distance(pos: Vector2i, corridor_type: String) -> bool:
	var segments = horizontal_segments if corridor_type == "horizontal" else vertical_segments
	
	for segment in segments:
		var coord = segment.start.y if corridor_type == "horizontal" else segment.start.x
		var current_coord = pos.y if corridor_type == "horizontal" else pos.x
		
		if abs(coord - current_coord) > min_distance: continue
		
		var min_val = segment.start.x if corridor_type == "horizontal" else segment.start.y
		var max_val = segment.end.x if corridor_type == "horizontal" else segment.end.y
		var check_val = pos.x if corridor_type == "horizontal" else pos.y
		
		if check_val >= min_val && check_val <= max_val: return false
	
	return true

func _register_corridor(cells: Array, corridor_type: String) -> void:
	var sorted = cells.duplicate()
	if corridor_type == "horizontal":
		sorted.sort_custom(func(a,b): return a.x < b.x)
	else:
		sorted.sort_custom(func(a,b): return a.y < b.y)
	
	var new_segment = { "start": sorted.front(), "end": sorted.back() }
	
	if corridor_type == "horizontal":
		horizontal_segments.append(new_segment)
	else:
		vertical_segments.append(new_segment)
	
	for cell in cells:
		map[cell.x][cell.y] = 'C'
