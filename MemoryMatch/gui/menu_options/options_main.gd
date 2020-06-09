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
	# TODO: make cancel and OK do different things
	$MarginContainer/VBoxContainer/ButtonContainer/OK.connect("pressed", Events, "emit_signal", ["toggle_options", false])
	$MarginContainer/VBoxContainer/Master/HSlider.connect("value_changed", self, "_on_master_volume_changed")
	$MarginContainer/VBoxContainer/Music/HSlider.connect("value_changed", self, "_on_music_volume_changed")
	$MarginContainer/VBoxContainer/Effects/HSlider.connect("value_changed", self, "_on_sfx_volume_changed")

# --- Virtual Override methods
# --- Public Methods
# --- Private Methods

func _on_master_volume_changed(value: float):
	AudioServer.set_bus_volume_db(0, linear2db(value/100))
	$SfxTestSound.play()


func _on_music_volume_changed(value: float):
	AudioServer.set_bus_volume_db(1, linear2db(value/100))
	$MusicTestSound.play()
	
	
func _on_sfx_volume_changed(value: float):
	AudioServer.set_bus_volume_db(2, linear2db(value/100))
	$SfxTestSound.play()
