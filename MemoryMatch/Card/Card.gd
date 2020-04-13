extends TextureRect

var id = -1
var _reset_color := Color(0,0,0,0)
var color := Color(0,0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	#	Duplicate the material to get a unique instance
	set_material(get_material().duplicate())
	color = material.get_shader_param("border_color")
	_set_border_color(_reset_color)


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Clicked " + str(id))


func _on_hover():
	_set_border_color(color)


func _on_hover_exit():
	_set_border_color(_reset_color)


func _set_border_color(c: Color):
	material.set_shader_param("border_color", c)
