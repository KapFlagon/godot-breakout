extends GutTest

var _Brick = load("res://game_objects/Brick.tscn")
var _brick_instance: Brick



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_brick_instance = _Brick.instance()
	add_child(_brick_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	remove_child(_brick_instance)
	_brick_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_can_create_brick() -> void:
	assert_not_null(_brick_instance)


func test_get_set_starting_position() -> void:
	assert_accessors(_brick_instance, "starting_position", Vector2(0.0, 0.0), Vector2(100.0, 100.0))


func test_get_set_base_colour() -> void:
	assert_accessors(_brick_instance, "base_colour", Color(1, 1, 1), Color(0.5, 0.5, 0.5))


func test_get_set_is_hit() -> void:
	assert_accessors(_brick_instance, "brick_hit", false, true)


func test_get_set_score_value() -> void:
	assert_accessors(_brick_instance, "score_value", 1, 5)


func test_is_collision_disabled() -> void:
	assert_eq(_brick_instance.is_collision_disabled(), false)


func test_position_is_same_as_starting_position() -> void:
	var test_start_position := Vector2(10, 20)
	_brick_instance.set_starting_position(test_start_position)
	assert_eq(_brick_instance.get_position(), test_start_position)
	assert_eq(_brick_instance.get_starting_position(), test_start_position)


func test_brick_can_build_opaque_base_colour() -> void:
	var colour: Color = _brick_instance._build_opaque_colour()
	assert_eq(colour.a, 0)


func test_brick_can_build_solid_base_colour() -> void:
	var colour: Color = _brick_instance._build_solid_colour()
	assert_eq(colour.a, 1)


# TODO write tests for particle emission on ball hit.
# TODO write tests for sound effect playback on ball hit.
