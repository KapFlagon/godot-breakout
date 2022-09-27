extends GutTest

var _DeadZone = load("res://game_objects/DeadZone.tscn")
var _dead_zone_instance: DeadZone



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_dead_zone_instance = _DeadZone.instance()
	add_child(_dead_zone_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_dead_zone_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_get_set_base_colour() -> void:
	assert_accessors(_dead_zone_instance, "base_colour", Color(1, 1, 1), Color(0.5, 0.5, 0.5))
