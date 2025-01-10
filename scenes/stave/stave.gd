extends Node2D

var note_size = 105
var accidental_size = 25
var vacant_space_size = 10
var stave_length = 150
@export var space_between_notes = 10
@export var stave_element_scene: PackedScene

var stave_number: int = 0

# Positions y
# Model = Coords
# 0, 1 = 282
# 2, 3 = 266
# 4 = 251
# 5, 6 = 235
# 7, 8 = 219
# 9, 10 = 204
# 11 = 188
# 12, 13 = 173
# 14, 15 = 157
# 16 = 142
# 17, 18 = 126
# 19, 20 = 111
# 21, 22 = 95
# 23 = 80

var notes_position = {0: 282, 1: 266, 2: 251, 3: 235, 4: 219, 5: 204, 6: 188, 7: 173, 8: 157, 9: 142, 10: 126, 11: 111, 12: 95, 13: 80, 14: 64}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var measure_up = 4
	var measure_down = 4
	$MeasureDownLabel.text = str(measure_down)
	$MeasureUpLabel.text = str(measure_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup_stave(stv_nmb: int):
	stave_number = stv_nmb
	position_elements()
	$MeasureDownLabel.text = str(Melody.meter_bottom)
	$MeasureUpLabel.text = str(Melody.meter_top)
	stave_length = 150
	var i = 0
	if Melody.tracks[stave_number].get_key_type() == Track.KeyType.TREBLE:
		$Clef.texture = load("res://assets/misc/tremble.png")
	elif Melody.tracks[stave_number].get_key_type() == Track.KeyType.BASS:
		$Clef.texture = load("res://assets/misc/bass.png")
	for bar in Melody.tracks[stave_number].get_bars():
		var j = 0
		for el in bar.get_elements():
			# Vacant Space
			add_vacant_space(i,j)
			# Staff Element
			var new_element = stave_element_scene.instantiate()
			new_element.setup(i, el, Vector2i(stave_length,notes_position[el.get_position()]+(get_viewport_rect().size.y*stave_number)))
			if el is Note:
				stave_length += note_size
			elif el is Accidental:
				stave_length += accidental_size
			add_child(new_element)
			new_element.name = "StaveElement"+str(i)+"-"+str(j)
			new_element.add_to_group("stave_elements")
			j+=1
			stave_length += space_between_notes
		add_vacant_space(i,j)
		stave_length += 10
		var new_barline = ColorRect.new()
		new_barline.size = Vector2(1, 125)
		new_barline.color = Color(0,0,0,1)
		new_barline.position = Vector2(stave_length, 235+(get_viewport_rect().size.y*stave_number))
		add_child(new_barline)
		new_barline.name = "Barline"+str(i)
		new_barline.add_to_group("stave_elements")
		i+=1
		stave_length += 11
	add_vacant_space(i,0)
	
	$Background.size.x = stave_length
	$"Line 1".size.x = stave_length
	$"Line 2".size.x = stave_length
	$"Line 3".size.x = stave_length
	$"Line 4".size.x = stave_length
	$"Line 5".size.x = stave_length
	Global.set_stave_length(stave_length)

func add_vacant_space(i, j):
	var new_space = ColorRect.new()
	new_space.color = Color(0,1,0)
	new_space.size = Vector2(vacant_space_size, 255)
	new_space.position = Vector2(stave_length, 155+(get_viewport_rect().size.y*stave_number))
	stave_length += vacant_space_size+space_between_notes
	add_child(new_space)
	new_space.name="Space"+str(i)+"-"+str(j)
	new_space.add_to_group("stave_elements")
	new_space.gui_input.connect(_add_element.bind(new_space))

func position_elements():
	$Background.position.y+=(get_viewport_rect().size.y*stave_number)
	$"Line 1".position.y+=(get_viewport_rect().size.y*stave_number)
	$"Line 2".position.y+=(get_viewport_rect().size.y*stave_number)
	$"Line 3".position.y+=(get_viewport_rect().size.y*stave_number)
	$"Line 4".position.y+=(get_viewport_rect().size.y*stave_number)
	$"Line 5".position.y+=(get_viewport_rect().size.y*stave_number)
	$MeasureUpLabel.position.y+=(get_viewport_rect().size.y*stave_number)
	$MeasureDownLabel.position.y+=(get_viewport_rect().size.y*stave_number)
	$Clef.position.y+=(get_viewport_rect().size.y*stave_number)

func reload_stave():
	for el in get_tree().get_nodes_in_group("stave_elements"):
		remove_child(el)
		el.queue_free()
	setup_stave(stave_number)

func _add_element(event: InputEvent, sender):
	if event is InputEventMouseButton and event.pressed:
		var name_s = sender.name.substr(4).split("-")
		print("Adding element")
		var new_element
		match Global.toolbox_element:
			"WholeRest":
				new_element = Pause.new(Pause.Type.WHOLE)
			"HalfRest":
				new_element = Pause.new(Pause.Type.HALF)
			"QuarterRest":
				new_element = Pause.new(Pause.Type.QUARTER)
			"EightRest":
				new_element = Pause.new(Pause.Type.EIGHTH)
			"SixteenthRest":
				new_element = Pause.new(Pause.Type.SIXTEENTH)
			"ThirtysecondRest":
				new_element = Pause.new(Pause.Type.THIRTYSECOND)
			"WholeNote":
				new_element = Note.new(Note.Type.WHOLE, 14-int(sender.get_local_mouse_position().y/17))
				print(int(sender.get_local_mouse_position().y/15))
			"HalfNote":
				new_element = Note.new(Note.Type.HALF, 14-int(sender.get_local_mouse_position().y/17))
				print(int(sender.get_local_mouse_position().y/15))
			"QuarterNote":
				new_element = Note.new(Note.Type.QUARTER, 14-int(sender.get_local_mouse_position().y/17))
				print(int(sender.get_local_mouse_position().y/15))
			"EightNote":
				new_element = Note.new(Note.Type.EIGHTH, 14-int(sender.get_local_mouse_position().y/17))
				print(int(sender.get_local_mouse_position().y/15))
			"SixteenthNote":
				new_element = Note.new(Note.Type.SIXTEENTH, 14-int(sender.get_local_mouse_position().y/17))
				print(int(sender.get_local_mouse_position().y/15))
			"ThirtysecondNote":
				new_element = Note.new(Note.Type.THIRTYSECOND, 14-int(sender.get_local_mouse_position().y/17))
				print(int(sender.get_local_mouse_position().y/15))
			"Sharp":
				new_element = Accidental.new(Accidental.Type.SHARP, 14-int(sender.get_local_mouse_position().y/17))
			"Natural":
				new_element = Accidental.new(Accidental.Type.NATURAL, 14-int(sender.get_local_mouse_position().y/17))
			"Flat":
				new_element = Accidental.new(Accidental.Type.FLAT, 14-int(sender.get_local_mouse_position().y/17))
		Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()]._elements.insert(name_s[1].to_int(),new_element)
		reload_stave()
