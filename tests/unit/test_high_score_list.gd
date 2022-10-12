extends GutTest

var _HighScoreList = load("res://game_objects/high_score_list.gd")
var _high_score_list_instance: HighScoreList
var _partial_double_high_score_instance
var _dummy_high_scores_dictionary = {}



# Test setup functions 
func before_all() -> void:
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
	var score_value: int = 1100

	_high_score_list_instance.add_new_score(score_value)
	assert_eq_deep(_high_score_list_instance.get_high_score_dictionary().get(1).get("score"), score_value)


func test_adding_new_score_with_middle_value_to_populated_list_is_placed_at_position_3() -> void:
	var score_value: int = 350
	
	_high_score_list_instance.set_high_score_dictionary(_dummy_high_scores_dictionary)
	_high_score_list_instance.add_new_score(score_value)
	assert_eq_deep(_high_score_list_instance.get_high_score_dictionary().get(3).get("score"), score_value)


func test_adding_new_high_score_emits_signal_with_position_in_high_scores() -> void:
	var score_value: int = 350
	watch_signals(_high_score_list_instance)
	_high_score_list_instance.set_high_score_dictionary(_dummy_high_scores_dictionary)
	_high_score_list_instance.add_new_score(score_value)
	assert_signal_emitted_with_parameters(_high_score_list_instance, "new_high_score", [3])


func test_can_build_score_entry_with_date_dictionary_data() -> void:
	var score:int = 50
	var now_datetime = Time.get_datetime_dict_from_system()
	var output_score_entry_dictionary = _high_score_list_instance._build_score_entry_dictionary(score)
	assert_eq(output_score_entry_dictionary.get("score"), score)
	assert_eq(output_score_entry_dictionary.get("datetime").get("year"), now_datetime.get("year"))
	assert_eq(output_score_entry_dictionary.get("datetime").get("month"), now_datetime.get("month"))
	assert_eq(output_score_entry_dictionary.get("datetime").get("day"), now_datetime.get("day"))
	assert_eq(output_score_entry_dictionary.get("datetime").get("hour"), now_datetime.get("hour"))
	assert_eq(output_score_entry_dictionary.get("datetime").get("minute"), now_datetime.get("minute"))


func test_adding_new_score_highest_score_displaces_all_scores_by_one_position() -> void:
	var score_value: int = 1100
	var _dummy_datetime = {
		"year": 2022,
		"month": 10,
		"day": 11,
		"weekday": 2,
		"dst": false,
		"hour": 20,
		"minute": 38,
		"second": 15,
	}
	var new_top_score_dictionary = {
		"score": score_value,
		"datetime": _dummy_datetime
	}
	
	_partial_double_high_score_instance = partial_double("res://game_objects/high_score_list.gd").new()
	stub(_partial_double_high_score_instance, "_build_score_entry_dictionary").to_return(new_top_score_dictionary).when_passed(score_value)
	
	_partial_double_high_score_instance.set_high_score_dictionary(_dummy_high_scores_dictionary.duplicate(true))
	
	_dummy_high_scores_dictionary[5] = _dummy_high_scores_dictionary[4]
	_dummy_high_scores_dictionary[4] = _dummy_high_scores_dictionary[3]
	_dummy_high_scores_dictionary[3] = _dummy_high_scores_dictionary[2]
	_dummy_high_scores_dictionary[2] = _dummy_high_scores_dictionary[1]
	_dummy_high_scores_dictionary[1] = new_top_score_dictionary
	
	_partial_double_high_score_instance.add_new_score(score_value)
	
	assert_eq_deep(_partial_double_high_score_instance.get_high_score_dictionary(), _dummy_high_scores_dictionary)


func test_adding_new_mid_score_displaces_only_bottom_two_scores_by_one_position() -> void:
	var score_value: int = 350
	var _dummy_datetime = {
		"year": 2022,
		"month": 10,
		"day": 11,
		"weekday": 2,
		"dst": false,
		"hour": 20,
		"minute": 38,
		"second": 15,
	}
	var new_top_score_dictionary = {
		"score": score_value,
		"datetime": _dummy_datetime
	}
	
	_partial_double_high_score_instance = partial_double("res://game_objects/high_score_list.gd").new()
	stub(_partial_double_high_score_instance, "_build_score_entry_dictionary").to_return(new_top_score_dictionary).when_passed(score_value)
	
	_partial_double_high_score_instance.set_high_score_dictionary(_dummy_high_scores_dictionary.duplicate(true))
	
	_dummy_high_scores_dictionary[5] = _dummy_high_scores_dictionary[4]
	_dummy_high_scores_dictionary[4] = _dummy_high_scores_dictionary[3]
	_dummy_high_scores_dictionary[3] = new_top_score_dictionary
	
	_partial_double_high_score_instance.add_new_score(score_value)
	
	assert_eq_deep(_partial_double_high_score_instance.get_high_score_dictionary(), _dummy_high_scores_dictionary)


func test_adding_new_score_lower_than_lowest_high_score_does_nothing() -> void:
	var score_value: int = 10
	var _dummy_datetime = {
		"year": 2022,
		"month": 10,
		"day": 11,
		"weekday": 2,
		"dst": false,
		"hour": 20,
		"minute": 38,
		"second": 15,
	}
	var new_score_dictionary = {
		"score": score_value,
		"datetime": _dummy_datetime
	}
	
	_partial_double_high_score_instance = partial_double("res://game_objects/high_score_list.gd").new()
	stub(_partial_double_high_score_instance, "_build_score_entry_dictionary").to_return(new_score_dictionary).when_passed(score_value)
	
	_partial_double_high_score_instance.set_high_score_dictionary(_dummy_high_scores_dictionary.duplicate(true))
	_partial_double_high_score_instance.add_new_score(score_value)
	assert_eq_deep(_partial_double_high_score_instance.get_high_score_dictionary(), _dummy_high_scores_dictionary)
