extends GutTest

var _Ball = load("res://game_objects/Ball.tscn")
var _Paddle = load("res://game_objects/Paddle.tscn")
var _ball_instance: Ball
var _paddle_instance: Paddle



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_ball_instance = _Ball.instance()
	_paddle_instance = _Paddle.instance()
	add_child(_ball_instance)
	add_child(_paddle_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_ball_instance.free()
	_paddle_instance.free()
	gut.p("ran teardown", 2)


func setup_ball(ball_position: Vector2, ball_direction: Vector2, ball_speed: float):
	_ball_instance.set_position(ball_position)
	_ball_instance.set_direction(ball_direction)
	_ball_instance.set_speed(ball_speed)


func setup_paddle(paddle_position: Vector2):
	_paddle_instance.set_position(paddle_position)


# Tests 
func test_vertical_travelling_ball_bounces_vertically_off_paddle() -> void:
	setup_ball(Vector2(300, 300), Vector2(0, 1), 200)
	setup_paddle(Vector2(300, 350))
	yield(yield_for(0.5), YIELD)
	assert_lt(_ball_instance.position.y, 300.0)
	assert_eq(_ball_instance.position.x, 300.0)


func test_diagonal_left_to_right_travelling_ball_bounces_left_to_right_off_paddle() -> void:
	setup_ball(Vector2(300, 300), Vector2(1, 1), 200)
	setup_paddle(Vector2(300, 350))
	yield(yield_for(0.5), YIELD)
	assert_lt(_ball_instance.position.y, 300.0)
	assert_ne (_ball_instance.position.x, 300.0)
	assert_gt(_ball_instance.position.x, 350.0)


func test_diagonal_right_to_left_travelling_ball_bounces_right_to_left_off_paddle() -> void:
	setup_ball(Vector2(300, 300), Vector2(-1, 1), 200)
	setup_paddle(Vector2(300, 350))
	yield(yield_for(0.5), YIELD)
	assert_lt(_ball_instance.position.y, 300.0)
	assert_ne (_ball_instance.position.x, 300.0)
	assert_lt(_ball_instance.position.x, 350.0)


func test_vertical_travelling_ball_bounces_diagonally_left_to_right_off_paddle_moving_right() -> void:
	setup_ball(Vector2(300, 300), Vector2(0, 1), 200)
	setup_paddle(Vector2(100, 350))
	_paddle_instance.set_target_x_position(350)
	yield(yield_for(0.5), YIELD)
	assert_ne(_ball_instance.position.x, 300.0)
	assert_gt(_ball_instance.position.x, 300.0)
	assert_lt(_ball_instance.position.y, 300.0)
