extends TextureRect

signal card_clicked(card)

var id = -1
var pair_number = -1
var _reset_color := Color(0,0,0,0)
var color := Color(0,0,0,0)

var show_texture: Texture
var hide_texture: Texture

var state = State.Unmatched

enum State {
	Unmatched
	Matched
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#	Duplicate the material to get a unique instance
	set_material(get_material().duplicate())
	color = material.get_shader_param("border_color")
	_set_border_color(_reset_color)


func initialise_card(p_pair_number, p_show_texture, p_hide_texture):
	pair_number = p_pair_number
	show_texture = p_show_texture
	hide_texture = p_hide_texture


func show():
	texture = show_texture
	pass


func hide():
	texture = hide_texture
	pass


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("card_clicked", self)


func _on_hover():
	_set_border_color(color)


func _on_hover_exit():
	_set_border_color(_reset_color)


func _set_border_color(c: Color):
	material.set_shader_param("border_color", c)
