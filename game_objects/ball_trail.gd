extends Line2D

class_name BallTrail


var _trail_owner: Node2D setget set_trail_owner
var _trail_length = 50 setget set_trail_length, get_trail_length
var _point = Vector2() setget set_point, get_point


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	global_position = Vector2(0,0)
	global_rotation = 0
	add_point(_trail_owner.get_global_position())
	while get_point_count() > _trail_length:
		remove_point(0)


# Getters and Setters
func set_trail_owner(new_trail_owner: Node2D) -> void:
	_trail_owner = new_trail_owner


func get_trail_length() -> int:
	return _trail_length

func set_trail_length(new_trail_length: int) -> void:
	_trail_length = new_trail_length


func get_point() -> Vector2:
	return _point

func set_point(new_point: Vector2) -> void:
	_point = new_point
