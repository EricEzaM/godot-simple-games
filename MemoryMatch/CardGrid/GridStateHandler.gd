extends Node

# Is this the place for it?
signal game_over

onready var flip_timer: Timer = $FlipTimer
export (Resource) var match_count_updated_event

var card_1
var card_2

var match_count = 0
var max_match_count = -1

func _ready():
	# Don't need to pass binds since cards are stored on the class level
	flip_timer.connect("timeout", self, "_on_timer_expired")


func reset(max_matches: int):
	match_count = 0
	max_match_count = max_matches
	match_count_updated_event.emit_signal("event_signal", match_count, max_match_count)
	_reset_card_selection()


func _on_card_clicked(card):
	# Don't do anything if the card is already matched, or if in 'flipped' state
	if card.state == card.State.Matched or !flip_timer.is_stopped():
		return
	
	# If no card is currently flipped, set it to be and return, since we don't need to test
	if card_1 == null:
		card.show()
		card_1 = card
		return
	else:
		card.show()
		card_2 = card
	
	print("Testing match between %s (#%s) and %s (#%s)" % [card_1.id, card_1.pair_number, card_2.id, card_2.pair_number])
	# If they are the same pair (and not the same card id) then it's a match!
	if (card_1.pair_number == card.pair_number and card_1.id != card.id):
		_cards_match()
	else:
		_cards_different()


func _cards_match():
	card_1.state = card_1.State.Matched
	card_2.state = card_2.State.Matched
	_reset_card_selection()
	match_count += 1
	match_count_updated_event.emit_signal("event_signal", match_count, max_match_count)


func _cards_different():
	flip_timer.start()


func _on_timer_expired():
	card_1.hide()
	card_2.hide()
	_reset_card_selection()


func _reset_card_selection():
	card_1 = null
	card_2 = null
