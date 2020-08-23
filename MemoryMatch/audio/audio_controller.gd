extends Node

func play():
	var i = randi() % get_child_count()
	var child: AudioStreamPlayer = get_child(i)
	child.play()


var _current_repeat_player: AudioStreamPlayer
func play_repeat_random():
	print("Playing next random player.")
	if _current_repeat_player != null:
		_current_repeat_player.disconnect("finished", self, "play_repeat_random")
		
	var i = randi() % get_child_count()
	var child: AudioStreamPlayer = get_child(i)
	while child == _current_repeat_player:
		print("Got same player, trying again")
		i = randi() % get_child_count()
		child = get_child(i)
		
	_current_repeat_player = child
	child.connect("finished", self, "play_repeat_random")
	child.play()
