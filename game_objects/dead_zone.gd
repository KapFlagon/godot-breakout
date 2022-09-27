extends Area2D

class_name DeadZone


signal ball_is_dead

var _base_colour: Color = Color(1,1,1) setget set_base_colour, get_base_colour
var _rectangle: Rect2
onready var _collision_shape_extents = $"%CollisionShape2D".shape.extents


func _ready() -> void:
	_rectangle = Rect2(_collision_shape_extents.x *-1, _collision_shape_extents.y * -1, 
			_collision_shape_extents.x * 2, _collision_shape_extents.y * 2)


func _draw() -> void:
	draw_rect(_rectangle, _base_colour)


# Getters and Setters
func get_base_colour() -> Color:
	return _base_colour

func set_base_colour(new_base_colour: Color) -> void:
	_base_colour = new_base_colour


# Public functions
func _on_DeadZone_body_entered(_body) -> void:
	emit_signal("ball_is_dead")
