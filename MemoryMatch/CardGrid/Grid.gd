extends Control

export (int) var number_of_cards = 4
export (Texture) var card_back_texture
export (Resource) var texture_set

onready var card = preload("res://Card/Card.tscn")
onready var grid_container : GridContainer = $GridContainer
onready var grid_state = $GridState

var cards = []
var unused_texture_ids = []

func _ready():
	unused_texture_ids = range(texture_set.textures.size())
	initialise_cards(number_of_cards)
	_create_match_pairs()
	grid_state.reset(number_of_cards / 2)

func initialise_cards(num_cards : int):	
	remove_all_cards()
	#	Calculate grid size and set columns
	var grid_size = calculate_grid_size(num_cards)
	#	Error catching
	if grid_size == Vector2():
		return
	
	#	Set columns to the x value
	grid_container.columns = grid_size.x
	
	#	Spawn cards
	for i in range(num_cards):
		var card_inst = card.instance()
		card_inst.id = i
		card_inst.connect("card_shown", grid_state, "_on_card_shown")
		cards.append(card_inst)
		grid_container.add_child(card_inst)

	# Recalculate the size of the grid container so it fits all the cards
	# and fills all the space possible
	grid_container.recalculate_size(rect_size, grid_size)


func calculate_grid_size(n: int	) -> Vector2:
	#	Check that there is no odd card!
	if n % 2 != 0:
		# TODO: move this to some more general validation method and use it to 
		# validate UI input, so game cannot be started with odd number of cards,
		# or cards with bad factors (as below)
		print("Number of cards must be even. %s is not an even number." % n)
		return Vector2()
	
	var fct = _calculate_factors(n)
	
	#	The custom sorter sorts the array by how close the factor is to the
	#	square root of the number of tiles, to make the 'most square' grid
	var fs_inst = FactorSorter.new()
	fs_inst.root = sqrt(n)
	fct.sort_custom(fs_inst, "sort")
	
	var grid_dims = fct.slice(0,1) # take top 2 elements
	
	# factors must be reasonably close
	if abs(fct[0] - fct[1]) > 3:
		print("Bad factors")
		return Vector2()
	
	#	If the number can make a perfect square, then do that
	if fct[0] == sqrt(n):
		return Vector2(grid_dims.max(), grid_dims.max())
	#	If not, make the larger factor which is closest to the sqrt be the x dim, 
	# so x will always be greater than y
	else:
		return Vector2(grid_dims.max(), grid_dims.min())


func remove_all_cards():
	var all_cards = grid_container.get_children()
	for child in all_cards:
		grid_container.remove_child(child)


func _create_match_pairs():
	# Use this to track which indices of 'cards' have been assigned a pair
	var remaining_indices = range(number_of_cards)
	randomize()

	for pair_id in range(number_of_cards/2):
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
		var tex = texture_set.textures[tex_idx]
		unused_texture_ids.erase(tex_idx)

		card_1.initialise_card(pair_id, tex, card_back_texture)
		card_2.initialise_card(pair_id, tex, card_back_texture)


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


func _filter_array(arr : Array, predicate : FuncRef) -> Array:
	var filtered = []
	for e in arr:
		if predicate.call_func(e):
			filtered.append(e)
	
	return filtered

# Custom sorter to sort an array by how close the values are to another number
class FactorSorter:
	var root : float 
	func sort(a, b):
		var a_f = abs(root - a)
		var b_f = abs(root - b)
		return true if a_f < b_f else false
