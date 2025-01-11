extends Node

func save_melody(path: String = "default_save.stiff"):
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var node_data = Melody.call("save")
	var json_string = JSON.stringify(node_data)
	save_file.store_line(json_string)
	
