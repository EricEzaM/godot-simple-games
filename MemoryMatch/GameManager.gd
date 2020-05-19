extends Node2D

onready var current_scene = $Levels.get_child(0)


func _ready():
	Events.connect("scene_change_request", self, "change_scene")
	Events.connect("toggle_options", self, "toggle_options")


func change_scene(to_scene):
	var scene = load(to_scene)
	yield(get_tree(), "idle_frame") #continue on idle frame
	var new_scene = scene.instance()
	$Levels.add_child(new_scene)
	# Replace current scene with the newly loaded scene
	current_scene.free()
	current_scene = new_scene;

func toggle_options(show_options: bool):
	$OptionsMenu.toggle_options(show_options)
