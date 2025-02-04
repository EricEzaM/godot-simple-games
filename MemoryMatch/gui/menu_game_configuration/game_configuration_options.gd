extends CanvasLayer

onready var number_of_cards_spinbox: SpinBox = $MarginContainer/ScrollContainer/VBoxContainer/NumberOfCardsContainer/SpinBox
onready var card_face_selection = $MarginContainer/ScrollContainer/VBoxContainer/CardFaceSelection
onready var card_back_selection = $MarginContainer/ScrollContainer/VBoxContainer/CardBackSelection
onready var error_msg_label: Label = $MarginContainer/ScrollContainer/VBoxContainer/ErrorMessageLabel
onready var start_button: Button = $MarginContainer/ScrollContainer/VBoxContainer/ButtonsContainer/StartButton
onready var back_button: Button = $MarginContainer/ScrollContainer/VBoxContainer/ButtonsContainer/BackButton

func _ready():
	number_of_cards_spinbox.connect("value_changed", self, "_update_number_of_cards")
	number_of_cards_spinbox.value = 16
	
	card_face_selection.connect("selection_updated", self, "_update_face_texture_set")
	card_face_selection.texture_sets = GameConfiguration.available_card_face_texture_sets
	card_face_selection.set_up_buttons()
	
	card_back_selection.connect("selection_updated", self, "_update_back_texture")
	card_back_selection.textures = GameConfiguration.available_card_back_textures
	card_back_selection.set_up_buttons()
	
	start_button.connect("pressed", self, "_on_start_pressed")
	back_button.connect("pressed", self, "_on_back_pressed")


func _update_number_of_cards(n):
	GameConfiguration.number_of_cards = n
	validate_config()


func _on_start_pressed():
	if GameConfiguration.is_valid():
		Events.emit_signal("scene_change_request", Scenes.game)
	else:
		validate_config()


func _on_back_pressed():
	Events.emit_signal("scene_change_request", Scenes.main_menu)


func _update_face_texture_set(ts: TextureSet):
	GameConfiguration.card_face_texture_set = ts


func _update_back_texture(tx: Texture):
	GameConfiguration.card_back_texture = tx


func validate_config():
	if GameConfiguration.is_valid():
		start_button.disabled = false
		error_msg_label.visible = false
	else:
		start_button.disabled = true
		error_msg_label.visible = true
		error_msg_label.text = GameConfiguration.error_msg
