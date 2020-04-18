extends Node

# Is this the place for it?
signal game_over

onready var reset_timer: Timer = $ResetTimer
export (Resource) var match_count_updated_event

var card_1
var card_2

var match_count = 0
var max_match_count = -1

func _ready():
	# Don't need to pass binds since cards are stored on the class level
	reset_timer.connect("timeout", self, "_on_timer_expired")


func reset(max_matches: int):
	match_count = 0
	max_match_count = max_matches
	match_count_updated_event.emit_signal("event_signal", match_count, max_match_count)
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

	card_2 = card
	if card_1.pair_id == card.pair_id:
		_cards_match()
	else:
		_cards_different()


func _cards_match():
	card_1.set_matched()
	card_2.set_matched()

	_reset_card_selection()

	match_count += 1
	match_count_updated_event.emit_signal("event_signal", match_count, max_match_count)


func _cards_different():
	reset_timer.start()


func _on_timer_expired():
	card_1.hide()
	card_2.hide()
	_reset_card_selection()


func _reset_card_selection():
	card_1 = null
	card_2 = null
