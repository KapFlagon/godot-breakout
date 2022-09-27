extends GutTest

var _BallSpawner = load("res://game_objects/BallSpawner.tscn")
var _ball_spawner_instance: BallSpawner



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_ball_spawner_instance = _BallSpawner.instance()
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_ball_spawner_instance.free()
	gut.p("ran teardown", 2)


# Tests 
func test_generated_and_not_null() -> void:
	assert_not_null(_ball_spawner_instance, "Ball Spawner created successfully")


func test_is_ball_spawner_collision_shape_enabled() -> void:
	add_child(_ball_spawner_instance)
	assert_false(_ball_spawner_instance.is_ball_spawner_collision_shape_disabled())


func test_get_set_exports_ball_speed() -> void:
	assert_accessors(_ball_spawner_instance, "ball_speed", 150.0, 200.0)
	assert_exports(_ball_spawner_instance, "_ball_speed", TYPE_REAL)

