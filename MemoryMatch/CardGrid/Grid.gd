extends GridContainer


export (int) var number_of_cards = 4
onready var card = preload("res://Card/Card.tscn")

var match_pairs = []

func _ready():
	remove_all_cards()
	initialise_cards(number_of_cards)
	_create_match_pairs()


func initialise_cards(num_cards : int):	
	#	Calculate grid size and set columns
	var grid_size = calculate_grid_size(num_cards)
	var grid_size_ratio = grid_size.x / grid_size.y # x dimension = y * ratio dimension = x / ratio
	#	Error catching
	if grid_size == Vector2():
		return
	
	#	Set columns to the x value
	columns = grid_size.x
	
	#	Spawn cards
	for i in range(num_cards):
		var card_inst = card.instance()
		card_inst.id = i
		add_child(card_inst)

	# Set size of grid container to fill parent, depending on layout of cards
	var parent_size = get_parent().rect_size
	if grid_size.x > grid_size.y: 
		# x is longest dimension, thus fill all of parent width
		rect_size.x = parent_size.x
		rect_size.y = parent_size.x / grid_size_ratio
	else:
		# y is longer dimension, thus fill all of parent height
		rect_size.y = parent_size.y
		rect_size.x = parent_size.y * grid_size_ratio
		
	#	Center grid, but keep the rect_size that was set above
	set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)


func calculate_grid_size(n: int	) -> Vector2:
	#	Check that there is no odd card!
	if n % 2 != 0:
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
	#	If not, make the larger factor which is closest to the sqrt be the x dim
	else:
		return Vector2(grid_dims.max(), grid_dims.min())


func remove_all_cards():
	for child in get_children():
		remove_child(child)


func _get_card_rect_size():
	var card_inst = card.instance()
	var size = card_inst.rect_size	
	card_inst.queue_free()
	return size


func _calculate_factors(n: int) -> Array:
	var fct = []
	
	for i in range(1, n+1):
		if n % i == 0:
			fct.append(i)
	return fct


func _create_match_pairs():
	# Array with card id's: 0...number_of_cards
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

	print(match_pairs)

class FactorSorter:
	var root : float 
	func sort(a, b):
		var a_f = abs(root - a)
		var b_f = abs(root - b)
		return true if a_f < b_f else false
