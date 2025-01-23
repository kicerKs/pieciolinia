extends Node2D

var note_size = 105
var accidental_size = 25
var vacant_space_size = 10
var stave_length = 150
@export var space_between_notes = 10
@export var stave_element_scene: PackedScene

var stave_number: int = 0
var showed = false
var dnd = false

var playing_i = 0
var playing_j = 0

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
	Global.toolbox_element_changed.connect(set_vacants_visible)
	Global.toolbox_element_reseted.connect(hide_vacants)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if showed:
		$StavePhantom.visible = false
		for space in get_tree().get_nodes_in_group("vacant_spaces"):
			var pos = get_local_mouse_position()
			if pos.x >= space.position.x and pos.x <= space.position.x + space.size.x and pos.y >= space.position.y and pos.y <= space.position.y + space.size.y:
				$StavePhantom.visible = true
				$StavePhantom.position.x = space.position.x
				var y_pos = clamp(pos.y, space.position.y, space.position.y+space.size.y)
				if Global.dnd_element is Pause or Global.toolbox_element in ["WholeRest", "HalfRest", "QuarterRest", "EightRest", "SixteenthRest", "ThirtysecondRest"]:
					$StavePhantom.position.y = notes_position[3]
				else:
					$StavePhantom.position.y = notes_position[clamp(14-int(space.get_local_mouse_position().y/17),0,14)]+(get_viewport_rect().size.y*stave_number)
				if dnd:
					$StavePhantom.set_texture_from_dnd()
				else:
					$StavePhantom.set_texture_from_toolbox()
	else:
		$StavePhantom.visible = false

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
			new_element.add_to_group("stave_elements"+str(stave_number))
			new_element.connect("dnd_activated", set_vacants_visible)
			new_element.connect("dnd_activated", init_dnd)
			new_element.connect("dnd_deactivated", hide_vacants)
			new_element.connect("dnd_deactivated", clr_dnd)
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
		new_barline.add_to_group("stave_elements"+str(stave_number))
		var new_barline_indicator = Label.new()
		new_barline_indicator.text = str(i+1)
		new_barline_indicator.position = Vector2(stave_length+15, 200+(get_viewport_rect().size.y*stave_number))
		new_barline_indicator.set("theme_override_colors/font_color",Color(Color.BLACK))
		add_child(new_barline_indicator)
		new_barline_indicator.name = "BarlineIndicator"+str(i)
		new_barline_indicator.add_to_group("stave_elements"+str(stave_number))
		add_bar_border(i, j)
		i+=1
		stave_length += 11
	add_vacant_space(i,0)

	$Background.size.x = max(stave_length, get_viewport_rect().size.x)
	$"Line 1".size.x = max(stave_length, get_viewport_rect().size.x)
	$"Line 2".size.x = max(stave_length, get_viewport_rect().size.x)
	$"Line 3".size.x = max(stave_length, get_viewport_rect().size.x)
	$"Line 4".size.x = max(stave_length, get_viewport_rect().size.x)
	$"Line 5".size.x = max(stave_length, get_viewport_rect().size.x)
	if stave_number == Global.current_viewing_track:
		Global.set_stave_length(stave_length)
	
	validate_stave()
	if Global.toolbox_element == null or Global.toolbox_element == "Remove":
		hide_vacants()

func add_vacant_space(i, j):
	var new_space = ColorRect.new()
	new_space.color = Color(0,1,0)
	new_space.size = Vector2(vacant_space_size, 255)
	new_space.position = Vector2(stave_length, 155+(get_viewport_rect().size.y*stave_number))
	stave_length += vacant_space_size+space_between_notes
	add_child(new_space)
	new_space.name="Space"+str(i)+"-"+str(j)
	new_space.add_to_group("stave_elements"+str(stave_number))
	new_space.add_to_group("vacant_spaces")
	new_space.gui_input.connect(check_add_element.bind(new_space))

func add_bar_border(i, j):
	var start_name = "Space"+str(i)+"-0"
	var end_name = "Space"+str(i)+"-"+str(j)
	var node1 = get_node(start_name)
	var node2 = get_node(end_name)
	var line = Line2D.new()
	var start = node1.position-Vector2(5,95)
	var start_size = node1.size+Vector2(0,225)
	var end = node2.position-Vector2(-15,95)
	var end_size = node2.size+Vector2(0,225)
	line.add_point(Vector2(start.x, start.y), 0)
	line.add_point(Vector2(end.x, end.y), 1)
	line.add_point(Vector2(end.x, end.y+end_size.y), 2)
	line.add_point(Vector2(start.x, start.y+start_size.y), 3)
	line.add_point(Vector2(start.x, start.y-5), 4)
	line.default_color = Color.RED
	add_child(line)
	line.name = "BarBorder"+str(i)
	line.add_to_group("stave_elements"+str(stave_number))
	line.visible = false

