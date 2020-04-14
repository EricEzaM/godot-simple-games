extends Button
tool

onready var background : TextureRect = $Background
onready var content : TextureRect = $Content

export (Resource) var button_color_config

func _ready():
  _set_default_color()
  pass

func _on_button_down():
  _set_clicked_color()
  pass

func _on_button_up():
  _set_hover_color()
  pass

func _on_mouse_entered():
  _set_hover_color()
  pass

func _on_mouse_exited():
  _set_default_color()
  pass

func _set_default_color():
  background.modulate = button_color_config.background
  content.modulate = button_color_config.foreground

func _set_clicked_color():
  background.modulate = button_color_config.background_click
  content.modulate = button_color_config.foreground_click

func _set_hover_color():
  background.modulate = button_color_config.background_hover
  content.modulate = button_color_config.foreground_hover
