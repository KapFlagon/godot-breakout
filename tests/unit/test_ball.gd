extends GutTest

var _Ball = load("res://game_objects/Ball.tscn")
var _ball_instance: Ball



# Test setup functions
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_ball_instance = _Ball.instance()
	gut.p("ran setup", 2)



# Test teardown functions
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_ball_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_can_create_ball() -> void:
	assert_not_null(_ball_instance, "Ball should not be null!")


func test_get_set_speed() -> void:
	assert_accessors(_ball_instance, "speed", 0.0, 100.0)


func test_get_set_direction() -> void:
	assert_accessors(_ball_instance, "direction", Vector2(0.0, 0.0), Vector2(1.0, 1.0).normalized())


func _setup_ball_physics_scenario(direction: Vector2):
	_ball_instance.set_speed(10)
	_ball_instance.set_direction(direction)
	add_child_autofree(_ball_instance)


func test_ball_moves_during_physics_processing() -> void:
	_setup_ball_physics_scenario(Vector2(1.0, 0.0))
	simulate(_ball_instance, 1, 1)
	assert_eq(_ball_instance.get_position(), Vector2(10.0, 0.0))


func test_ball_moves_vertically_during_physics_processing() -> void:
	_setup_ball_physics_scenario(Vector2(0.0, 1.0))
	simulate(_ball_instance, 1, 0.5)
	assert_eq(_ball_instance.get_position(), Vector2(0.0, 5.0))


func test_set_direction_normalizes_vector() -> void:
	var direction = Vector2(500.0, 500.0)
	_ball_instance.set_direction(direction)
	assert_eq(_ball_instance.get_direction(), direction.normalized())


func test_get_set_base_colour() -> void:
	assert_accessors(_ball_instance, "base_colour", Color(1, 1, 1), Color(0.5, 0.5, 0.5))
