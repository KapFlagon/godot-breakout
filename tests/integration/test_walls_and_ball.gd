extends GutTest

var _VerticalWall = load("res://game_objects/VerticalWall.tscn")
var _HorizontalWall = load("res://game_objects/HorizontalWall.tscn")
var _Ball = load("res://game_objects/Ball.tscn")



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	gut.p("ran teardown", 2)



# Tests 
func test_ball_bounces_off_horizontal_wall() -> void:
	var horizontal_wall = _HorizontalWall.instance()
	add_child(horizontal_wall)
	horizontal_wall.set_position(Vector2(100, 100))
	var ball = _Ball.instance()
	add_child(ball)
	var original_ball_position = Vector2(120, 200)
	var original_ball_direction = Vector2(0, -1)
	ball.set_position(original_ball_position)
	ball.set_speed(200)
	ball.set_direction(original_ball_direction)
	
	yield(yield_for(0.5), YIELD)
	
	assert_gt(ball.get_direction().y, original_ball_direction.y)
	assert_false(ball.get_position().y < 100.0)
	assert_gt(ball.get_position().x, 110.0)
	
	remove_child(horizontal_wall)
	horizontal_wall.free()
	remove_child(ball)
	ball.free()
	

func test_ball_bounces_off_vertical_wall() -> void:
	var vertical_wall = _VerticalWall.instance()
	add_child(vertical_wall)
	vertical_wall.set_position(Vector2(100, 100))
	var ball = _Ball.instance()
	add_child(ball)
	var original_ball_position = Vector2(200, 150)
	var original_ball_direction = Vector2(-1, 0)
	ball.set_position(original_ball_position)
	ball.set_speed(200)
	ball.set_direction(original_ball_direction)
	
	yield(yield_for(0.5), YIELD)
	
	assert_gt(ball.get_direction().x, original_ball_direction.x)
	assert_false(ball.get_position().x < 100.0)
	assert_gt(ball.get_position().x, 120.0)
	
	remove_child(vertical_wall)
	vertical_wall.free()
	remove_child(ball)
	ball.free()
	
