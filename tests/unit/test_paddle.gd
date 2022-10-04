extends GutTest

var _Paddle = load("res://game_objects/Paddle.tscn")
var _paddle_instance: Paddle

var _input_sender = InputSender.new()


# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_paddle_instance = _Paddle.instance()
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_paddle_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_can_create_paddle() -> void:
	assert_not_null(_paddle_instance)


func test_get_set_exports_base_colour() -> void:
	assert_accessors(_paddle_instance, "base_colour", Color(1, 1, 1), Color(0.5, 0.5, 0.5))
	assert_exports(_paddle_instance, "_base_colour", TYPE_COLOR)


func test_get_set_target_x_position() -> void:
	assert_accessors(_paddle_instance, "target_x_position", 0.0, 100.0)


func test_get_set_exports_speed() -> void:
	assert_accessors(_paddle_instance, "speed", 10.0, 50.0)
	assert_exports(_paddle_instance, "_speed", TYPE_REAL)


func test_get_set_exports_movement_increment() -> void:
	assert_accessors(_paddle_instance, "movement_increment", 2.0, 15.0)
	assert_exports(_paddle_instance, "_movement_increment", TYPE_REAL)


func test_setting_position_sets_target_position_too() -> void:
	var start_position = Vector2(500, 100)
	_paddle_instance.set_position(start_position)
	assert_eq(_paddle_instance.get_position(), start_position)
	assert_eq(_paddle_instance._target_x_position, start_position.x)


func test_paddle_moves_to_and_stops_at_target_position_left() -> void:
	var original_position := Vector2(500.00, 100.00)
	var _target_position := original_position.x - 200.00
	add_child(_paddle_instance)
	_paddle_instance.set_position(original_position)
	_paddle_instance.set_target_x_position(_target_position)
	simulate(_paddle_instance, 10, .1)
	assert_eq(_paddle_instance.get_position().x, _target_position)
	remove_child(_paddle_instance)


func test_paddle_moves_to_and_stops_at_target_position_right() -> void:
	var original_position := Vector2(500, 100)
	var _target_position := original_position.x + 200.00
	add_child(_paddle_instance)
	_paddle_instance.set_position(original_position)
	_paddle_instance.set_target_x_position(_target_position)
	simulate(_paddle_instance, 10, 0.1)
	assert_eq(_paddle_instance.get_position().x, _target_position)
	remove_child(_paddle_instance)


func test_paddle_moves_left_by_one_increment() -> void:
	var increment: float = _paddle_instance.get_movement_increment()
	var original_position := Vector2(500, 100)
	var target_position: float = original_position.x - increment 
	
	add_child(_paddle_instance)
	_paddle_instance.set_position(Vector2(500, 100))
	_paddle_instance.move_left()
	assert_eq(_paddle_instance.get_target_x_position(), target_position)
	simulate(_paddle_instance, 10, 0.1)
	assert_almost_eq(_paddle_instance.get_position().x, target_position, 0.5)
	remove_child(_paddle_instance)


func test_paddle_moves_right_by_one_increment() -> void:
	var increment: float = _paddle_instance.get_movement_increment()
	var original_position := Vector2(500, 100)
	var target_position: float = increment + original_position.x
	
	add_child(_paddle_instance)
	_paddle_instance.set_position(original_position)
	_paddle_instance.move_right()
	assert_eq(_paddle_instance.get_target_x_position(), target_position)
	simulate(_paddle_instance, 100, 0.01)
	assert_almost_eq(_paddle_instance.get_position().x, target_position, 0.5)
	remove_child(_paddle_instance)


# TODO write tests for particle emission on ball hit.
# TODO write tests for sound effect playback on ball hit.
