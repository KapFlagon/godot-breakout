extends TileMap

class_name BrickMapGrid


signal all_bricks_cleared
signal all_bricks_reset
signal player_scored(score)
signal first_orange_brick_hit
signal first_red_brick_hit


var _BrickGenerator = preload("res://game_objects/brick_generator.gd")
var _brick_generator_instance: BrickGenerator
var _brick_array = []
var _first_orange_brick_hit = false
var _first_red_brick_hit = false



# Virtual function
func _ready() -> void:
	_brick_generator_instance = _BrickGenerator.new()
	_replace_placeholders_with_bricks()


# Getters and Setters
func get_brick_array():
	return _brick_array


func is_first_orange_brick_hit() -> bool:
	return _first_orange_brick_hit


func is_first_red_brick_hit() -> bool:
	return _first_red_brick_hit


# Public functions
func reset_bricks_grid() -> void:
	for brick in _brick_array:
		brick.reset_brick()
	_first_orange_brick_hit = false
	_first_red_brick_hit = false
	emit_signal("all_bricks_reset")


# Private functions
func _replace_placeholders_with_bricks() -> void:
	var size_x_offset = get_cell_size().x / 2
	var size_y_offset = get_cell_size().y / 2
	var used_cells = get_used_cells_by_id(0)
	for cell_position in used_cells :
		var _brick_instance: Brick = _generate_brick_based_on_row(cell_position.y)
		var offset_position = map_to_world(cell_position) * scale + Vector2(size_x_offset, size_y_offset)
		add_child(_brick_instance)
		_brick_instance.set_starting_position(offset_position)
		var _error_code = _brick_instance.connect("brick_was_hit", self, "_check_if_grid_is_cleared")
		_brick_array.append(_brick_instance)
		set_cellv(cell_position, -1)


func _check_if_grid_is_cleared(score) -> void:
	emit_signal("player_scored", score)
	if !_first_orange_brick_hit and score == 5:
		_first_orange_brick_hit = true
		emit_signal("first_orange_brick_hit")
	if !_first_red_brick_hit and score == 7:
		_first_red_brick_hit = true
		emit_signal("first_red_brick_hit")
	for brick in _brick_array:
		if !brick.is_brick_hit():
			return
	emit_signal("all_bricks_cleared")


func _generate_brick_based_on_row(row_value: int) -> Brick:
	if row_value == 0 or row_value == 1:
		return _brick_generator_instance.generate_red_brick()
	elif row_value == 2 or row_value == 3:
		return _brick_generator_instance.generate_orange_brick()
	elif row_value == 4 or row_value == 5:
		return _brick_generator_instance.generate_green_brick()
	else:
		return _brick_generator_instance.generate_yellow_brick()

