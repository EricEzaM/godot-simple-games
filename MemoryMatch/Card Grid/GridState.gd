extends Node

onready var reset_timer: Timer = $ResetTimer

var card_1
var card_2

var tries_count = 0
var match_count = 0
var max_match_count = -1

func _ready():
	# Don't need to pass binds since cards are stored on the class level
	reset_timer.connect("timeout", self, "_on_timer_expired")


func reset(max_matches: int):
	tries_count = 0
	match_count = 0
	max_match_count = max_matches
	Events.emit_signal("match_count_updated", match_count, max_match_count)
	Events.emit_signal("tries_count_updated", 0)
	_reset_card_selection()


func _on_card_shown(card):
	# Don't do anything if waiting for cards to hide, or if cards same id
	if (!reset_timer.is_stopped()
			or (card_1 != null) and (card_1.id == card.id)):
		return
	
	card.show()

	# Test if this is the first or second card being flipped
	if card_1 == null:
		card_1 = card
		return

	tries_count += 1
	card_2 = card
	Events.emit_signal("tries_count_updated", tries_count)
	
	if card_1.pair_id == card.pair_id:
		_cards_match()
	else:
		_cards_different()


func _cards_match():
	card_1.set_matched()
	card_2.set_matched()

	_reset_card_selection()

	match_count += 1
	Events.emit_signal("match_count_updated", match_count, max_match_count)


func _cards_different():
	reset_timer.start()


func _on_timer_expired():
	card_1.hide()
	card_2.hide()
	_reset_card_selection()


func _reset_card_selection():
	card_1 = null
	card_2 = null
