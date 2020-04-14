extends Control

export (int) var number_of_cards = 4

onready var card = preload("res://Card/Card.tscn")
onready var gc : GridContainer = $GridContainer

var match_pairs = []


func _ready():
	remove_all_cards()
	initialise_cards(number_of_cards)
	_create_match_pairs()


func initialise_cards(num_cards : int):	
	#	Calculate grid size and set columns
	var grid_size = calculate_grid_size(num_cards)
	#	Error catching
	if grid_size == Vector2():
		return
	
	#	Set columns to the x value
	gc.columns = grid_size.x
	
	#	Spawn cards
	for i in range(num_cards):
		var card_inst = card.instance()
		card_inst.id = i
		gc.add_child(card_inst)

	# Recalculate the size of the grid container so it fits all the cards
	# and fills all the space possible
	gc.recalculate_size(rect_size, grid_size)


func calculate_grid_size(n: int	) -> Vector2:
	#	Check that there is no odd card!
	if n % 2 != 0:
		# TODO: give feedback to the player about this error
		print("Number of cards must be even. %s is not an even number." % n)
		return Vector2()
	
	var fct = _calculate_factors(n)
	
	#	The custom sorter sorts the array by how close the factor is to the
	#	square root of the number of tiles, to make the 'most square' grid
	var fs_inst = FactorSorter.new()
	fs_inst.root = sqrt(n)
	fct.sort_custom(fs_inst, "sort")
	
	var grid_dims = fct.slice(0,1) # take top 2 elements
	#	If the number can make a perfect square, then do that
	if fct[0] == sqrt(n):
		return Vector2(grid_dims.max(), grid_dims.max())
	#	If not, make the larger factor which is closest to the sqrt be the x dim, 
	# so x will always be greater than y
	else:
		return Vector2(grid_dims.max(), grid_dims.min())


func remove_all_cards():
	var gc_children = gc.get_children()
	for child in gc_children:
		gc.remove_child(child)
	print(gc.get_child_count())


func _get_card_rect_size():
	var card_inst = card.instance()
	var size = card_inst.rect_size	
	card_inst.queue_free()
	return size


func _calculate_factors(n: int) -> Array:
	var fct = []
	
	# This is not the fastest method of doing this, but it doesnt matter
	# since the number of cards is small enough not to matter
	for i in range(1, n+1):
		if n % i == 0:
			fct.append(i)
	return fct


func _create_match_pairs():
	# Array with card id's, since cards are just given sequential numbers as ids
	var all_cards = range(number_of_cards)

	randomize()
	# The number of matches = number of cards / 2
	for _i in range(number_of_cards/2):
		# Get random card id from all_cards
		var id1 = randi() % all_cards.size()
		# Remove that id from the card list so it can't be chosen again
		all_cards.erase(id1)
		# Repeat
		var id2 = randi() % all_cards.size()
		all_cards.erase(id2)

		# Pairs will be stored as 2-element arrays
		match_pairs.append([id1, id2])


# Custom sorter to sort an array by how close the values are to the square root
# of some number
class FactorSorter:
	var root : float 
	func sort(a, b):
		var a_f = abs(root - a)
		var b_f = abs(root - b)
		return true if a_f < b_f else false
