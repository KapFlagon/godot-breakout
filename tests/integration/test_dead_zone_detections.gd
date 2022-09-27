extends GutTest

var _DeadZone = load("res://game_objects/DeadZone.tscn")
var _dead_zone_instance: DeadZone
var _HorizontalWall = load("res://game_objects/HorizontalWall.tscn")
var _VerticalWall = load("res://game_objects/VerticalWall.tscn")
var _Ball = load("res://game_objects/Ball.tscn")


# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_dead_zone_instance = _DeadZone.instance()
	add_child(_dead_zone_instance)
	_dead_zone_instance.set_position(Vector2(100, 200))
	gut.p("ran setup", 2)


# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_dead_zone_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_ball_triggers_dead_zone_signal() -> void:
	var ball = _Ball.instance()
	add_child(ball)
	ball.set_position(Vector2(100, 100))
	ball.set_speed(500.0)
	ball.set_direction(Vector2(0, 1))
	watch_signals(_dead_zone_instance)
	yield(yield_for(0.3), YIELD)
	assert_signal_emitted(_dead_zone_instance, "ball_is_dead")
	ball.free()


func test_horizontal_wall_does_not_trigger_dead_zone_signal() -> void:
	var h_wall = _HorizontalWall.instance()
	add_child(h_wall)
	watch_signals(_dead_zone_instance)
	yield(yield_for(0.2), YIELD)
	h_wall.set_position(Vector2(50, 200))
	yield(yield_for(0.2), YIELD)
	assert_signal_not_emitted(_dead_zone_instance, "ball_is_dead")
	h_wall.free()


func test_vertical_wall_does_not_trigger_dead_zone_signal() -> void:
	var v_wall = _VerticalWall.instance()
	add_child(v_wall)
	watch_signals(_dead_zone_instance)
	yield(yield_for(0.2), YIELD)
	v_wall.set_position(Vector2(50, 50))
	yield(yield_for(0.2), YIELD)
	assert_signal_not_emitted(_dead_zone_instance, "ball_is_dead")
	v_wall.free()
