extends Label

export (Resource) var tries_count_updated_event: Resource

func _ready():
	tries_count_updated_event.connect("event_signal", self, "_update_score")
	pass


func _update_tries(tries):
	text = "%s" % tries