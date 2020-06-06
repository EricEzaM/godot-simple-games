extends Node
# Stores configuration for the game.

# --- Signals
# --- Enums
# --- Constants
# --- Exported Variables
export (int) var number_of_cards
export (Array, Resource) var available_card_face_texture_sets
export (Array, Texture) var available_card_back_textures
# --- Public Variables
var card_face_texture_set
var card_back_texture
var grid_size
var error_msg
# --- Private Variables
# --- Onready Variables

func _ready():
	pass

# --- Virtual Override methods
# --- Public Methods

# Ensures that configuration is within the limits we determine
func is_valid()->bool:
	
	#	Card Limit
	if number_of_cards > 120:
		return false
	
	grid_size = calculate_grid_size(number_of_cards)
	if grid_size == Vector2():
		return false
	else:
		error_msg = ""
		return true


# Calculates grid size for some given amount of cards
func calculate_grid_size(n: int	) -> Vector2:
	#	Check that there is no odd card!
	if n % 2 != 0:
		error_msg = "Number of cards must be even. %s is not an even number." % n
		return Vector2()
	
	if n < 4:
		error_msg = "Number of card must be more than ore equal to 4."
		return Vector2()
	
	var fct = _calculate_factors(n)
	
	#	The custom sorter sorts the array by how close the factor is to the
	#	square root of the number of tiles, to make the 'most square' grid
	var fs_inst = FactorSorter.new()
	fs_inst.root = sqrt(n)
	fct.sort_custom(fs_inst, "sort")
	
	var grid_dims = fct.slice(0,1) # take top 2 elements
	
	# factors must be reasonably close
	if abs(fct[0] - sqrt(n)) > 3 or abs(fct[1] - sqrt(n)) > 3:
		error_msg = "Unable to create good grid from %s cards. Try a different number" % n
		return Vector2()
	
	#	If the number can make a perfect square, then do that
	if fct[0] == sqrt(n):
		return Vector2(grid_dims.max(), grid_dims.max())
	#	If not, make the larger factor which is closest to the sqrt be the x dim, 
	# so x will always be greater than y
	else:
		return Vector2(grid_dims.max(), grid_dims.min())

# --- Private Methods

# Calculates the factors for a given number
func _calculate_factors(n: int) -> Array:
	var fct = []

	for i in range(1, n+1):
		if n % i == 0:
			fct.append(i)
	return fct


# Custom sorter to sort an array by how close the values are to another number
class FactorSorter:
	var root : float 
	func sort(a, b):
		var a_f = abs(root - a)
		var b_f = abs(root - b)
		return true if a_f < b_f else false
