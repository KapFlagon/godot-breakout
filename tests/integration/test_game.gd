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
	
	# TODO Test clicking Game Over prompt button resets game completely and starts again.
	# TODO Test Game Over state writes high score to memory if it is a valid high score. 


class TestGameBrickMapGrid:
	extends GutTest
	
	var _Game = load("res://game_objects/Game.tscn")
	var _game_instance
	var _ball_spawner: BallSpawner
	var _input_sender
	
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
		assert_eq(_game_instance.get_ball_speed_level(), 1)
		assert_eq(_game_instance.get_ball_speeds()[1], _ball_instance.get_speed())
	
	
	func test_bricks_hit_count_increments_speed_twice_after_12_hits()-> void: 
		var _ball_instance:Ball = _game_instance.get_ball_instance()
		_ball_instance.set_direction(Vector2(0, 0))
		var _brick_map_grid: BrickMapGrid = _game_instance.get_brick_map_grid()
		for i in 11:
			_brick_map_grid.emit_signal("player_scored", 1)
		assert_eq(_game_instance.get_score(), 12)
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
	
	
	func test_brick_map_grid_does_not_trigger_grid_reset_on_grid_clear_if_max_boards_cleared_is_reached() -> void:
		pending()
#		var _brick_map_grid:BrickMapGrid = _game_instance.get_brick_map_grid()
#		watch_signals(_brick_map_grid)
#		var _bricks_array = _brick_map_grid.get_brick_array()
#		var _ball:Ball = _game_instance.get_ball_instance()
#		while _game_instance.get_grids_cleared() < _game_instance.MAX_GRID_CLEARS:
#			for brick_element in _bricks_array:
#				brick_element._disable_brick_after_hit()
#			yield(yield_for(0.2), YIELD)
#		assert_eq(_game_instance.get_grids_cleared(), _game_instance.MAX_GRID_CLEARS)
#		assert_eq(_game_instance.is_game_over(), true)
#		assert_eq(_game_instance.get_game_over_prompt().is_visible(), true)
		
		
	# TODO Test BrickMapGrid resets all bricks on clear if cleared grids is less than max
	# TODO Test BrickMapGrid triggers game over if cleared grids is greater than 1
	# TODO Test BrickMapGrid signal for successful reset changes brick hits to zero
	# TODO Test BrickMapGrid signal for successful reset shows the ball spawner
	# TODO Test BrickMapGrid signal for hitting first orange brick increments ball speed a level
	# TODO Test BrickMapGrid signal for hitting first red brick increments ball speed a level
	# TODO Test BrickMapGrid signal for hitting first red brick shrinks ball size.
	
	
# TODO TestGameBallSpawner test that ball is added with specific speed
# TODO TestGameBallSpawner test that spawner is hidden when ball is created
# TODO TestGameBallSpawner test that signals are connected between ball and paddle for screen shake
# TODO TestGameBallSpawner test that signals are connected between ball and paddle for particle emision
# TODO TestCameraShake test for camera screen shake on ball and paddle hit.
# TODO TestCameraShake test for camera screen shake on ball and brick hit.
# TODO TestCameraShake test for camera screen shake on ball and deadzone collision. 
