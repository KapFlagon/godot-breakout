extends GutTest

var _Game = load("res://game_objects/Game.tscn")
var _game_instance
var _input_sender


# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_game_instance = _Game.instance()
	_input_sender = InputSender.new(_game_instance)
	add_child(_game_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	remove_child(_game_instance)
	_input_sender.clear()
	_game_instance.free()
	gut.p("ran teardown", 2)


# Tests 
func test_can_create_game() -> void:
	assert_not_null(_game_instance)


func test_can_get_game_ball_spawner() -> void:
	assert_not_null(_game_instance.get_ball_spawner())


func test_can_get_lives() -> void:
	assert_eq(_game_instance.get_lives(), 3)


func test_can_get_ball_instance() -> void:
	var _ball_spawner = _game_instance.get_ball_spawner()
	_ball_spawner.spawn_ball()
	assert_not_null(_game_instance.get_ball_instance())


func test_is_game_over() -> void:
	assert_eq(_game_instance.is_game_over(), false)


func test_can_get_lives_value_lbl_text() -> void:
	assert_not_null(_game_instance.get_lives_value_lbl_text())
	assert_eq(_game_instance.get_lives_value_lbl_text(), "3")


func test_can_get_game_over_prompt() -> void:
	assert_not_null(_game_instance.get_game_over_prompt())


func test_can_get_brick_map_grid() -> void:
	assert_not_null(_game_instance.get_brick_map_grid())


func test_can_get_score() -> void:
	assert_not_null(_game_instance.get_score())
	assert_eq(_game_instance.get_score(), 0)


func test_can_get_score_value_lbl_text() -> void:
	assert_not_null(_game_instance.get_score_value_lbl_text())
	assert_eq(_game_instance.get_score_value_lbl_text(), "000")


func test_can_get_ball_speed_level() -> void:
	assert_not_null(_game_instance.get_ball_speed_level())
	assert_eq(_game_instance.get_ball_speed_level(), 0)


func test_can_get_ball_speeds() -> void:
	assert_not_null(_game_instance.get_ball_speeds())
	var test_array = [150, 175, 205, 240, 280]
	assert_eq_shallow(_game_instance.get_ball_speeds(), test_array)


func test_can_get_grids_cleared() -> void:
	assert_not_null(_game_instance.get_grids_cleared())
	assert_eq(_game_instance.get_grids_cleared(), 0)


func test_can_get_max_grid_clears_constant() -> void:
	assert_not_null(_game_instance.MAX_GRID_CLEARS)
	assert_eq(_game_instance.MAX_GRID_CLEARS, 2)


func test_can_get_brick_hits() -> void:
	assert_eq(_game_instance.get_brick_hits(), 0)


func test_can_get_paddle() -> void:
	assert_not_null(_game_instance.get_paddle())


func test_is_ball_size_halved() -> void:
	assert_eq(_game_instance.is_ball_size_halved(), false)


class TestGameDeadZone:
	extends GutTest
	
	var _Game = load("res://game_objects/Game.tscn")
	var _game_instance
	var _ball_spawner: BallSpawner
	var _input_sender
	
	func before_each() -> void:
		_game_instance = _Game.instance()
		_input_sender = InputSender.new(_game_instance)
		add_child(_game_instance)
		yield(yield_for(0.1), YIELD)
		_input_sender.mouse_motion(Vector2(1000, 1000))
		yield(yield_to(_input_sender, "idle", 0.1), YIELD)
		_ball_spawner = _game_instance.get_ball_spawner()
		var _ball = _ball_spawner.spawn_ball()
		yield(yield_for(1.3), YIELD)
		gut.p("TestGameDeadZone setup", 2)
	
	
	func after_each() -> void:
		remove_child(_game_instance)
		_input_sender.clear()
		_game_instance.free()
		gut.p("TestGameDeadZone teardown", 2)
	
	
	func test_lives_decrease_when_ball_enters_dead_zone() -> void:
		assert_eq(_game_instance.get_lives(), 2)
	
	
	func test_lives_label_descreases_when_variable_updates_after_ball_enters_dead_zone() -> void:
		assert_eq(int(_game_instance.get_lives_value_lbl_text()), _game_instance.get_lives())
	
	
	func test_ball_is_freed_when_ball_enters_dead_zone() -> void:
		assert_freed(_game_instance.get_ball_instance())
	
	
	func test_game_not_over_and_ball_spawner_shows_when_ball_enters_dead_zone_and_lives_greater_than_0() -> void:
		assert_eq(_game_instance.get_ball_spawner().is_visible(), true)
		assert_eq(_game_instance.is_game_over(), false)
	
	
	func test_game_over_and_ball_spawner_does_not_show_when_ball_enters_dead_zone_and_lives_less_than_1() -> void:
		for i in 2:
			var _ball = _ball_spawner.spawn_ball()
			yield(yield_for(1.3), YIELD)
		assert_eq(_game_instance.get_ball_spawner().is_visible(), false)


class TestGameOver:
	extends GutTest
	
	var _Game = load("res://game_objects/Game.tscn")
	var _game_instance
	var _ball_spawner: BallSpawner
	var _input_sender
	
	func before_each() -> void:
		_game_instance = _Game.instance()
		_input_sender = InputSender.new(_game_instance)
		add_child(_game_instance)
		yield(yield_for(0.1), YIELD)
		_input_sender.mouse_motion(Vector2(1000, 1000))
		yield(yield_to(_input_sender, "idle", 0.1), YIELD)
		_ball_spawner = _game_instance.get_ball_spawner()
		var _ball = _ball_spawner.spawn_ball()
		yield(yield_for(1.3), YIELD)
		gut.p("TestGameOver setup", 2)
	
	
	func after_each() -> void:
		remove_child(_game_instance)
		_input_sender.clear()
		_game_instance.free()
		gut.p("TestGameOver teardown", 2)
	
	
	func test_game_not_over_when_lives_greater_than_0() -> void:
		assert_eq(_game_instance.is_game_over(), false)
	
	
	func test_game_over_when_lives_less_than_1() -> void:
		for i in 2:
			var _ball = _ball_spawner.spawn_ball()
			yield(yield_for(1.3), YIELD)
		assert_eq(_game_instance.is_game_over(), true)
		assert_eq(_game_instance.get_game_over_prompt().is_visible(), true)
	
	# TODO Test clicking Game Over "play again"prompt button resets game completely and starts again.
	# TODO Test Game Over state writes high score to memory if it is a valid high score. 


class TestGameBrickMapGrid:
	extends GutTest
	
	var _Game = load("res://game_objects/Game.tscn")
	var _game_instance
	var _ball_spawner: BallSpawner
	var _input_sender
	
	
	# Setup and Teardown
	func before_each() -> void:
		_game_instance = _Game.instance()
		_input_sender = InputSender.new(_game_instance)
		add_child(_game_instance)
		watch_signals(_game_instance.get_brick_map_grid())
		yield(yield_for(0.1), YIELD)
		_ball_spawner = _game_instance.get_ball_spawner()
		var _ball = _ball_spawner.spawn_ball()
		yield(yield_for(2), YIELD)
		gut.p("TestGameBrickMapGrid setup", 2)
	
	
	func after_each() -> void:
		remove_child(_game_instance)
		_input_sender.clear()
		_game_instance.free()
		gut.p("TestGameBrickMapGrid teardown", 2)
	
	
	# Helper functions
	func get_first_brick_of_type(brick_array, colour: Color) -> Brick:
		for brick in brick_array:
			if brick.get_base_colour() == colour:
				return brick
		return null
	
	
	# Tests
	func test_score_signaled_to_game_and_score_variables_is_updated() -> void:
		assert_signal_emitted(_game_instance.get_brick_map_grid(), "player_scored")
		assert_eq(_game_instance.get_score(), 1)
	
	
	func test_score_signaled_to_game_and_score_label_is_updated() -> void:
		assert_signal_emitted(_game_instance.get_brick_map_grid(), "player_scored")
		assert_eq(int(_game_instance.get_score_value_lbl_text()), _game_instance.get_score())
	
	
	func test_brick_hit_signaled_updates_brick_hit_count() -> void:
		assert_signal_emitted(_game_instance.get_brick_map_grid(), "brick_hit")
	
	
	func test_bricks_hit_count_increments_speed_once_after_4_hits() -> void:
		var _ball_instance:Ball = _game_instance.get_ball_instance()
		_ball_instance.set_direction(Vector2(0, 0))
		var _brick_map_grid: BrickMapGrid = _game_instance.get_brick_map_grid()
		for i in 3:
			_brick_map_grid.emit_signal("player_scored", 1)
		assert_eq(_game_instance.get_score(), 4)
		assert_eq(_game_instance.get_brick_hits(), 4)
		assert_eq(_game_instance.get_ball_speed_level(), 1)
		assert_eq(_game_instance.get_ball_speeds()[1], _ball_instance.get_speed())
	
	
	func test_bricks_hit_count_increments_speed_twice_after_12_hits()-> void: 
		var _ball_instance:Ball = _game_instance.get_ball_instance()
		_ball_instance.set_direction(Vector2(0, 0))
		var _brick_map_grid: BrickMapGrid = _game_instance.get_brick_map_grid()
		for i in 11:
			_brick_map_grid.emit_signal("player_scored", 1)
		assert_eq(_game_instance.get_score(), 12)
		assert_eq(_game_instance.get_brick_hits(), 12)
		assert_eq(_game_instance.get_ball_speed_level(), 2)
		assert_eq(_game_instance.get_ball_speeds()[2], _ball_instance.get_speed())
	
	
	func test_brick_map_grid_triggers_ball_destruction_on_grid_clear() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var _ball:Ball = _game_instance.get_ball_instance()
		for brick_element in _bricks_array:
			brick_element._disable_brick_after_hit()
		yield(yield_for(0.2), YIELD)
		assert_signal_emitted(_brick_map_grid, "all_bricks_cleared")
		assert_signal_emitted(_brick_map_grid, "all_bricks_reset")
		assert_freed(_ball)
	
	
	func test_brick_map_grid_triggers_grid_cleared_signal_after_all_bricks_hit() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var _ball:Ball = _game_instance.get_ball_instance()
		for brick_element in _bricks_array:
			brick_element._disable_brick_after_hit()
		assert_signal_emitted(_brick_map_grid, "all_bricks_cleared")
	
	
	func test_brick_map_grid_triggers_grid_reset_on_grid_clear_if_max_boards_cleared_is_not_reached() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var _ball:Ball = _game_instance.get_ball_instance()
		for brick_element in _bricks_array:
			brick_element._disable_brick_after_hit()
		assert_eq(_game_instance.get_grids_cleared(), 1)
		assert_signal_emitted(_brick_map_grid, "all_bricks_reset")
	
	
	func test_speed_level_resets_after_board_clear() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var _ball:Ball = _game_instance.get_ball_instance()
		for brick_element in _bricks_array:
			brick_element._disable_brick_after_hit()
		assert_eq(_game_instance.get_ball_speed_level(), 0)
	
	
	func test_bricks_hit_count_resets_after_board_clear() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var _ball:Ball = _game_instance.get_ball_instance()
		for brick_element in _bricks_array:
			brick_element._disable_brick_after_hit()
		assert_eq(_game_instance.get_brick_hits(), 0)
	
	
	func test_ball_spawner_shows_after_board_clear_if_less_than_max_clears() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var _ball:Ball = _game_instance.get_ball_instance()
		for brick_element in _bricks_array:
			brick_element._disable_brick_after_hit()
		assert_eq(_game_instance.get_ball_spawner().is_visible(), true)
	
	
	func test_brick_map_grid_does_not_trigger_grid_reset_on_grid_clear_if_max_boards_cleared_is_reached() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var _ball:Ball = _game_instance.get_ball_instance()
		while _game_instance.get_grids_cleared() < _game_instance.MAX_GRID_CLEARS:
				for brick_element in _bricks_array:
					brick_element._disable_brick_after_hit()
		assert_eq(_game_instance.get_grids_cleared(), _game_instance.MAX_GRID_CLEARS)
		assert_eq(_game_instance.is_game_over(), true)
		assert_eq(_game_instance.get_game_over_prompt().is_visible(), true)
	
	
	func test_hitting_first_orange_brick_increments_ball_speed_by_one_level() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var orange_brick:Brick = get_first_brick_of_type(_bricks_array, Color.orange)
		orange_brick.emit_signal("brick_was_hit", orange_brick.get_score_value())
		assert_signal_emitted(_brick_map_grid, "first_orange_brick_hit")
		assert_eq(_game_instance.get_ball_speed_level(), 1)
	
	
	func test_hitting_first_red_brick_increments_ball_speed_by_one_level() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var red_brick:Brick = get_first_brick_of_type(_bricks_array, Color.red)
		red_brick.emit_signal("brick_was_hit", red_brick.get_score_value())
		assert_signal_emitted(_brick_map_grid, "first_red_brick_hit")
		assert_eq(_game_instance.get_ball_speed_level(), 1)
	
	
	func test_hitting_first_red_brick_shrinks_ball_size_by_half() -> void:
		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
		watch_signals(_brick_map_grid)
		var _bricks_array = _brick_map_grid.get_brick_array()
		var red_brick:Brick = get_first_brick_of_type(_bricks_array, Color.red)
		red_brick.emit_signal("brick_was_hit", red_brick.get_score_value())
		assert_eq(_game_instance.is_ball_size_halved(), true)
		assert_eq(_game_instance.get_ball_instance().get_collision_shape_radius(), 5)


class TestGameBallSpawner:
	extends GutTest
	
	var _Game = load("res://game_objects/Game.tscn")
	var _game_instance
	var _ball_spawner: BallSpawner
	var _input_sender
	
	
	# Setup and Teardown
	func before_each() -> void:
		_game_instance = _Game.instance()
		_input_sender = InputSender.new(_game_instance)
		add_child(_game_instance)
		watch_signals(_game_instance.get_brick_map_grid())
		yield(yield_for(0.1), YIELD)
		_ball_spawner = _game_instance.get_ball_spawner()
		gut.p("TestGameBrickMapGrid setup", 2)
	
	
	func after_each() -> void:
		remove_child(_game_instance)
		_input_sender.clear()
		_game_instance.free()
		gut.p("TestGameBrickMapGrid teardown", 2)
	
	
	# Helper functions
	
	
	# Tests
	func test_ball_is_spawned_at_start_of_game_with_initial_speed() -> void:
		var _ball:Ball = _ball_spawner.spawn_ball()
		assert_eq(_ball.get_speed(), _game_instance.get_ball_speeds()[0])
	
	
	func test_ball_spawned_after_4_hits_spawns_with_speed_level_value() -> void:
		var _ball:Ball = _ball_spawner.spawn_ball()
		var _brick_map_grid: BrickMapGrid = _game_instance.get_brick_map_grid()
		for i in 4:
			_brick_map_grid.emit_signal("player_scored", 1)
		_ball.free()
		_ball = _ball_spawner.spawn_ball()
		assert_eq(_ball.get_speed(), _game_instance.get_ball_speeds()[1])
	
	
	func test_ball_spawner_is_hidden_when_ball_is_created() -> void:
		var _ball:Ball = _ball_spawner.spawn_ball()
		assert_not_null(_ball)
		assert_eq(_ball_spawner.is_visible(), false)
	
	
	func test_ball_spawner_signals_are_connected_from_ball_to_paddle_for_screen_shake() -> void:
		var _ball:Ball = _ball_spawner.spawn_ball()
		assert_connected(_ball, _game_instance.get_paddle(), "ball_collides_with_paddle")
	
	
	func test_ball_spawner_signals_are_connected_from_ball_to_paddle_for_particle_emission() -> void:
		var _ball:Ball = _ball_spawner.spawn_ball()
#		assert_connected(_ball, _game_instance.get_paddle(), "ball_collides_with_paddle")
		# DESIGN should there be a separate signal to trigger particle emission?
		pending()
	
	


# TODO TestCameraShake test for camera screen shake on ball and paddle hit.
# TODO TestCameraShake test for camera screen shake on ball and brick hit.
# TODO TestCameraShake test for camera screen shake on ball and deadzone collision. 
