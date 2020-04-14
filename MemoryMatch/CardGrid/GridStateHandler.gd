extends Node

# Is this the place for it?
signal game_over

var current_flip

func _on_card_flipped(card):
	if current_flip == null:
		current_flip = card
	else:
		if current_flip.pair_number == card.pair_number && current_flip.id != card.id:
			print("match!")
		else:
			# card.hide()
			# current_flip.hide()
			current_flip = null
			pass
