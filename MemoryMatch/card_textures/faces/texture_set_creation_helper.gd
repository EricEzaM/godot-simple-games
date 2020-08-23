tool
extends EditorScript

# Helper to create TextureSet resource from a folder of textures.

const ts_name = "basic_green" # CHANGE THIS

func _run():
	var path = "res://card_textures/faces/"
	var fullpath = path + "/" + ts_name
	
	var ts = TextureSet.new()
	
	var dir = Directory.new()
	if dir.open(fullpath) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() or file_name.find(".import") > -1:
				pass
			else:
				ts.textures.append(load(fullpath + "/" + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	ResourceSaver.save("%s/ts_%s.tres" % [path, ts_name], ts)

	print("Saved %s textures into resource ts_%s.tres" % [ts.textures.size(), ts_name])
