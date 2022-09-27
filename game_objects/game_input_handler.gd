extends Node2D

class_name GameInputHandler

var _paddle: Paddle setget set_paddle, get_paddle
var _ball_spawner: BallSpawner setget set_ball_spawner, get_ball_spawner


# Getters and Setters
func get_paddle() -> Paddle:
	return _paddle

func set_paddle(new_paddle: Paddle) -> void:
	_paddle = new_paddle


func get_ball_spawner() -> BallSpawner:
	return _ball_spawner

func set_ball_spawner(new_ball_spawner: BallSpawner) -> void:
	_ball_spawner = new_ball_spawner


# Virtual Functions
func _physics_process(_delta) -> void:
	if Input.is_action_pressed("move_paddle_left"):
		_paddle.move_left()
	elif Input.is_action_pressed("move_paddle_right"):
		_paddle.move_right()


func _input(event) -> void:
	if event is InputEventMouseMotion:
		_paddle.set_target_x_position(event.position.x)
	elif event is InputEventScreenTouch or event is InputEventScreenDrag:
		_paddle.set_target_x_position(event.position.x)
	elif event.is_action("launch_ball") and event.is_pressed():
		_ball_spawner.spawn_ball()
