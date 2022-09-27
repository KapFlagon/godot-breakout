extends Area2D

class_name BallSpawner


signal ball_spawned(ball)

export var _ball_speed: float = 150.0 setget set_ball_speed, get_ball_speed

var _Ball = preload("res://game_objects/Ball.tscn")

onready var _ball_spawner_collision_shape: CollisionShape2D = $"%BallSpawnerCollisionShape"


# Virtual functions 
func _draw() -> void:
	var colour := Color.azure
	colour.a = 0.5
	draw_circle(Vector2(0, 0), _ball_spawner_collision_shape.shape.radius, colour)



# Getters and Setters
func is_ball_spawner_collision_shape_disabled() -> bool:
	return _ball_spawner_collision_shape.is_disabled()


func get_ball_speed() -> float:
	return _ball_speed

func set_ball_speed(new_ball_speed: float) -> void:
	_ball_speed = new_ball_speed


# Static functions




# Public functions 
func spawn_ball() -> Ball:
	if !is_ball_spawner_collision_shape_disabled():
		var ball_instance: Ball = _Ball.instance()
		ball_instance.set_position(position)
		ball_instance.set_direction(Vector2(0, 1))
		ball_instance.set_speed(_ball_speed)
		emit_signal("ball_spawned", ball_instance)
		return ball_instance
	return null
	

# Overriding functions
func hide() -> void:
	.hide()
#	_ball_spawner_collision_shape.set_disabled(true)
	_ball_spawner_collision_shape.set_deferred("disabled", true)


func show() -> void:
	.show()
#	_ball_spawner_collision_shape.set_disabled(false)
	_ball_spawner_collision_shape.set_deferred("disabled", false)


# Private functions

