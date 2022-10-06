extends Node2D


const MAX_GRID_CLEARS = 2


var _GameInputHandler = load("res://game_objects/game_input_handler.gd")
var _game_input_handler: GameInputHandler
var _ball_instance: Ball
var _lives = 3
var _score = 0
var _grids_cleared = 0
var _ball_speed_level = 0
var _ball_speeds = [150, 175, 205, 240, 280]
var _brick_hits = 0
var _game_over = false
var _ball_size_halved = false


onready var _paddle: Paddle = $"%Paddle" 
onready var _ball_spawner: BallSpawner = $"%BallSpawner"
onready var _brick_map_grid: BrickMapGrid = $"%BrickMapGrid"
onready var _score_value_lbl: Label = $"%ScoreValLbl"
onready var _lives_value_lbl: Label = $"%LivesValLbl"
onready var _game_over_prompt: GameOverPrompt = $"%GameOverPrompt"
onready var _camera: ShakeableCamera = $"%ShakeableCamera"


# Virtual functions
func _ready() -> void:
	_game_input_handler = _GameInputHandler.new()
	_game_input_handler.set_paddle(_paddle)
	_game_input_handler.set_ball_spawner(_ball_spawner)
	_lives_value_lbl.set_text(str(_lives))
	var _paddle_signal_connection_error = _paddle.connect("ball_collision_detected", _camera, "shake", [3, 0.12])


func _physics_process(delta) -> void:
	_game_input_handler._physics_process(delta)


func _input(event) -> void:
	_game_input_handler._input(event)


# Getters and Setters
func get_ball_spawner() -> BallSpawner:
	return _ball_spawner


func get_lives() -> int:
	return _lives


func get_ball_instance() -> Ball:
	return _ball_instance


func is_game_over() -> bool:
	return _game_over


func get_lives_value_lbl_text() -> String:
	return _lives_value_lbl.get_text()


func get_game_over_prompt() -> GameOverPrompt:
	return _game_over_prompt


func get_brick_map_grid() -> BrickMapGrid:
	return _brick_map_grid


func get_score() -> int:
	return _score


func get_score_value_lbl_text() -> String:
	return _score_value_lbl.get_text()


func get_ball_speed_level() -> int:
	return _ball_speed_level


func get_ball_speeds():
	return _ball_speeds


func get_grids_cleared() -> int:
	return _grids_cleared


func get_brick_hits() -> int:
	return _brick_hits


func get_paddle() -> Paddle:
	return _paddle


func is_ball_size_halved() -> bool:
	return _ball_size_halved


# private functions
func _on_DeadZone_ball_is_dead() -> void:
	_destroy_ball()
	_lives -= 1
	_lives_value_lbl.set_text(str(_lives))
	if _lives > 0:
		_ball_spawner.show()
	else:
		_game_over = true
		_show_game_over_prompt()


func _destroy_ball() -> void:
	_ball_instance.queue_free()


func _show_game_over_prompt() -> void:
	_game_over_prompt.set_final_score(_score)
	_game_over_prompt.show()


func _on_BallSpawner_ball_spawned(ball) -> void:
	_ball_instance = ball
	_ball_instance.set_speed(_ball_speeds[_ball_speed_level])
	if is_ball_size_halved():
		_ball_instance.halve_size_of_ball()
	add_child(_ball_instance)
	var _ball_signal_connection_error = _ball_instance.connect("ball_collides_with_paddle", _paddle, "respond_to_collision_with_ball")
	_ball_spawner.hide()


func _on_BrickMapGrid_player_scored(score) -> void:
	_score += score
	_update_score_value_lbl_text()
	_brick_hits += 1
	_update_ball_data()


func _update_score_value_lbl_text() -> void:
	var prefix: String 
	if _score < 10:
		prefix = "00"
	elif _score < 100:
		prefix = "0"
	else: 
		prefix = ""
	_score_value_lbl.set_text(prefix + str(_score))


func _update_ball_data() -> void:
	var _original_speed_level = _ball_speed_level
	if _brick_hits == 4:
		_ball_speed_level += 1
	elif _brick_hits == 12:
		_ball_speed_level += 1
		
	if _ball_speed_level != _original_speed_level:
		_ball_instance.set_speed(_ball_speeds[_ball_speed_level])


func _on_BrickMapGrid_all_bricks_cleared() -> void:
	_grids_cleared += 1
	_destroy_ball()
	if _grids_cleared < MAX_GRID_CLEARS: 
		_ball_speed_level = 0
		_brick_map_grid.reset_bricks_grid()
	else:
		_game_over = true
		_show_game_over_prompt()


func _on_BrickMapGrid_all_bricks_reset() -> void:
	_brick_hits = 0 
	_ball_spawner.show()


func _on_BrickMapGrid_first_orange_brick_hit() -> void:
	_ball_speed_level += 1


func _on_BrickMapGrid_first_red_brick_hit() -> void:
	_ball_speed_level += 1
	_ball_size_halved = true
	_ball_instance.halve_size_of_ball()


func _on_GameOverPrompt_play_again_clicked() -> void:
	# TODO replace this with a reset instead
	var _error = get_tree().reload_current_scene()


func _on_BrickMapGrid_brick_hit() -> void:
	_camera.shake(5, 0.15)
