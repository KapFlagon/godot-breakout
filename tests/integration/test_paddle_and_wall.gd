extends GutTest

var _Paddle = load("res://game_objects/Paddle.tscn")
var _paddle_instance: Paddle
var _VerticalWall = load("res://game_objects/VerticalWall.tscn")
var _vertical_wall_instance: Wall


# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_paddle_instance = _Paddle.instance()
	_vertical_wall_instance = _VerticalWall.instance()
	add_child(_paddle_instance)
	add_child(_vertical_wall_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_paddle_instance.free()
	_vertical_wall_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_paddle_collides_with_left_vertical_wall() -> void:
	_paddle_instance.set_position(Vector2(300, 100))
	_vertical_wall_instance.set_position(Vector2(200, 100))
	_paddle_instance.set_target_x_position(150)
	yield(yield_for(0.5), YIELD)
	assert_ne(_paddle_instance.get_position().x, 150.00)
	assert_gt(_paddle_instance.get_position().x, 200.00)
	assert_almost_eq(_paddle_instance.get_position().x, 270.00, 0.5)


func test_paddle_collides_with_right_vertical_wall() -> void:
	_paddle_instance.set_position(Vector2(300, 100))
	_vertical_wall_instance.set_position(Vector2(400, 100))
	_paddle_instance.set_target_x_position(450)
	yield(yield_for(0.5), YIELD)
	assert_ne(_paddle_instance.get_position().x, 450.00)
	assert_lt(_paddle_instance.get_position().x, 400.00)
	assert_almost_eq(_paddle_instance.get_position().x, 330.00, 0.5)
