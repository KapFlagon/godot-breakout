extends Node2D


class_name BrickGenerator


var _Brick = preload("res://game_objects/Brick.tscn")


# Public functions 
func generate_yellow_brick() -> Brick:
	return _generate_brick(Color.yellow, 1)


func generate_green_brick() -> Brick:
	return _generate_brick(Color.green, 3)


func generate_orange_brick() -> Brick:
	return _generate_brick(Color.orange, 5)


func generate_red_brick() -> Brick:
	return _generate_brick(Color.red, 7)


# Private functions
func _generate_brick(colour: Color, score: int) -> Brick:
	var _brick_instance: Brick = _Brick.instance()
	_brick_instance.set_base_colour(colour)
	_brick_instance.set_score_value(score)
	return _brick_instance
