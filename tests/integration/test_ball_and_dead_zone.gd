extends GutTest

var _DeadZone = load("res://game_objects/DeadZone.tscn")
var _Ball = load("res://game_objects/Ball.tscn")
var _dead_zone_instance: DeadZone
var _ball_instance: Ball



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_dead_zone_instance = _DeadZone.instance()
	_ball_instance = _Ball.instance()
	add_child(_dead_zone_instance)
	add_child(_ball_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_dead_zone_instance.free()
	_ball_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_ball_enter_dead_zone_signal_emitted() -> void:
	_ball_instance.set_position(Vector2(200, 200))
	_ball_instance.set_direction(Vector2(0, 1))
	_ball_instance.set_speed(1000)
	_dead_zone_instance.set_position(Vector2(200, 400))
	watch_signals(_dead_zone_instance)
	yield(yield_for(0.5), YIELD)
	assert_signal_emitted_with_parameters(_dead_zone_instance, "ball_is_dead", [])
