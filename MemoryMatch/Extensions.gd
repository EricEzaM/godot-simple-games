class_name Extensions
# Docstring

static func array_map(p_arr: Array, p_func: FuncRef) -> Array:
	var o_array := []
	for val in p_arr:
		o_array.append(p_func.call_func(val))
	return o_array
	
static func array_filter(p_arr: Array, p_func: FuncRef) -> Array:
	var o_array := []
	
	for val in p_arr:
		if p_func.call_func(val):
			o_array.append(val)
			
	return o_array
