extends Label

export (Resource) var match_count_updated_event: Resource

func _ready():
	match_count_updated_event.connect("event_signal", self, "_update_score")
	pass


func _update_score(new_score, max_score):
	text = "%s / %s" % [new_score, max_score]
