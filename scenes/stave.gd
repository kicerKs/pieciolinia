extends Node2D

var note_size = 75
var accidental_size = 25
var space_between_notes = 10

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
var is_pitched = {0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false, 8: false, 9: false, 10: false, 11: false, 12: false, 13: false, 14: false, 15: false, 16: false, 17: false, 18: false, 19: false, 20: false, 21: false, 22: false, 23: false}
var notes_positions = {0: 282, 2: 266, 4: 251, 5: 235, 7: 219, 9: 204, 11: 188, 12: 173, 14: 157, 16: 142, 17: 126, 19: 111, 21: 95, 23: 80}
var pitched_notes_positions = {1: 282, 3: 266, 6: 235, 8: 219, 10: 204,  13: 173, 15: 157, 18: 126, 20: 111, 22: 95}
var new_notes_positions = {0: 282, 1: 282, 2: 266, 3: 266, 4: 251, 5: 235, 6: 235, 7: 219, 8: 219, 9: 204, 10: 204, 11: 188, 12: 173, 13: 173, 14: 157, 15: 157, 16: 142, 17: 126, 18: 126, 19: 111, 20: 111, 21: 95, 22: 95, 23: 80}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var measure_up = 4
	var measure_down = 4
	$MeasureDownLabel.text = str(measure_down)
	$MeasureUpLabel.text = str(measure_up)
	Global.stave_unit = note_size + accidental_size + space_between_notes

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_setup_stave():
	$MeasureDownLabel.text = str(Melody.meter_bottom)
	$MeasureUpLabel.text = str(Melody.meter_top)
	var length = 150
	print("Setting up the stave")
	var i = 1
	for bar in Melody.tracks[0].get_bars():
		print(bar)
		var j = 1
		for el in bar.get_elements():
			var new_element = Sprite2D.new()
			print("I got: "+str(el))
			if el is Pause:
				print("Making pause")
				match el.get_type():
					Note.Type.WHOLE:
						new_element.texture = load("res://assets/rests/whole_rest.png")
					Note.Type.HALF:
						new_element.texture = load("res://assets/rests/half_rest.png")
					Note.Type.QUARTER:
						new_element.texture = load("res://assets/rests/quarter_rest.png")
					Note.Type.EIGHTH:
						new_element.texture = load("res://assets/rests/eight_rest.png")
					Note.Type.SIXTEENTH:
						new_element.texture = load("res://assets/rests/sixteenth_rest.png")
					_:
						new_element.texture = load("res://assets/rests/whole_rest.png")
						print("ERROR")
				new_element.position = Vector2i(length,new_notes_positions[el.get_position()])
				new_element.centered = false
				new_element.name = "Pause"+str(i)+"/"+str(j)
				add_child(new_element)
				length += note_size
			elif el is Note:
				print("Making note")
				match el.get_type():
					Note.Type.WHOLE:
						new_element.texture = load("res://assets/notes/whole_note.png")
					Note.Type.HALF:
						new_element.texture = load("res://assets/notes/half_note.png")
					Note.Type.QUARTER:
						new_element.texture = load("res://assets/notes/quarter_note.png")
					Note.Type.EIGHTH:
						new_element.texture = load("res://assets/notes/eight_note.png")
					Note.Type.SIXTEENTH:
						new_element.texture = load("res://assets/notes/sixteenth_note.png")
					_:
						new_element.texture = load("res://assets/notes/whole_note.png")
						print("ERROR")
				new_element.position = Vector2i(length,new_notes_positions[el.get_position()])
				new_element.centered = false
				new_element.name = "Note"+str(i)+"/"+str(j)
				add_child(new_element)
				length += note_size
			elif el is Accidental:
				match el.get_type():
					Accidental.Type.FLAT:
						new_element.texture = load("res://assets/accidentals/flat.png")
					Accidental.Type.SHARP:
						new_element.texture = load("res://assets/accidentals/sharp.png")
					Accidental.Type.NATURAL:
						new_element.texture = load("res://assets/accidentals/natural.png")
				new_element.position = Vector2i(length,new_notes_positions[el.get_position()])
				new_element.centered = false
				new_element.name = "Accidental"+str(i)+"/"+str(j)
				add_child(new_element)
				length += accidental_size
			length += space_between_notes
		length += 10
		var new_barline = ColorRect.new()
		new_barline.size = Vector2(1, 125)
		new_barline.color = Color(0,0,0,1)
		new_barline.position = Vector2(length, 235)
		new_barline.name = "Barline"+str(i)
		add_child(new_barline)
		length += 11
	
	$Background.size.x = length
	$"Line 1".size.x = length
	$"Line 2".size.x = length
	$"Line 3".size.x = length
	$"Line 4".size.x = length
	$"Line 5".size.x = length

