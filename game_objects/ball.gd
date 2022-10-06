extends KinematicBody2D

class_name Ball

signal ball_collides_with_paddle(collision_position)


var _speed: float = 0.0  setget set_speed, get_speed
var _direction = Vector2(0.0, 0.0) setget set_direction, get_direction
var _base_colour = Color(1, 1, 1) setget set_base_colour, get_base_colour

onready var _collision_shape:CircleShape2D = $"%CollisionShape2D".shape



# Virtual functions
func _draw() -> void:
	draw_circle(Vector2(0, 0), _collision_shape.radius, _base_colour)


func _physics_process(delta) -> void:
	var velocity = _speed * _direction * delta
	var collision: KinematicCollision2D = move_and_collide(velocity)
	if collision:
		if collision.get_collider().is_in_group("g_paddle"):
			emit_signal("ball_collides_with_paddle", collision.get_position())
		_bounce_off_surface(collision)


# Getters and Setters
func get_speed() -> float:
	return _speed

func set_speed(new_speed: float) -> void:
	_speed = new_speed


func get_direction() -> Vector2:
	return _direction

func set_direction(new_direction: Vector2) -> void:
	if(!new_direction.is_normalized()):
		new_direction = new_direction.normalized()
	_direction = new_direction


func get_base_colour() -> Color:
	return _base_colour

func set_base_colour(new_base_colour: Color) -> void:
	_base_colour = new_base_colour


func get_collision_shape_radius() -> float:
	return _collision_shape.get_radius()

# Private functions
func _bounce_off_surface(collision: KinematicCollision2D) -> void:
	if collision.get_collider_velocity() != Vector2.ZERO:
		_direction.x = _calculate_influenced_x_value(collision.get_collider_velocity())
	_direction = _direction.bounce(collision.normal)


func _calculate_influenced_x_value(collider_velocity: Vector2) -> float:
	var temp_direction = _direction + collider_velocity
	return temp_direction.normalized().x


func halve_size_of_ball() -> void:
	_collision_shape.set_radius(5)
	update()
