extends GutTest

var _HighScoreList = load("res://game_objects/high_score_list.gd")
var _high_score_list_instance: HighScoreList
var _dummy_datetime = {}
var _dummy_high_scores_dictionary = {}



# Test setup functions 
func before_all() -> void:
	_dummy_datetime = {
		"year": 2022,
		"month": 10,
		"day": 11,
		"weekday": 2,
		"dst": false,
		"hour": 20,
		"minute": 38,
		"second": 15,
	}
	gut.p("ran run setup", 2)


func before_each() -> void:
	_high_score_list_instance = _HighScoreList.new()
	for i in range(1, 6):
		_dummy_high_scores_dictionary[i] = {
			"score": (1000 / i),
			"datetime": {
				"year": 2022,
				"month": i,
				"day": i,
				"weekday": i,
				"dst": false,
				"hour": 10,
				"minute": 30,
				"second": i,
			}
		}
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_high_score_list_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_can_be_generated() -> void:
	assert_not_null(_high_score_list_instance)


func test_get_set_high_score_dictionary() -> void:
	var test_empty_dictionary = {}
	for i in range(1, 6):
		test_empty_dictionary[i] = {
			"score": 0,
			"datetime": null
		}
	assert_has_method(_high_score_list_instance, "get_high_score_dictionary")
	assert_has_method(_high_score_list_instance, "set_high_score_dictionary")
	assert_eq_deep(_high_score_list_instance.get_high_score_dictionary(), test_empty_dictionary)
	_high_score_list_instance.set_high_score_dictionary(_dummy_high_scores_dictionary.duplicate(true))
	assert_eq_deep(_high_score_list_instance.get_high_score_dictionary(), _dummy_high_scores_dictionary)


func test_adding_new_score_to_blank_list_is_placed_at_position_1() -> void: 
	var new_top_score_dictionary = {
		"score": 1100,
		"datetime": _dummy_datetime
	}
	_high_score_list_instance.add_new_score(new_top_score_dictionary)
	assert_eq_deep(_high_score_list_instance.get_high_score_dictionary().get(1), new_top_score_dictionary)


func test_adding_new_score_with_middle_value_to_populated_list_is_placed_at_position_3() -> void:
	var new_score_dictionary = {
		"score": 350,
		"datetime": _dummy_datetime
	}
	_high_score_list_instance.set_high_score_dictionary(_dummy_high_scores_dictionary)
	_high_score_list_instance.add_new_score(new_score_dictionary)
	assert_eq_deep(_high_score_list_instance.get_high_score_dictionary().get(3), new_score_dictionary)


func test_adding_new_high_score_emits_signal_with_position_in_high_scores() -> void:
	var new_score_dictionary = {
		"score": 350,
		"datetime": _dummy_datetime
	}
	watch_signals(_high_score_list_instance)
	_high_score_list_instance.set_high_score_dictionary(_dummy_high_scores_dictionary)
	_high_score_list_instance.add_new_score(new_score_dictionary)
	assert_signal_emitted_with_parameters(_high_score_list_instance, "new_high_score", [3])


func test_adding_new_score_highest_score_displaces_all_scores_by_one_position() -> void:
	var new_top_score_dictionary = {
		"score": 1100,
		"datetime": _dummy_datetime
	}
	_high_score_list_instance.set_high_score_dictionary(_dummy_high_scores_dictionary.duplicate(true))
	
	_dummy_high_scores_dictionary[5] = _dummy_high_scores_dictionary[4]
	_dummy_high_scores_dictionary[4] = _dummy_high_scores_dictionary[3]
	_dummy_high_scores_dictionary[3] = _dummy_high_scores_dictionary[2]
	_dummy_high_scores_dictionary[2] = _dummy_high_scores_dictionary[1]
	_dummy_high_scores_dictionary[1] = new_top_score_dictionary
	
	_high_score_list_instance.add_new_score(new_top_score_dictionary)
	
	assert_eq_deep(_high_score_list_instance.get_high_score_dictionary(), _dummy_high_scores_dictionary)


func test_adding_new_mid_score_displaces_only_bottom_two_scores_by_one_position() -> void:
	var new_top_score_dictionary = {
		"score": 350,
		"datetime": _dummy_datetime
	}
	_high_score_list_instance.set_high_score_dictionary(_dummy_high_scores_dictionary.duplicate(true))
	
	_dummy_high_scores_dictionary[5] = _dummy_high_scores_dictionary[4]
	_dummy_high_scores_dictionary[4] = _dummy_high_scores_dictionary[3]
	_dummy_high_scores_dictionary[3] = new_top_score_dictionary
	
	_high_score_list_instance.add_new_score(new_top_score_dictionary)
	
	assert_eq_deep(_high_score_list_instance.get_high_score_dictionary(), _dummy_high_scores_dictionary)


func test_adding_new_score_lower_than_lowest_high_score_does_nothing() -> void:
	var new_score_dictionary = {
		"score": 10,
		"datetime": _dummy_datetime
	}
	_high_score_list_instance.set_high_score_dictionary(_dummy_high_scores_dictionary.duplicate(true))
	_high_score_list_instance.add_new_score(new_score_dictionary)
	assert_eq_deep(_high_score_list_instance.get_high_score_dictionary(), _dummy_high_scores_dictionary)
