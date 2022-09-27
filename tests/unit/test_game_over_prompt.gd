extends GutTest

var _GameOverPrompt = load("res://game_objects/GameOverPrompt.tscn")
var _game_over_prompt_instance: GameOverPrompt



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_game_over_prompt_instance = _GameOverPrompt.instance()
	add_child(_game_over_prompt_instance)
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_game_over_prompt_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_generated_and_not_null() -> void:
	assert_not_null(_game_over_prompt_instance, "instance not null")


func test_set_get_final_score() -> void:
	assert_accessors(_game_over_prompt_instance, "final_score", 0, 20)


func test_setting_final_score_updates_label() -> void:
	var expected_final_score:int = 25
	_game_over_prompt_instance.set_final_score(expected_final_score)
	var label_int_text = _game_over_prompt_instance.get_node("PanelContainer/VBoxContainer/HBoxContainer/FinalScoreValLbl").get_text()
	assert_eq(int(label_int_text), expected_final_score)


func test_emits_reset_signal_on_play_again_button_press() -> void:
	watch_signals(_game_over_prompt_instance)
	_game_over_prompt_instance.emit_signal("play_again_clicked")
	assert_signal_emitted(_game_over_prompt_instance, "play_again_clicked")
