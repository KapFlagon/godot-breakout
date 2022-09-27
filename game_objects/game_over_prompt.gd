extends CenterContainer

class_name GameOverPrompt

signal play_again_clicked


var _final_score: int = 0 setget set_final_score, get_final_score

onready var _final_score_lbl = $"%FinalScoreValLbl"



# Getters and Setters
func get_final_score() -> int:
	return _final_score


func set_final_score(new_final_score: int) -> void:
	_final_score = new_final_score
	var prefix: String 
	if _final_score < 10:
		prefix = "00"
	elif _final_score < 100:
		prefix = "0"
	else: 
		prefix = ""
	_final_score_lbl.set_text(prefix + str(_final_score))


func _on_PlayAgainButton_button_up() -> void:
	emit_signal("play_again_clicked")
