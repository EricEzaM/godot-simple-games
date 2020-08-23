extends HBoxContainer

signal selection_updated(new_texture_set)

var texture_sets: Array

onready var texture_button = $GridContainer/TextureButton
onready var btn_container = $GridContainer
onready var texture_rect = $TextureRect

func set_up_buttons():
	for ts in texture_sets:
		var tb = texture_button.duplicate()
		tb.texture_normal = ts.textures[randi() % ts.textures.size()]
		tb.modulate = Color(1,1,1,0.5)
		tb.connect("pressed", self, "_selection_updated", [tb, ts])
		btn_container.add_child(tb)
	
	# Remove the initial sample button
	btn_container.remove_child(texture_button)
	
	_selection_updated(btn_container.get_child(0), texture_sets[0])

func _selection_updated(tb: TextureButton, ts: TextureSet):
	texture_rect.texture = ts.textures[randi() % ts.textures.size()]
	
	# Fade out all options except selected one
	for tb_option in btn_container.get_children():
		tb_option.modulate = Color(1,1,1,0.5)
	
	tb.modulate = Color(1,1,1,1)
	emit_signal("selection_updated", ts)
