extends Node

class_name HighScoreList


signal new_high_score(position_in_high_scores_dictionary)


var _high_score_dictionary = {} setget set_high_score_dictionary, get_high_score_dictionary


# Virtual functions (e.g. _ready())
func _init() -> void:
	for i in range(1, 6):
		_high_score_dictionary[i] = {
			"score": 0,
			"datetime": null
		}


# Getters and Setters
func get_high_score_dictionary():
	return _high_score_dictionary

func set_high_score_dictionary(new_high_score_dictionary) -> void:
	_high_score_dictionary = new_high_score_dictionary


# Public functions 
func add_new_score(new_high_score: int) -> void:
	for entry_position in _high_score_dictionary:
		if _high_score_dictionary[entry_position].get("score") < new_high_score:
			emit_signal("new_high_score", entry_position)
			var score_to_shuffle = _high_score_dictionary[entry_position]
			_high_score_dictionary[entry_position] = _build_score_entry_dictionary(new_high_score)
			_shift_score_after_new_score_inserted(score_to_shuffle)
			break


func _shift_score_after_new_score_inserted(score_to_shift_dictionary) -> void:
	for entry_position in _high_score_dictionary:
		if _high_score_dictionary[entry_position].get("score") < score_to_shift_dictionary.get("score"):
			var score_to_shuffle = _high_score_dictionary[entry_position]
			_high_score_dictionary[entry_position] = score_to_shift_dictionary
			_shift_score_after_new_score_inserted(score_to_shuffle)
			break


func _build_score_entry_dictionary(score_value: int):
	var score_entry_dictionary = {
		"score": score_value, 
		"datetime": Time.get_datetime_dict_from_system()
	}
	return score_entry_dictionary
