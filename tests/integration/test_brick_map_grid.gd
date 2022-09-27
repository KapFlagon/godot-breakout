extends GutTest

var _BrickMapGrid = load("res://game_objects/BrickMapGrid.tscn")
var _brick_map_grid_instance: BrickMapGrid



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_brick_map_grid_instance = _BrickMapGrid.instance()
	add_child(_brick_map_grid_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_brick_map_grid_instance.free()
	gut.p("ran teardown", 2)


# Other setup
func flip_all_bricks_to_hit() -> void:
	for brick in _brick_map_grid_instance.get_brick_array():
		brick._disable_brick_after_hit()


# Tests 
func test_generated_and_not_null() -> void:
	assert_not_null(_brick_map_grid_instance, "brick map grid created")


func test_all_bricks_are_generated() -> void:
	assert_gt(_brick_map_grid_instance.get_brick_array().size(), 0)
	assert_eq(_brick_map_grid_instance.get_brick_array().size(), (8 * 14))


func test_expected_bricks_are_generated_with_colour_and_score() -> void:
	var bricks = _brick_map_grid_instance.get_brick_array()
	var expected_red_brick: Brick = bricks[0]
	var expected_orange_brick: Brick = bricks[28]
	var expected_green_brick: Brick = bricks[56]
	var expected_yellow_brick: Brick = bricks[84]
	assert_eq(expected_red_brick.get_base_colour(), Color.red)
	assert_eq(expected_red_brick.get_score_value(), 7)
	assert_eq(expected_orange_brick.get_base_colour(), Color.orange)
	assert_eq(expected_orange_brick.get_score_value(), 5)
	assert_eq(expected_green_brick.get_base_colour(), Color.green)
	assert_eq(expected_green_brick.get_score_value(), 3)
	assert_eq(expected_yellow_brick.get_base_colour(), Color.yellow)
	assert_eq(expected_yellow_brick.get_score_value(), 1)


func test_all_bricks_cleared_signal_emitted_when_last_brick_hit() -> void:
	watch_signals(_brick_map_grid_instance)
	flip_all_bricks_to_hit()
	assert_signal_emitted(_brick_map_grid_instance, "all_bricks_cleared")


func test_reset_bricks_grid() -> void:
	flip_all_bricks_to_hit()
	assert_eq(_brick_map_grid_instance.get_brick_array()[0].is_brick_hit(), true)
	watch_signals(_brick_map_grid_instance)
	_brick_map_grid_instance.reset_bricks_grid()
	assert_eq(_brick_map_grid_instance.get_brick_array()[0].is_brick_hit(), false)
	assert_eq(_brick_map_grid_instance.is_first_orange_brick_hit(), false)
	assert_eq(_brick_map_grid_instance.is_first_red_brick_hit(), false)
	assert_signal_emitted(_brick_map_grid_instance, "all_bricks_reset")


func test_signal_player_scored_with_score_value_when_brick_hit_in_grid() -> void:
	watch_signals(_brick_map_grid_instance)
	_brick_map_grid_instance.get_brick_array()[0]._disable_brick_after_hit()
	assert_signal_emitted_with_parameters(_brick_map_grid_instance, "player_scored", [7])


func test_signal_emitted_when_first_orange_brick_hit_in_grid() -> void:
	watch_signals(_brick_map_grid_instance)
	var bricks = _brick_map_grid_instance.get_brick_array()
	var expected_red_brick: Brick = bricks[0]
	var expected_green_brick: Brick = bricks[56]
	var expected_yellow_brick: Brick = bricks[84]
	var first_orange_brick: Brick = bricks[28]
	var second_orange_brick: Brick = bricks[29]
	first_orange_brick._disable_brick_after_hit()
	expected_green_brick._disable_brick_after_hit()
	expected_yellow_brick._disable_brick_after_hit()
	second_orange_brick._disable_brick_after_hit()
	expected_red_brick._disable_brick_after_hit()
	assert_signal_emit_count(_brick_map_grid_instance, "first_orange_brick_hit", 1)
	assert_signal_emit_count(_brick_map_grid_instance, "player_scored", 5)
	first_orange_brick.free()
	second_orange_brick.free()
	expected_yellow_brick.free()
	expected_green_brick.free()
	expected_red_brick.free()


func test_signal_emitted_when_first_red_brick_hit_in_grid() -> void:
	watch_signals(_brick_map_grid_instance)
	var bricks = _brick_map_grid_instance.get_brick_array()
	var expected_orange_brick: Brick = bricks[28]
	var expected_green_brick: Brick = bricks[56]
	var expected_yellow_brick: Brick = bricks[84]
	var first_red_brick: Brick = bricks[0]
	var second_red_brick: Brick = bricks[1]
	first_red_brick._disable_brick_after_hit()
	expected_green_brick._disable_brick_after_hit()
	expected_yellow_brick._disable_brick_after_hit()
	second_red_brick._disable_brick_after_hit()
	expected_orange_brick._disable_brick_after_hit()
	assert_signal_emit_count(_brick_map_grid_instance, "first_red_brick_hit", 1)
	assert_signal_emit_count(_brick_map_grid_instance, "player_scored", 5)
	first_red_brick.free()
	second_red_brick.free()
	expected_yellow_brick.free()
	expected_green_brick.free()
	expected_orange_brick.free()
