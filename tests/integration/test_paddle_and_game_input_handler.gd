extends GutTest

var _Paddle = load("res://game_objects/Paddle.tscn")
var _GameInputHandler = load("res://game_objects/game_input_handler.gd")
var _paddle_instance: Paddle
var _game_input_handler_instance: GameInputHandler
var _input_sender
var _input_hold_sender = InputSender.new(Input)
var _start_positions := Vector2(500, 300)


# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_paddle_instance = _Paddle.instance()
	_game_input_handler_instance = _GameInputHandler.new()
	setup_mouse_tests()
	_game_input_handler_instance.set_paddle(_paddle_instance)
	add_child(_paddle_instance)
	add_child(_game_input_handler_instance)
	_input_sender = InputSender.new(_game_input_handler_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_paddle_instance.free()
	_game_input_handler_instance.free()
	_input_sender.clear()
	_input_hold_sender.release_all()
	_input_hold_sender.clear()
	gut.p("ran teardown", 2)


func setup_mouse_tests() -> void:
	_paddle_instance.set_position(_start_positions)


# Tests 
func assert_scenario_not_null() -> void:
	assert_not_null(_game_input_handler_instance, "scenario exists")


func test_move_to_mouse_position_left() -> void:
	var offset := Vector2(-73, 400)
	var new_position := _start_positions + offset
	yield(yield_for(0.1), YIELD)
	_input_sender.mouse_motion(new_position)
	yield(yield_to(_input_sender, "idle", 0.5), YIELD)
	assert_almost_eq(_paddle_instance.position.x, new_position.x, 0.5)
	assert_ne(_paddle_instance.position.y, new_position.y)
	assert_eq(_paddle_instance.position.y, _start_positions.y)


func test_move_to_mouse_position_right() -> void:
	var offset := Vector2(73, -150)
	var new_position := _start_positions + offset
	yield(yield_for(0.1), YIELD)
	_input_sender.mouse_motion(new_position)
	yield(yield_to(_input_sender, "idle", 0.5), YIELD)
	assert_almost_eq(_paddle_instance.position.x, new_position.x, 0.5)
	assert_ne(_paddle_instance.position.y, new_position.y)
	assert_eq(_paddle_instance.position.y, _start_positions.y)


func test_move_to_touch_position_left() -> void:
	# InputEventScreenTouch has not been implemented yet in Gut `input_sender.gd` or `input_factory.gd`
	pending()


func test_move_to_touch_position_right() -> void:
	# InputEventScreenTouch has not been implemented yet in Gut `input_sender.gd` or `input_factory.gd`
	pending()


func test_move_left_action() -> void:
	yield(yield_for(0.1), YIELD)
	_input_hold_sender.action_down("move_paddle_left").hold_for(0.5).wait(0.5)
	yield(_input_hold_sender, "idle")
	assert_ne(_paddle_instance.position.x, _start_positions.x)
	assert_lt(_paddle_instance.position.x, _start_positions.x)


func test_move_right_action() -> void:
	yield(yield_for(0.1), YIELD)
	_input_hold_sender.action_down("move_paddle_right").hold_for(0.5).wait(0.5)
	yield(_input_hold_sender, "idle")
	assert_ne(_paddle_instance.position.x, _start_positions.x)
	assert_gt(_paddle_instance.position.x, _start_positions.x)


func test_hold_left_then_move_right_immediately_when_action_changes_direction() -> void:
	# TODO needs better assertions and tests. May need to re-write the setup as position is different depending on test runs (all vs class vs function all have different results)
	yield(yield_for(0.1), YIELD)
	_input_hold_sender.action_down("move_paddle_left").hold_for(0.5)\
			.action_up("move_paddle_left")\
			.action_down("move_paddle_right").hold_for(0.1)\
			.action_up("move_paddle_right").wait(0.5)
	yield(_input_hold_sender, "idle")
	assert_ne(_paddle_instance.position.x, _start_positions.x)
	assert_lt(_paddle_instance.position.x, _start_positions.x)
	assert_gt(_paddle_instance.position.x, 100.0)
	assert_between(_paddle_instance.position.x, 150.0, 300.0)


func test_hold_right_then_move_left_immediately_when_action_changes_direction() -> void:
	# TODO needs better assertions and tests. May need to re-write the setup as position is different depending on test runs (all vs class vs function all have different results)
	yield(yield_for(0.1), YIELD)
	_input_hold_sender.action_down("move_paddle_right").hold_for(0.5)\
			.action_up("move_paddle_right")\
			.action_down("move_paddle_left").hold_for(0.1)\
			.action_up("move_paddle_right").wait(0.5)
	yield(_input_hold_sender, "idle")
	assert_ne(_paddle_instance.position.x, _start_positions.x)
	assert_gt(_paddle_instance.position.x, _start_positions.x)
	assert_lt(_paddle_instance.position.x, 850.0)
	assert_between(_paddle_instance.position.x, 700.0, 850.0)


# TODO May need to add tests for mouse clicks/click-and-drag as well, in case user plays in browser on mobile.
