extends CenterContainer
# Docstring

# --- Signals
# --- Enums
# --- Constants
# --- Exported Variables
export (String) var time_label_template = "You completed the level in %s minutes and %s seconds!"
# --- Public Variables
# --- Private Variables
# --- Onready Variables

onready var time_label = $AcceptDialog/MarginContainer/VBoxContainer/TimeLabel
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


func _on_game_complete(tries_count: int, match_count: int):
	visible = true
	accept_dialog.popup_centered()
	$AcceptDialog/MarginContainer/VBoxContainer/GridContainer/AttemptsVal.text = str(tries_count)
	$AcceptDialog/MarginContainer/VBoxContainer/GridContainer/MatchesVal.text = str(match_count)
	$AcceptDialog/MarginContainer/VBoxContainer/GridContainer/APMVal.text = "%0.2f" % (float(tries_count)/float(match_count))
	