func position_elements():
	$Background.position.y=(50 + get_viewport_rect().size.y*stave_number)
	$"Line 1".position.y=(359 + get_viewport_rect().size.y*stave_number)
	$"Line 2".position.y=(328 + get_viewport_rect().size.y*stave_number)
	$"Line 3".position.y=(297 + get_viewport_rect().size.y*stave_number)
	$"Line 4".position.y=(266 + get_viewport_rect().size.y*stave_number)
	$"Line 5".position.y=(235 + get_viewport_rect().size.y*stave_number)
	$MeasureUpLabel.position.y=(221 + get_viewport_rect().size.y*stave_number)
	$MeasureDownLabel.position.y=(283 + get_viewport_rect().size.y*stave_number)
	$Clef.position.y=(200 + get_viewport_rect().size.y*stave_number)
	$PlayIndicator.position.y=(50 + get_viewport_rect().size.y*stave_number)

func reload_stave():
	for el in get_tree().get_nodes_in_group("stave_elements"+str(stave_number)):
		remove_child(el)
		el.queue_free()
	setup_stave(stave_number)

func check_add_element(event: InputEvent, sender):
	if event is InputEventMouseButton and event.pressed and Global.toolbox_element != null:
		_add_element_from_toolbox(sender)

func _add_element_from_toolbox(sender):
	print("Stave addelementfromtoolbox")
	var name_s = sender.name.substr(4).split("-")
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
		"HalfNote":
			new_element = Note.new(Note.Type.HALF, 14-int(sender.get_local_mouse_position().y/17))
		"QuarterNote":
			new_element = Note.new(Note.Type.QUARTER, 14-int(sender.get_local_mouse_position().y/17))
		"EightNote":
			new_element = Note.new(Note.Type.EIGHTH, 14-int(sender.get_local_mouse_position().y/17))
		"SixteenthNote":
			new_element = Note.new(Note.Type.SIXTEENTH, 14-int(sender.get_local_mouse_position().y/17))
		"ThirtysecondNote":
			new_element = Note.new(Note.Type.THIRTYSECOND, 14-int(sender.get_local_mouse_position().y/17))
		"Sharp":
			new_element = Accidental.new(Accidental.Type.SHARP, 14-int(sender.get_local_mouse_position().y/17))
		"Natural":
			new_element = Accidental.new(Accidental.Type.NATURAL, 14-int(sender.get_local_mouse_position().y/17))
		"Flat":
			new_element = Accidental.new(Accidental.Type.FLAT, 14-int(sender.get_local_mouse_position().y/17))
	if len(Melody.tracks[Global.current_viewing_track].bars) <= name_s[0].to_int():
		Melody.tracks[Global.current_viewing_track].add_bar(Bar.new())
	Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()].add_element(new_element, name_s[1].to_int())
	reload_stave()

func replace_element(el, space):
	var el_name = el.name.split("-")
	var el_bar = el_name[0].to_int()
	var el_number = el_name[1].to_int()
	var space_name = space.name.split("-")
	var space_bar = space_name[0].to_int()
	var space_number = space_name[1].to_int()
	if el_bar == space_bar:
		if el_number < space_number:
			Melody.tracks[Global.current_viewing_track].bars[space_bar].add_element(el.staffDrawable, space_number)
			Melody.tracks[Global.current_viewing_track].bars[el_bar].remove_element_at(el_number)
			reload_stave()
		else:
			Melody.tracks[Global.current_viewing_track].bars[space_bar].add_element(el.staffDrawable, space_number)
			Melody.tracks[Global.current_viewing_track].bars[el_bar].remove_element_at(el_number+1)
			reload_stave()
	else: #in different bars
		Melody.tracks[Global.current_viewing_track].bars[space_bar].add_element(el.staffDrawable, space_number)
		Melody.tracks[Global.current_viewing_track].bars[el_bar].remove_element_at(el_number)
		reload_stave()

