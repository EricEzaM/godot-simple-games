extends CanvasLayer

func _ready():
	$CenterContainer/VBoxContainer/PlayButton.connect("pressed", self, "_play")
	$CenterContainer/VBoxContainer/SettingsButton.connect("pressed", self, "_options")
	$CenterContainer/VBoxContainer/QuitButton.connect("pressed", self, "_quit")
	pass

func _play():
	Events.emit_signal("scene_change_request", Scenes.configuration)
	

func _options():
	Events.emit_signal("toggle_options", true)


func _quit(confirmed = false):
	if !confirmed:
		Events.emit_signal(
			"show_confirm_dialog", 
			"Quit?", 
			"Are you sure you want to quit?",
			funcref(self, "_quit"),
			[true])
	else:
		get_tree().quit()
