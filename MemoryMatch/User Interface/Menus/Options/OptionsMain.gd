extends PanelContainer
# Docstring

# --- Signals
# --- Enums
# --- Constants
# --- Exported Variables
# --- Public Variables
# --- Private Variables
# --- Onready Variables

func _ready():
	$MarginContainer/VBoxContainer/ButtonContainer/Cancel.connect("pressed", Events, "emit_signal", ["toggle_options", false])
	pass

# --- Virtual Override methods
# --- Public Methods
# --- Private Methods
