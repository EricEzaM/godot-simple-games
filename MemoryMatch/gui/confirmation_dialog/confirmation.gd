extends CanvasLayer
# Docstring

# --- Signals
# --- Enums
# --- Constants
# --- Exported Variables
# --- Public Variables
# --- Private Variables
# --- Onready Variables

onready var confirm_dialog: ConfirmationDialog = $ConfirmationDialog

func _ready():
	Events.connect("show_confirm_dialog", self, "_show")
	pass

# --- Virtual Override methods
# --- Public Methods
# --- Private Methods

func _show(title, text, callback, callback_params):
	confirm_dialog.window_title = title
	confirm_dialog.dialog_text = text
	confirm_dialog.popup_centered()
	confirm_dialog.get_ok().connect("pressed", self, "_ok_pressed", 
			[callback, callback_params], CONNECT_ONESHOT)
	

func _ok_pressed(callback: FuncRef, callback_params: Array):
	callback.call_funcv(callback_params)
	
