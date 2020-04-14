extends GridContainer

func recalculate_size(max_dimensions : Vector2, grid_size : Vector2) -> void:
		var grid_size_ratio = grid_size.x / grid_size.y # x dimension = y * ratio dimension = x / ratio
		
		# Set size of grid container to fill parent, depending on layout of cards
		if grid_size.x > grid_size.y: 
			# x is longest dimension, thus fill all of parent width
			rect_size.x = max_dimensions.x
			rect_size.y = max_dimensions.x / grid_size_ratio
		else:
			# y is longer dimension, thus fill all of parent height
			rect_size.y = max_dimensions.y
			rect_size.x = max_dimensions.y * grid_size_ratio
			
		#	Center grid, but keep the rect_size that was set above
		set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)