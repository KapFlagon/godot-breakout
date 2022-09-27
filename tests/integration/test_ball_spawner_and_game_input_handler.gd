extends GutTest

var _GameInputHandler = load("res://game_objects/game_input_handler.gd")
var _game_input_handler_instance: GameInputHandler
var _BallSpawner = load("res://game_objects/BallSpawner.tscn")
var _Paddle = load("res://game_objects/Paddle.tscn")
var _ball_spawner_instance: BallSpawner
var _ball_spawner_double
var _input_sender


# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_game_input_handler_instance = _GameInputHandler.new()
	_ball_spawner_double = double(_BallSpawner).instance()
	_game_input_handler_instance.set_ball_spawner(_ball_spawner_double)
	_game_input_handler_instance.set_paddle(double(_Paddle).instance())
	add_child(_game_input_handler_instance)
	_input_sender = InputSender.new(_game_input_handler_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_ball_spawner_double.free()
	_game_input_handler_instance.free()
	_input_sender.clear()
	gut.p("ran teardown", 2)


# Tests 
func test_ball_spawns_on_action_event() -> void:
	yield(yield_for(0.1), YIELD)
	_input_sender.action_down("launch_ball").wait("10f")
	yield(_input_sender, "idle")
	assert_called(_ball_spawner_double, "spawn_ball")
