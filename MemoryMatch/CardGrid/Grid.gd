extends GridContainer


export (int) var number_of_cards = 4
onready var card = preload("res://Card/Card.tscn")


func _ready():
	remove_all_cards()
	initialise_cards(number_of_cards)


func initialise_cards(num_cards : int):	
	#	Calculate grid size and set columns
	var grid_size = calculate_grid_size(num_cards)
	
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
	print("grid size: %s" % grid_size)
	#	TODO: Fully construct the rest of the UI around this and rework this
	#	calculation if needed
	var parent_size = get_parent().rect_size
	# print("parent_size: %s" % parent_size)
	# var max_dimension = min(parent_size.y, parent_size.x)
	# print("max dimension: %s" % max_dimension)
	# #	Set size of grid container to format card spacing
	# rect_size = grid_size / min(grid_size.y, grid_size.x) * max_dimension
	# print("rect size: %s" % rect_size)
	# if rect_size.x > parent_size.x:
	# 	rect_size.x = parent_size.x
	# 	rect_size.y = parent_size.x * (parent_size.y / parent_size.x)
	# 	print("rect size adj: %s" % rect_size)
	if grid_size.x > grid_size.y: 
		# x is longest dimensions, thus fills all of parent width
		rect_size.x = parent_size.x
		var xy_ratio = grid_size.x / grid_size.y # x = ratio * y, y is x / ratio
		rect_size.y = parent_size.x / xy_ratio
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


class FactorSorter:
	var root : float 
	func sort(a, b):
		var a_f = abs(root - a)
		var b_f = abs(root - b)
		return true if a_f < b_f else false
