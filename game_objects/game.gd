extends Node2D

var _GameInputHandler = load("res://game_objects/game_input_handler.gd")
var _game_input_handler: GameInputHandler
var _ball_instance: Ball
var _lives = 3
var _score = 0
var _cleared_grids = 0
var _ball_speed_level = 0
var _ball_speeds = [0, 150, 225, 275, 310, 350]
var _brick_hits = 0


onready var _paddle: Paddle = $"%Paddle"
onready var _ball_spawner: BallSpawner = $"%BallSpawner"
onready var _brick_map_grid: BrickMapGrid = $"%BrickMapGrid"
onready var _score_value_lbl: Label = $"%ScoreValLbl"
onready var _lives_value_lbl: Label = $"%LivesValLbl"
onready var _game_over_prompt: GameOverPrompt = $"%GameOverPrompt"


func _ready() -> void:
	_game_input_handler = _GameInputHandler.new()
	_game_input_handler.set_paddle(_paddle)
	_game_input_handler.set_ball_spawner(_ball_spawner)
	_lives_value_lbl.set_text(str(_lives))
	_ball_speed_level = 1


func _physics_process(delta) -> void:
	_game_input_handler._physics_process(delta)


func _input(event) -> void:
	_game_input_handler._input(event)


func _on_DeadZone_ball_is_dead() -> void:
	_destroy_ball()
	_lives -= 1
	_lives_value_lbl.set_text(str(_lives))
	if _lives > 0:
		_ball_spawner.show()
	else:
		_game_over()


func _destroy_ball() -> void:
	_ball_instance.queue_free()


func _game_over() -> void:
	_game_over_prompt.set_final_score(_score)
	_game_over_prompt.show()
	pass


func _on_BallSpawner_ball_spawned(ball) -> void:
	_ball_instance = ball
	_ball_instance.set_speed(_ball_speeds[_ball_speed_level])
	add_child(_ball_instance)
	_ball_spawner.hide()


func _on_BrickMapGrid_player_scored(score) -> void:
	_score += score
	var prefix: String 
	if _score < 10:
		prefix = "00"
	elif _score < 100:
		prefix = "0"
	else: 
		prefix = ""
	_score_value_lbl.set_text(prefix + str(_score))
	_brick_hits += 1
	if _brick_hits == 4:
		_ball_speed_level += 1
	elif _brick_hits == 12:
		_ball_speed_level += 1
	_ball_instance.set_speed(_ball_speeds[_ball_speed_level])


func _on_BrickMapGrid_all_bricks_cleared() -> void:
	_cleared_grids += 1
	_destroy_ball()
	if _cleared_grids < 2: 
		_brick_map_grid.reset_bricks_grid()
	else:
		_game_over()


func _on_BrickMapGrid_all_bricks_reset() -> void:
	_brick_hits = 0 
	_ball_spawner.show()


func _on_BrickMapGrid_first_orange_brick_hit() -> void:
	_ball_speed_level += 1


func _on_BrickMapGrid_first_red_brick_hit() -> void:
	_ball_speed_level += 1


func _on_GameOverPrompt_play_again_clicked() -> void:
	get_tree().reload_current_scene()
