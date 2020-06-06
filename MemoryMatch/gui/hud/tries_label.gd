extends Label


func _ready():
	Events.connect("tries_count_updated", self, "_update_tries")
	pass


func _update_tries(tries):
	text = "%s" % tries
