extends GutTest

var _Brick = load("res://game_objects/Brick.tscn")
var _brick_instance: Brick
var _Ball = load("res://game_objects/Ball.tscn")
var _ball_instance: Ball



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_brick_instance = _Brick.instance()
	add_child(_brick_instance)
	_ball_instance = _Ball.instance()
	add_child(_ball_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_brick_instance.free()
	_ball_instance.free()
	gut.p("ran teardown", 2)


func brick_and_ball_setup() -> void:
	_brick_instance.set_starting_position(Vector2(200, 240))
	_ball_instance.set_position(Vector2(200, 300))
	_ball_instance.set_speed(200)
	_ball_instance.set_direction(Vector2(0, -1))


# Tests 
func test_ball_up_toward_brick_and_bounces_off_it() -> void:
	brick_and_ball_setup()
	yield(yield_for(0.5), YIELD)
	assert_gt(_ball_instance.get_position().y, 300.0)


func test_brick_cannot_be_hit_second_time() -> void:
	brick_and_ball_setup()
	_ball_instance.set_position(Vector2(180, 300))
	var _second_ball_instance = _Ball.instance()
	add_child(_second_ball_instance)
	_second_ball_instance.set_speed(200)
	_second_ball_instance.set_direction(Vector2(0, -1))
	_second_ball_instance.set_position(Vector2(220, 325))
	yield(yield_for(0.5), YIELD)
	assert_gt(_ball_instance.get_position().y, 300.0)
	assert_lt(_second_ball_instance.get_position().y, 240.0)
	_second_ball_instance.free()


func test_brick_changes_to_hit_status_after_bounce() -> void:
	brick_and_ball_setup()
	yield(yield_for(0.4), YIELD)
	assert_eq(_brick_instance.is_brick_hit(), true)
	assert_eq(_brick_instance.get_base_colour().a, 0)
	assert_eq(_brick_instance.is_collision_disabled(), true)


func test_brick_emits_signal_with_score_value_on_hit() -> void:
	brick_and_ball_setup()
	var _expected_brick_score_value = 3
	_brick_instance.set_score_value(_expected_brick_score_value)
	watch_signals(_brick_instance)
	yield(yield_for(0.4), YIELD)
	assert_signal_emitted_with_parameters(_brick_instance, "brick_was_hit", [_expected_brick_score_value])


func test_brick_can_be_reset_after_hit() -> void:
	brick_and_ball_setup()
	watch_signals(_brick_instance)
	yield(yield_for(0.5), YIELD)
	_brick_instance.set_position(Vector2(10, 10))
	assert_signal_emitted(_brick_instance, "brick_was_hit")
	assert_eq(_brick_instance.is_brick_hit(), true)
	assert_eq(_brick_instance.get_base_colour().a, 0)
	assert_eq(_brick_instance.is_collision_disabled(), true)
	assert_eq(_brick_instance.get_position(), Vector2(10, 10))
	assert_ne(_brick_instance.get_position(), Vector2(200, 240))
	assert_ne(_brick_instance.get_starting_position(), Vector2(10, 10))
	assert_eq(_brick_instance.get_starting_position(), Vector2(200, 240))
	_brick_instance.reset_brick()
	yield(yield_for(0.4), YIELD)
	assert_eq(_brick_instance.is_brick_hit(), false)
	assert_eq(_brick_instance.get_base_colour().a, 1)
	assert_eq(_brick_instance.is_collision_disabled(), false)
	assert_ne(_brick_instance.get_position(), Vector2(10, 10))
	assert_eq(_brick_instance.get_position(), Vector2(200, 240))
	assert_ne(_brick_instance.get_starting_position(), Vector2(10, 10))
	assert_eq(_brick_instance.get_starting_position(), Vector2(200, 240))
