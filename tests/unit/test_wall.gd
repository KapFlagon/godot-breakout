extends GutTest

var _Wall = load("res://game_objects/HorizontalWall.tscn")
var _wall_instance

func before_each() -> void:
	_wall_instance = _Wall.instance()
	gut.p("ran setup", 2)

func after_each() -> void:
	_wall_instance.free()
	gut.p("ran teardown", 2)

func before_all() -> void:
	gut.p("ran run setup", 2)

func after_all() -> void:
	gut.p("ran run teardown", 2)

func test_can_make_wall() -> void:
	assert_not_null(_wall_instance)


# Tests
func test_get_set_base_colour() -> void:
	assert_accessors(_wall_instance, "base_colour", Color(1, 1, 1), Color(0.5, 0.5, 0.5))
