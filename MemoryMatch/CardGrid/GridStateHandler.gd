extends Node

# Is this the place for it?
signal game_over
signal match_count_updated(new_count)

var current_flip

var match_count = 0

func _on_card_flipped(card):
	# If no card is currently flipped, set it to be and return, since we don't need to test
	if current_flip == null:
		current_flip = card
		return
	
	# If they are the same pair (and not the same card id) then it's a match!
	if (current_flip.pair_number == card.pair_number and 
			current_flip.id != card.id):
			_cards_match(current_flip, card)
	else:
		_cards_different(current_flip, card)
		pass


func _cards_match(card1, card2):
	card1.show()
	card2.show()
	match_count += 1
	emit_signal("match_count_updated", match_count)


func _cards_different(card1, card2):
	card1.hide()
	card2.hide()
	current_flip = null