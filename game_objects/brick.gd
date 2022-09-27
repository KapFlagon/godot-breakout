extends Node2D

class_name Brick

signal brick_was_hit(_score_value)

var _starting_position: Vector2 = Vector2(0.0, 0.0) setget set_starting_position, get_starting_position
var _base_colour: Color = Color(1, 1, 1) setget set_base_colour, get_base_colour
var _brick_hit: bool = false setget set_brick_hit, is_brick_hit
var _score_value: int = 1 setget set_score_value, get_score_value
var _rectangle: Rect2

onready var _detector_shape_extents = $"%DetectorShape".shape.extents



# Virtual functions
func _ready():
	_rectangle = Rect2(_detector_shape_extents.x *-1, _detector_shape_extents.y * -1, 
			_detector_shape_extents.x * 2, _detector_shape_extents.y * 2)


func _draw():
	draw_rect(_rectangle, _base_colour)


# Getters and Setters
func get_starting_position() -> Vector2:
	return _starting_position

func set_starting_position(new_starting_position: Vector2) -> void:
	_starting_position = new_starting_position
	position = _starting_position


func get_base_colour() -> Color:
	return _base_colour

func set_base_colour(new_base_colour: Color) -> void:
	_base_colour = new_base_colour


func is_brick_hit() -> bool:
	return _brick_hit

func set_brick_hit(brick_has_been_hit: bool) -> void:
	_brick_hit = brick_has_been_hit


func is_collision_disabled() -> bool:
	return $"%StaticBodyCollisionShape".is_disabled()


func get_score_value() -> int:
	return _score_value

func set_score_value(new_score_value: int) -> void:
	_score_value = new_score_value


# Private functions
func _disable_brick_after_hit() -> void:
	self.set_brick_hit(true)
	$"%StaticBodyCollisionShape".set_deferred("disabled", true)
	self.hide()
	emit_signal("brick_was_hit", _score_value)


# Public functions
func reset_brick() -> void:
	self.set_position(_starting_position)
	self.set_brick_hit(false)
	$"%StaticBodyCollisionShape".set_deferred("disabled", false)
	self.show()


# Connected signals
func _on_Area2D_body_exited(body):
	if body is Ball and !_brick_hit :
		_disable_brick_after_hit()
