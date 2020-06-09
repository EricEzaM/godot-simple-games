extends Node

func play():
	var i = randi() % get_child_count()
	var child: AudioStreamPlayer = get_child(i)
	child.play()
