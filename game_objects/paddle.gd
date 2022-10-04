extends KinematicBody2D

class_name Paddle


export var _base_colour: Color = Color(1, 1, 1) setget set_base_colour, get_base_colour
export var _speed: float = 10.0 setget set_speed, get_speed
export var _movement_increment: float = 2.0 setget set_movement_increment, get_movement_increment

var _target_x_position: float = 0.0 setget set_target_x_position, get_target_x_position
var _rectangle: Rect2
var _x_direction: float = 0.0

onready var _collision_shape_extents = $"%CollisionShape2D".shape.extents
onready var _particles = $"%CPUParticles2D"


# Virtual functions
func _ready() -> void:
	self.set_position(self.get_position())
	_rectangle = Rect2(_collision_shape_extents.x *-1, _collision_shape_extents.y * -1, 
			_collision_shape_extents.x * 2, _collision_shape_extents.y * 2)
	_particles.set_color(_base_colour)


func _draw() -> void:
	draw_rect(_rectangle, _base_colour)


func _physics_process(delta) -> void:
	var x_diff = _target_x_position  - position.x
	var stepified_x_diff = stepify(x_diff, 1)
	_establish_direction(stepified_x_diff)

	var velocity := Vector2.ZERO
	if _x_direction != 0:
		velocity = Vector2(stepified_x_diff, 0) * delta * _speed
	else:
		velocity = Vector2(0, 0)
	var _collision: KinematicCollision2D = move_and_collide(velocity)


# Getters and Setters
func get_base_colour() -> Color:
	return _base_colour

func set_base_colour(new_base_colour: Color) -> void:
	_base_colour = new_base_colour


func get_speed() -> float:
	return _speed

func set_speed(new_speed: float) -> void:
	_speed = new_speed


func get_target_x_position() -> float:
	return _target_x_position

func set_target_x_position(new_target_x_position: float) -> void:
	_target_x_position = new_target_x_position


func get_movement_increment() -> float:
	return _movement_increment

func set_movement_increment(new_movement_increment: float) -> void:
	_movement_increment = new_movement_increment


func set_position(new_position: Vector2) -> void:
	.set_position(new_position)
	self.set_target_x_position(new_position.x)


# Public functions
func move_left() -> void:
	if _x_direction >= 0:
		_target_x_position = position.x - _movement_increment
	else:
		_target_x_position -= _movement_increment * _speed


func move_right() -> void:
	if _x_direction <= 0:
		_target_x_position = position.x + _movement_increment
	else:
		_target_x_position += _movement_increment * _speed 


func emit_particles_at_position(position: Vector2) -> void:
	_particles.set_position(to_local(position))
	_particles.set_emitting(true)


# Private functions
func _establish_direction(stepified_x_diff: float) -> void:
	if stepified_x_diff > 0: 
		_x_direction = 1.0
	elif stepified_x_diff < 0:
		_x_direction = -1.0
	else:
		_x_direction = 0
