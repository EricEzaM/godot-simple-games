extends TextureRect

signal card_shown(card)

var id = -1
var pair_id = -1
export (Color) var border_color := Color(0,0,0,0)
var _reset_color := Color(0,0,0,0)

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
	_set_border_color(_reset_color)


func initialise_card(p_pair_id, p_show_texture, p_hide_texture):
	pair_id = p_pair_id
	show_texture = p_show_texture
	hide_texture = p_hide_texture


func show():
	texture = show_texture
	pass


func hide():
	texture = hide_texture
	pass


func set_matched():
	state = State.Matched


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and state == State.Unmatched:
		emit_signal("card_shown", self)


func _on_hover():
	_set_border_color(border_color)


func _on_hover_exit():
	_set_border_color(_reset_color)


func _set_border_color(c: Color):
	material.set_shader_param("border_color", c)
