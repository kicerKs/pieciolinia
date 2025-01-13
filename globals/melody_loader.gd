extends Node

func melody_load(path: String = "default_save.staff"):
	if not FileAccess.file_exists(path):
		return 
	
	var save_file = FileAccess.open(path, FileAccess.READ)
	Melody.clear()
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var node_data = json.data

		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			if node_data[i] is Array:
				Melody.set(i, read_tracks(node_data[i]))
			else:
				Melody.set(i, node_data[i])
	Global.reset()
	Global.max_track = len(Melody.tracks)-1 if len(Melody.tracks)>0 else 0

func read_tracks(node_data: Array):
	var tracks: Array[Track] = []
	for x in node_data:
		var track: Track = Track.new()
		for i in x.keys():
			if x[i] is Array:
				track.set(i, read_bars(x[i]))
			else:
				track.set(i, x[i])
		tracks.append(track)
	return tracks

func read_bars(node_data: Array):
	var bars: Array[Bar] = []
	for x in node_data:
		var bar: Bar = Bar.new()
		for i in x.keys():
			if x[i] is Array:
				bar.set(i, read_elements(x[i]))
			else:
				bar.set(i, x[i])
		bars.append(bar)
	return bars

func read_elements(node_data: Array):
	var elements: Array[StaffDrawable] = []
	for x in node_data:
		var element: StaffDrawable = get_object(x)
		for i in x.keys():
			if x[i] is Dictionary and i == "_dynamicsMetaEvent":
				element.set(i, read_dynamic_event(x[i]))
			elif x[i] is Dictionary and i == "_pedalMetaEvent":
				element.set(i, read_pedal_event(x[i]))
			else:
				element.set(i, x[i])
		elements.append(element)
	return elements

func read_dynamic_event(dict: Dictionary):
	return DynamicsMetaEvent.new(dict["type"])

func read_pedal_event(dict: Dictionary):
	return PedalMetaEvent.new(dict["type"])


func get_object(fields: Dictionary) -> Object:
	if(fields.keys().find("_dot")>=0):
		if(fields["class"] == "Note"):
			return Note.new(Note.Type.HALF,0)
		else:
			return Pause.new()
	else:
		return Accidental.new(Accidental.Type.NATURAL, 1)
