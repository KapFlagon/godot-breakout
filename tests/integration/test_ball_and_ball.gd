extends GutTest

var _Ball = load("res://game_objects/Ball.tscn")
var _first_ball_instance: Ball
var _second_ball_instance: Ball




# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_first_ball_instance = _Ball.instance()
	add_child(_first_ball_instance)
	_first_ball_instance.set_speed(200)
	_second_ball_instance = _Ball.instance()
	add_child(_second_ball_instance)
	_second_ball_instance.set_speed(200)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_first_ball_instance.free()
	_second_ball_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_ball_will_collide_with_ball() -> void:
	_first_ball_instance.set_position(Vector2(100, 100))
	_first_ball_instance.set_direction(Vector2(0, 1))
	_second_ball_instance.set_position(Vector2(100, 200))
	_second_ball_instance.set_direction(Vector2(0, -1))
	yield(yield_for(0.5), YIELD)
	assert_lt(_first_ball_instance.get_position().y, 100.0)
	assert_gt(_second_ball_instance.get_position().y, 200.0)


func test_ball_will_collide_with_ball_at_angle() -> void:
	_first_ball_instance.set_position(Vector2(100, 100))
	_first_ball_instance.set_direction(Vector2(0, 1))
	_second_ball_instance.set_position(Vector2(150, 200))
	_second_ball_instance.set_direction(Vector2(-1, -1))
	yield(yield_for(0.5), YIELD)
	assert_gt(_first_ball_instance.get_position().y, 150.0)
	assert_gt(_second_ball_instance.get_position().y, 100.0)
