extends GutTest

var _BallTrail = load("res://game_objects/BallTrail.tscn")
var _ball_trail_instance: BallTrail



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_ball_trail_instance = _BallTrail.instance()
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_ball_trail_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_get_set_trail_length() -> void:
	assert_accessors(_ball_trail_instance, "trail_length", 5, 2)


func test_get_set_point() -> void:
	assert_accessors(_ball_trail_instance, "point", Vector2(0,0), Vector2(2,2))