func setup_stave():
	$Background.size.x = Global.current_track.get_notes().size()*Global.stave_unit + 500
	$"Line 1".size.x = Global.current_track.get_notes().size()*Global.stave_unit + 500
	$"Line 2".size.x = Global.current_track.get_notes().size()*Global.stave_unit + 500
	$"Line 3".size.x = Global.current_track.get_notes().size()*Global.stave_unit + 500
	$"Line 4".size.x = Global.current_track.get_notes().size()*Global.stave_unit + 500
	$"Line 5".size.x = Global.current_track.get_notes().size()*Global.stave_unit + 500
	$MeasureDownLabel.text = str(Global.current_track.get_meter_bottom())
	$MeasureUpLabel.text = str(Global.current_track.get_meter_top())
	var i = 0 # count of notes
	var ii = 0 # count of barlines
	var iii = 0 # count of accidentals
	var barlines = 0
	var max_notes = Global.current_track.get_meter_top() * 1/float(Global.current_track.get_meter_bottom())
	var notes_between_barlines = max_notes - 2*(1/8.)
	for note in Global.current_track.get_notes():
		print(note)
		var nowa_nuta = Sprite2D.new()
		if !note.is_pause():
			match note.get_type():
				Note.Type.WHOLE:
					nowa_nuta.texture = load("res://assets/notes/whole_note.png")
					notes_between_barlines -= 1.
				Note.Type.HALF:
					nowa_nuta.texture = load("res://assets/notes/half_note.png")
					notes_between_barlines -= 1/2.
				Note.Type.QUARTER:
					nowa_nuta.texture = load("res://assets/notes/quarter_note.png")
					notes_between_barlines -= 1/4.
				Note.Type.EIGHTH:
					nowa_nuta.texture = load("res://assets/notes/eight_note.png")
					notes_between_barlines -= 1/8.
				Note.Type.SIXTEENTH:
					nowa_nuta.texture = load("res://assets/notes/sixteenth_note.png")
					notes_between_barlines -= 1/16.
				_:
					nowa_nuta.texture = load("res://assets/notes/whole_note.png")
					print("ERROR")
			if note.get_sound() in notes_positions:
				if is_pitched[note.get_sound()]:
					# Kasownik
					var nowy_accidental = Sprite2D.new()
					nowy_accidental.texture = load("res://assets/accidentals/natural.png")
					nowy_accidental.centered = false
					nowy_accidental.position = Vector2((150+ barlines - accidental_size + i*(Global.stave_unit)), notes_positions[note.get_sound()])
					nowy_accidental.name = "Accidental"+str(iii)
					add_child(nowy_accidental)
					iii+=1
				nowa_nuta.position = Vector2((150+ barlines + i*(Global.stave_unit)), notes_positions[note.get_sound()])
			else:
				# bemol, krzyzyk
				var nowy_accidental = Sprite2D.new()
				#match note.get_pitch():
					#Note.Pitch.LOWER:
						## Bemol
						#nowy_accidental.texture = load("res://assets/accidentals/flat.png")
					#Note.Pitch.UPPER:
						## Krzyzyk
						#nowy_accidental.texture = load("res://assets/accidentals/sharp.png")
					#_:
						#nowy_accidental.texture = load("res://assets/accidentals/sharp.png")
				nowy_accidental.centered = false
				nowy_accidental.position = Vector2((150+ barlines - accidental_size + i*(Global.stave_unit)), pitched_notes_positions[note.get_sound()])
				nowy_accidental.name = "Accidental"+str(iii)
				add_child(nowy_accidental)
				iii+=1
				nowa_nuta.position = Vector2((150 + barlines + i*(Global.stave_unit)), pitched_notes_positions[note.get_sound()])
				is_pitched[note.get_sound()] = true
				is_pitched[note.get_sound()-1] = true
		else:
			match note.get_type():
				Note.Type.WHOLE:
					nowa_nuta.texture = load("res://assets/rests/whole_rest.png")
					notes_between_barlines -= 1.
				Note.Type.HALF:
					nowa_nuta.texture = load("res://assets/rests/half_rest.png")
					notes_between_barlines -= 1/2.
				Note.Type.QUARTER:
					nowa_nuta.texture = load("res://assets/rests/quarter_rest.png")
					notes_between_barlines -= 1/4.
				Note.Type.EIGHTH:
					nowa_nuta.texture = load("res://assets/rests/eight_rest.png")
					notes_between_barlines -= 1/8.
				Note.Type.SIXTEENTH:
					nowa_nuta.texture = load("res://assets/rests/sixteenth_rest.png")
					notes_between_barlines -= 1/16.
				_:
					nowa_nuta.texture = load("res://assets/rests/whole_rest.png")
					print("ERROR")
			nowa_nuta.position = Vector2((150 + barlines + i*(Global.stave_unit)), 235)
		i += 1
		if notes_between_barlines <= 0:
			#spawn a new barline
			ii+=1
			barlines += 10
			var nowy_barline = ColorRect.new()
			nowy_barline.size = Vector2(1, 125)
			nowy_barline.color = Color(0,0,0,1)
			nowy_barline.position = Vector2((150 + barlines + i*(Global.stave_unit)), 235)
			nowy_barline.name = "Barline"+str(ii)
			add_child(nowy_barline)
			barlines += 11
			notes_between_barlines = max_notes
			for value in is_pitched:
				value = false
		nowa_nuta.centered = false
		nowa_nuta.name = "Note"+str(i)
		add_child(nowa_nuta)
