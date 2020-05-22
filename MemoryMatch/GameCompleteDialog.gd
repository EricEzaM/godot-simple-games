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

onready var accept_dialog = $AcceptDialog
onready var time_label = $AcceptDialog/MarginContainer/VBoxContainer/TimeLabel


func _ready():
	accept_dialog.add_button("Play Again", true, "play_again")
	accept_dialog.connect("custom_action", self, "_on_custom_action")
	accept_dialog.connect("confirmed", self, "_on_ok")
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
