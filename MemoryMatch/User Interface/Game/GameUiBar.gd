extends HBoxContainer
# Docstring

# --- Signals
# --- Enums
# --- Constants
# --- Exported Variables
# --- Public Variables
# --- Private Variables
# --- Onready Variables

func _ready():
	$BackButton.connect("pressed", self, "_go_back")
	$SettingsButton.connect("pressed", Events, "emit_signal", ["toggle_options", true])
	pass

# --- Virtual Override methods
# --- Public Methods
# --- Private Methods

func _go_back(confirmed = false):
	if !confirmed:
		Events.emit_signal(
			"show_confirm_dialog", 
			"Back to Menu?", 
			"Are you sure you want to leave? Your progress will be lost",
			funcref(self, "_go_back"),
			[true])
	else:
		Events.emit_signal("scene_change_request", Scenes.main_menu)
