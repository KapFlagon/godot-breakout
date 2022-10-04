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


func test_can_get_lives_value_lbl() -> void:
	assert_not_null(_game_instance.get_lives_value_lbl())
	assert_eq(int(_game_instance.get_lives_value_lbl().get_text()), 3)


func test_can_get_game_over_prompt() -> void:
	assert_not_null(_game_instance.get_game_over_prompt())


# TODO need to create tests for game logic.
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
		_ball_spawner.spawn_ball()
		yield(yield_for(0.8), YIELD)
		gut.p("DeadZoneGameTest setup", 2)
	
	
	func after_each() -> void:
		remove_child(_game_instance)
		_input_sender.clear()
		_game_instance.free()
		gut.p("DeadZoneGameTest teardown", 2)
	
	
	func test_lives_decrease_when_ball_enters_dead_zone() -> void:
		assert_eq(_game_instance.get_lives(), 2)
	
	
	func test_lives_label_descreases_when_variable_updates_after_ball_enters_dead_zone() -> void:
		assert_eq(_game_instance.get_lives(), int(_game_instance.get_lives_value_lbl().get_text()))
	
	
	func test_ball_is_freed_when_ball_enters_dead_zone() -> void:
		assert_freed(_game_instance.get_ball_instance())
	
	
	func test_game_not_over_and_ball_spawner_shows_when_ball_enters_dead_zone_and_lives_greater_than_0() -> void:
		assert_eq(_game_instance.get_ball_spawner().is_visible(), true)
		assert_eq(_game_instance.is_game_over(), false)
	
	
	func test_game_over_and_ball_spawner_does_not_show_when_ball_enters_dead_zone_and_lives_less_than_1() -> void:
		for i in 2:
			_ball_spawner.spawn_ball()
			yield(yield_for(0.9), YIELD)
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
		_ball_spawner.spawn_ball()
		yield(yield_for(0.8), YIELD)
		gut.p("DeadZoneGameTest setup", 2)
	
	
	func after_each() -> void:
		remove_child(_game_instance)
		_input_sender.clear()
		_game_instance.free()
		gut.p("DeadZoneGameTest teardown", 2)
	
	
	func test_game_not_over_when_lives_greater_than_0() -> void:
		assert_eq(_game_instance.is_game_over(), false)
	
	
	func test_game_over_when_lives_less_than_1() -> void:
		for i in 2:
			_ball_spawner.spawn_ball()
			yield(yield_for(0.9), YIELD)
		assert_eq(_game_instance.is_game_over(), true)
		assert_eq(_game_instance.get_game_over_prompt().is_visible(), true)
	
	# TODO Test clicking Game Over prompt button resets game completely and starts again.
	# TODO Test Game Over state writes high score to memory. 


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
		yield(yield_for(0.1), YIELD)
		_input_sender.mouse_motion(Vector2(1000, 1000))
		yield(yield_to(_input_sender, "idle", 0.1), YIELD)
		_ball_spawner = _game_instance.get_ball_spawner()
		_ball_spawner.spawn_ball()
		yield(yield_for(0.8), YIELD)
		gut.p("DeadZoneGameTest setup", 2)
	
	
	func after_each() -> void:
		remove_child(_game_instance)
		_input_sender.clear()
		_game_instance.free()
		gut.p("DeadZoneGameTest teardown", 2)
	
	
	# TODO Test BrickMapGrid signals a score and updates variables
	# TODO Test BrickMapGrid signals a score and updates labels
	# TODO Test BrickMapGrid signals a score and updates brick hit count
	# TODO Test BrickMapGrid updating brick hit count increments speed a level
	# TODO Test BrickMapGrid updating brick hit count increments speed a second level
	# TODO Test BrickMapGrid destroys current ball on clear
	# TODO Test BrickMapGrid resets all bricks on clear if cleared grids is less than 2
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
