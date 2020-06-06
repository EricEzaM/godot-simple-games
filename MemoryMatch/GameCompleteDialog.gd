extends CenterContainer
# Docstring

# --- Signals
# --- Enums
# --- Constants
# --- Exported Variables
# --- Public Variables
# --- Private Variables
# --- Onready Variables

onready var accept_dialog = $AcceptDialog

func _ready():
	visible = false
	accept_dialog.add_button("Play Again", true, "play_again")
	accept_dialog.connect("custom_action", self, "_on_custom_action")
	accept_dialog.connect("confirmed", self, "_on_ok")
	Events.connect("game_complete", self, "_on_game_complete")
	pass

# --- Virtual Override methods
# --- Public Methods
# --- Private Methods

func _on_ok():
#	Return to main menu
	Events.emit_signal("scene_change_request", Scenes.main_menu)
	pass


func _on_custom_action(action: String):
	if action == "play_again":
#		Play again with same settings
		Events.emit_signal("scene_change_request", Scenes.game)


func _on_game_complete(tries_count: int, match_count: int, seconds_taken: int):
	visible = true
	
#	Give a little bit of delay - allows the flip anim to complete
#	and just generally feels better than instant popup
	yield(get_tree().create_timer(1), "timeout")
	
	accept_dialog.popup_centered()
	
	var minutes = seconds_taken / 60
	var seconds = seconds_taken % 60
	
	var main_text = "Congratulations! You matched all cards in "
	
	if minutes > 0:
		main_text += "%0.0d minutes and %0.0d seconds" % [minutes, seconds]
	else:
		main_text += "%0.0d seconds" % seconds
	
	$AcceptDialog/MarginContainer/VBoxContainer/MainLabel.text = main_text
	
	$AcceptDialog/MarginContainer/VBoxContainer/GridContainer/AttemptsVal.text = str(tries_count)
	$AcceptDialog/MarginContainer/VBoxContainer/GridContainer/MatchesVal.text = str(match_count)
	$AcceptDialog/MarginContainer/VBoxContainer/GridContainer/APMVal.text = "%0.2f" % (float(tries_count)/float(match_count))
	$AcceptDialog/MarginContainer/VBoxContainer/GridContainer/TimeTakenVal.text = "%0.0d mins : %0.0d secs" % [minutes, seconds]
