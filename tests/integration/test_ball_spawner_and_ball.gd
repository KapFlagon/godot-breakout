extends GutTest

var _BallSpawner = load("res://game_objects/BallSpawner.tscn")
var _ball_spawner_instance: BallSpawner



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_ball_spawner_instance = _BallSpawner.instance()
	add_child(_ball_spawner_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_ball_spawner_instance.free()
	gut.p("ran teardown", 2)


# Tests 
func test_can_be_hidden_and_disabled() -> void:
	_ball_spawner_instance.hide()
	yield(yield_for(0.1), YIELD)
	assert_eq(_ball_spawner_instance.is_visible(), false)
	assert_eq(_ball_spawner_instance.is_ball_spawner_collision_shape_disabled(), true)


func test_can_be_shown() -> void:
	_ball_spawner_instance.hide()
	yield(yield_for(0.1), YIELD)
	_ball_spawner_instance.show()
	yield(yield_for(0.1), YIELD)
	assert_eq(_ball_spawner_instance.is_visible(), true)
	assert_eq(_ball_spawner_instance.is_ball_spawner_collision_shape_disabled(), false)


func test_generates_moving_ball_from_spawner_position() -> void: 
	var spawner_position := Vector2(10, 10)
	var expected_ball_direction := Vector2(0, 1)
	var expected_ball_speed = _ball_spawner_instance.get_ball_speed()
	_ball_spawner_instance.set_position(spawner_position)
	var ball: Ball = _ball_spawner_instance.spawn_ball()
	assert_not_null(ball, "Ball generated")
	assert_eq(ball.get_position(), spawner_position)
	assert_eq(ball.get_direction(), expected_ball_direction)
	assert_eq(ball.get_speed(), expected_ball_speed)
	ball.free()


func test_does_not_generate_ball_if_disabled() -> void:
	_ball_spawner_instance.hide()
	yield(yield_for(0.1), YIELD)	
	assert_eq(_ball_spawner_instance.is_visible(), false)
	assert_eq(_ball_spawner_instance.is_ball_spawner_collision_shape_disabled(), true)
	var ball: Ball = _ball_spawner_instance.spawn_ball()
	assert_null(ball)


func test_ball_starts_moving_after_spawn() -> void:
	var spawner_position := Vector2(100, 400)
	_ball_spawner_instance.set_position(spawner_position)
	var ball: Ball = _ball_spawner_instance.spawn_ball()
	assert_not_null(ball, "Ball generated")
	add_child(ball)
	yield(yield_for(0.5), YIELD)
	assert_gt(ball.get_position().y, 450.0)
	ball.free()


func test_signal_emitted_with_ball_when_spawn_triggered() -> void:
	watch_signals(_ball_spawner_instance)
	var _ball: Ball = _ball_spawner_instance.spawn_ball()
	assert_signal_emitted_with_parameters(_ball_spawner_instance, "ball_spawned", [_ball])
	_ball.free()
