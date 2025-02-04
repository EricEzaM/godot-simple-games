extends TextureRect

signal card_shown(card)


onready var anim_player: AnimationPlayer = $AnimationPlayer

var id = -1
var pair_id = -1
export (Color) var border_color := Color(0,0,0,0)
var _reset_color := Color(0,0,0,0)

var show_texture: Texture
var hide_texture: Texture

var state = State.Unmatched
var allow_click = true

enum State {
	Unmatched
	Matched
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#	Duplicate the material to get a unique instance
	set_material(get_material().duplicate())
	_set_border_color(_reset_color)
	anim_player.connect("animation_finished", self, "_on_animation_finished")


func initialise_card(p_pair_id, p_show_texture, p_hide_texture):
	pair_id = p_pair_id
	show_texture = p_show_texture
	hide_texture = p_hide_texture
	texture = hide_texture


func show():
	allow_click = false
	anim_player.play("flip")
	$ShowAudioController.play()


func hide():
	allow_click = false	
	anim_player.play("flip")
	$HideAudioController.play()


func set_matched():
	state = State.Matched


func update_pivot():
	rect_pivot_offset = rect_size / 2


func _toggle_texture():
	if texture == show_texture:
		texture = hide_texture
	else:
		texture = show_texture


func _on_gui_input(event):
	if (event is InputEventMouseButton and 
			event.pressed and 
			state == State.Unmatched and 
			allow_click):
		emit_signal("card_shown", self)


func _on_hover():
	_set_border_color(border_color)


func _on_hover_exit():
	_set_border_color(_reset_color)


func _set_border_color(c: Color):
	material.set_shader_param("border_color", c)


func _on_animation_finished(anim_name: String):
#	Only allow interaction after anim finished
	allow_click = true