func validate_stave():
	$/root/Main/GUI.deactivate_validation_label()
	# Validate pedals
	var pedal = null
	for bar in Melody.tracks[Global.current_viewing_track].bars:
		for element in bar._elements:
			if element is Note:
				if element.has_pedal_event():
					if pedal == null:
						pedal = element.get_pedal_event().type
					else:
						if pedal != element.get_pedal_event().type:
							pedal = element.get_pedal_event().type
						else:
							$/root/Main/GUI.activate_validation_label("Błąd: Zła konfiguracja pedałów.")
	# Validate accidentals
	var i = 0
	for bar in Melody.tracks[Global.current_viewing_track].bars:
		var nm = "BarBorder"+str(i)
		get_node(nm).visible = false
		var refer = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null]
		var j = 0
		while get_node_or_null("StaveElement"+str(i)+"-"+str(j)) != null:
			var node = get_node("StaveElement"+str(i)+"-"+str(j))
			if node.staffDrawable is Accidental:
				if refer[node.staffDrawable._position] == null:
					refer[node.staffDrawable._position] = node.staffDrawable._type
				else:
					if node.staffDrawable._type != Accidental.Type.NATURAL:
						get_node(nm).visible = true
						$/root/Main/GUI.activate_validation_label("Błąd: Źle wstawione znaki chromatyczne w takcie "+str(i))
						refer[node.staffDrawable._position] = null
					else:
						refer[node.staffDrawable._position] = node.staffDrawable._type
			j+=1
		i+=1
	# Validate bars
	i = 0
	for bar in Melody.tracks[Global.current_viewing_track].bars:
		var nm = "BarBorder"+str(i)
		if !bar.is_bar_valid():
			get_node(nm).visible = true
			$/root/Main/GUI.activate_validation_label("Błąd: Źle wypełniony takt "+str(i))
		i+=1

func set_vacants_visible():
	print("Set vacants visible")
	if Global.toolbox_element not in ["Dot", "PedalOn", "PedalOff", "Dynamic"]:
		for el in get_tree().get_nodes_in_group("vacant_spaces"):
			el.visible = true
			showed = true
	else:
		hide_vacants()

func hide_vacants():
	for el in get_tree().get_nodes_in_group("vacant_spaces"):
		el.visible = false
		showed = false

func init_dnd():
	dnd = true

func clr_dnd():
	dnd = false

func start_playing():
	playing_i = 0
	playing_j = 0
	$PlayIndicator.visible = true

func reset_playing():
	$PlayIndicator.visible = false
	$PlayIndicator.position.x = 0
	playing_i = 0
	playing_j = 0

var previous: StaffDrawable = null

func move_player_to_next_note(num, pause: bool = false):
	# sprawdzam czy to nutka z tego stave'a i czy nie wyjebalo poza skale czytaj czy sie pieciolinia nie skonczyla, bo while true
	if num == stave_number and playing_i <= len(Melody.tracks[stave_number].bars):
		while true:
			#nazewnictwo: StaveElement<Bar>-<ktory element w barze>
			var xd2 = get_node_or_null("StaveElement"+str(playing_i)+"-"+str(playing_j)) # pobieram kolejny stave element
			if xd2 == null: # jezeli takiego nie ma to przelaczam na kolejny bar
				playing_j = 0
				playing_i += 1
				if playing_i > len(Melody.tracks[stave_number].bars): # jak wyjebalo poza pieciolinie to wywalam funkcje i juz do niej nie wejdzie
					return
			elif pause and xd2.staffDrawable is not Pause:
				return
			else:
				# ewentualnie sprobuj tutaj bez sprawdzania pauzy, ale i tak to wywalalo mi
				if previous is Pause and xd2.staffDrawable is Pause:
					playing_j += 1
					continue
				if xd2.staffDrawable is Note: #sprawdzam czy to nutka i nie pauza
					break
				else: # jak nie to sprawdzam next, najprawdopodobniej trafilo na accidental
					playing_j += 1
		# pobieram nute tak na powaznie
		var node = get_node("StaveElement"+str(playing_i)+"-"+str(playing_j))
		print(str(stave_number)+"   "+str(playing_i)+"-"+str(playing_j))
		# ustawiam pozycje kreski na ta nutke, potem sie wysrodkuje
		$PlayIndicator.position.x = node.position.x + node.size.x/2
		print(node.position.x)
		print(str($PlayIndicator.position.x))
		# przechodze na kolejny element
		playing_j += 1
		previous = node.staffDrawable
		if Global.current_viewing_track == stave_number:
			get_node("/root/Main/GUI").focus_camera($PlayIndicator.position.x)
