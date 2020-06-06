extends Control

onready var card = preload("res://Card/Card.tscn")
onready var grid_container : GridContainer = $GridContainer
onready var grid_state = $GridState

var cards = []
var unused_texture_ids = []


func _ready():
	unused_texture_ids = range(GameConfiguration.card_face_texture_set.textures.size())
	initialise_cards(GameConfiguration.number_of_cards)
	_create_match_pairs()
	grid_state.reset(GameConfiguration.number_of_cards / 2)


func initialise_cards(num_cards : int):	
	remove_all_cards()
	#	Calculate grid size and set columns
	var grid_size = GameConfiguration.grid_size
	#	Error catching
	if grid_size == Vector2():
		return
	
	#	Set columns to the x value
	grid_container.columns = grid_size.x
	
	#	Spawn cards
	for i in range(num_cards):
		var card_inst = card.instance()
		card_inst.id = i
		card_inst.call_deferred("update_pivot")
		card_inst.connect("card_shown", grid_state, "_on_card_shown")
		
		cards.append(card_inst)
		grid_container.add_child(card_inst)

	# Recalculate the size of the grid container so it fits all the cards
	# and fills all the space possible
	grid_container.recalculate_size(rect_size, grid_size)


func remove_all_cards():
	var all_cards = grid_container.get_children()
	for child in all_cards:
		grid_container.remove_child(child)


func _create_match_pairs():
	# Use this to track which indices of 'cards' have been assigned a pair
	var remaining_indices = range(GameConfiguration.number_of_cards)
	randomize()

	for pair_id in range(GameConfiguration.number_of_cards/2):
		# Get 2 random cards, removing them from remaining cards after selection
		# So they cannot be selected again
		var i1 = randi() % remaining_indices.size()
		var card_1 = cards[remaining_indices[i1]]
		remaining_indices.remove(i1)

		var i2 = randi() % remaining_indices.size()
		var card_2 = cards[remaining_indices[i2]]
		remaining_indices.remove(i2)
		
		randomize()
		var tex_idx = unused_texture_ids[randi() % unused_texture_ids.size()]
		var tex = GameConfiguration.card_face_texture_set.textures[tex_idx]
		unused_texture_ids.erase(tex_idx)

		card_1.initialise_card(pair_id, tex, GameConfiguration.card_back_texture)
		card_2.initialise_card(pair_id, tex, GameConfiguration.card_back_texture)


func _get_card_rect_size():
	var card_inst = card.instance()
	var size = card_inst.rect_size	
	card_inst.queue_free()
	return size
