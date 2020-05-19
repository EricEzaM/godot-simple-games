extends Label


func _ready():
	Events.connect("match_count_updated", self, "_update_score")
	pass


func _update_score(new_score, max_score):
	text = "%s / %s" % [new_score, max_score]
