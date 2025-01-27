class_name NewMidiImport extends Node

var _file: FileAccess
var _track_number: int = 1
var _quarter_note_length: int = 96
var _key_type = 1
var _dynamics = -1
var _pedal_bufor: PedalMetaEvent = null
var _accidental_bufor: Accidental = null
var _flat_indicator: bool = false
var _accidentals_table_pos: Array[int] = []
var _accidentals_table_val: Array[Accidental] = []
var new_track: Track

var our_file = false

func load_file(file_name: String, parent: Node) -> bool:
	assert(parent.has_method("continue_loading"),"parent for midi_import load doesn't implement continue_loading method")
	if(is_file_correct(file_name)):
		_file = FileAccess.open(file_name, FileAccess.READ)
		Melody.clear()
		read_header()
		read_file_body()
		
		if(!our_file):
			if !(await parent.continue_loading()):
				Melody.clear()
		Global.reset()
		Global.max_track = len(Melody.tracks)-1 if len(Melody.tracks)>0 else 0
		return true
	return false

func read_file_body():
	for x in range(_track_number):
		new_track = Track.new()
		read_into_track(new_track)
		Melody.add_track(new_track)	

func is_file_correct(file_name: String) -> bool:
	if(!FileAccess.file_exists(file_name)):
		return false
	_file = FileAccess.open(file_name, FileAccess.READ)
	_file.seek_end(0)
	if(_file.get_position()<26):
		return false
	_file.seek(0)
	if(_file.get_buffer(4).get_string_from_ascii() != "MThd"):
		return false
	_file.seek(0)
	_file.close()
	return true

func read_header():
	move_in_file(_file, 8) #skip header signature MThd and header size (always 6)
	_file.get_16() #getting format (at this point we only use multi tracks or single track, multi-channel tracks need to be done, so the sequentially tracks)
	_track_number = get_16_MSB(_file) #get track number
	_quarter_note_length = get_16_MSB(_file)

func read_into_track(track: Track):
	move_in_file(_file, 9) #skip track signature MTrk, track size
	var notEnd = true
	while(notEnd):
		notEnd = read_event_for_track(get_8_MSB(_file), track)
	if(track.bars[-1]._elements.size() == 0):
		track.bars.remove_at(track.bars.size()-1)

func read_event_for_track(event_header: int, track: Track) -> bool:
	var first_half = event_header >> 4
	var second_half = event_header - (first_half << 4)
	match [first_half, second_half]:
		[0xF, 0xF]:
			return perform_event(track)
		[0x9, _]:
			if(track.get_bars().size() == 0 || track.get_bars()[-1].is_full()):
				track.add_bar(Bar.new())
				_accidentals_table_pos.clear()
				_accidentals_table_val.clear()
			var note = read_note_on(track)
			if(_accidental_bufor != null):
				track.get_bars()[-1].add_element(_accidental_bufor)
				_accidentals_table_pos.append(_accidental_bufor.get_position())
				_accidentals_table_val.append(_accidental_bufor)
				_accidental_bufor = null
			track.get_bars()[-1].add_element(note)					#TODO: wywalić błąd jeżeli coś nie gra
		[0x8, _]:
			if(track.get_bars().size() == 0 || track.get_bars()[-1].is_full()):
				track.add_bar(Bar.new())
				_accidentals_table_pos.clear()
				_accidentals_table_val.clear()
			read_pause_into(track)
		[0xB, _]:
			check_controler_change()
		[0xC, _]:
			read_instrument(track)
	return true

func check_controler_change():
	var controler_number = get_8_MSB(_file)
	var new_value = get_8_MSB(_file)
	match controler_number:
		64:
			if(new_value < 64):
				_pedal_bufor = PedalMetaEvent.new(PedalMetaEvent.Type.RELEASE)
			else:
				_pedal_bufor = PedalMetaEvent.new(PedalMetaEvent.Type.PUSH)
	move_in_file(_file, 1)

func read_instrument(track: Track):
	track.set_instrument(get_8_MSB(_file))
	move_in_file(_file, 1)

func perform_event(track: Track) -> bool:
	var type = get_8_MSB(_file)
	match type:
		0x00:
			move_in_file(_file, 3) #event for sequentially tracks 
		0x01:
			var text = ""
			for i in range(get_8_MSB(_file)):
				text += String.chr(get_8_MSB(_file))
			if(text == "io%p3"):
				our_file = true
		0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x7F: #text values,  #zrobić zakres od 01 do 0F, also nie wiem czy ilość liter ma się kończyć na 255 czy może być przerzucona na 2 bajty
			move_in_file(_file, get_8_MSB(_file)) #irrelevant in import
		0x20:
			pass #at this point not supported - multi-channel format instruction
		0x2F:
			move_in_file(_file, 1)
			return false
		0x51:
			read_tempo()
		0x54:
			move_in_file(_file, get_8_MSB(_file)) # not supported. Used in SMPTE, we don't use SMPTE clock
		0x58:
			read_meter()
		0x59:
			read_key_signature(track)
	var delta_time = read_midi_length(_file) #potencjalnie może zacząć się od pauzy, tego jeszcze nie zaprogramowałem
	return true

func read_tempo():
	var rate = get_32_MSB(_file) & ~ (0xFF<<24)
	Melody.rate = (125 - rate/10000)

func read_meter():
	move_in_file(_file, 1)
	Melody.meter_top = get_8_MSB(_file)
	Melody.meter_bottom = 2**get_8_MSB(_file)
	move_in_file(_file, 2) #irrelevant in import

func read_key_signature(track: Track):
	track.keySignature = get_8_MSB(_file)
	move_in_file(_file, 1) #scale, mirrors each other, not significant here

func read_note_on(track: Track) -> Note:
	var new_note = Note.new(Note.Type.NONE, 0, false)
	var sound = get_8_MSB(_file)
	var dynamics = get_8_MSB(_file)
	if(sound < 59):
		track.set_key_type(0)
	new_note.set_position(translate_sound_to_position(sound))
	if(_dynamics == -1 or _dynamics != dynamics):
		new_note.add_dynamic_event(DynamicsMetaEvent.create_from_int(dynamics))
		_dynamics = dynamics
	if(_pedal_bufor != null):
		new_note.add_pedal_event(_pedal_bufor)
		_pedal_bufor = null
	var length = read_midi_length(_file)
	
	var dot = has_dot(length)
	var type_int = get_note_type_from_lenght(length)
	new_note.set_type_and_dot(type_int, dot)
	
	return new_note

func translate_sound_to_position(sound: int) -> int:
	var positions = [0,0,1,1,2,3,3,4,4,5,5,6,7,7,8,8,9,9,10,11,11,12,12,13,13,14]
	if([1,3,6,8,10,13,14,18,20,22].find(sound%12) >= 0):
		var acc_pos = _accidentals_table_pos.find(positions[ (sound + 12) % 24]+1) if(_flat_indicator) else _accidentals_table_pos.find(positions[ (sound + 12) % 24])
		if(_flat_indicator and (acc_pos<0 or (acc_pos >= 0 and _accidentals_table_val[acc_pos]._type != Accidental.Type.FLAT)) ):
			_accidental_bufor = Accidental.new(Accidental.Type.FLAT, positions[ (sound + 12) % 24]+1)
		elif(!_flat_indicator and (acc_pos<0 or (acc_pos >= 0 and _accidentals_table_val[acc_pos]._type != Accidental.Type.SHARP)) ):
			_accidental_bufor = Accidental.new(Accidental.Type.SHARP, positions[ (sound + 12) % 24])
	elif(_accidentals_table_pos.find(positions[ (sound + 12) % 24]) >= 0):
		_accidentals_table_pos.remove_at(_accidentals_table_pos.find(positions[ (sound + 12) % 24]))
		_accidentals_table_val.remove_at(_accidentals_table_pos.find(positions[ (sound + 12) % 24]))
		_accidental_bufor = Accidental.new(Accidental.Type.NATURAL, positions[ (sound + 12) % 24])
	else:
		_accidental_bufor = null
	
	if(_flat_indicator):
		return positions[ (sound + 12) % 24]+1
	else:
		return positions[ (sound + 12) % 24]

func read_midi_length(file: FileAccess) -> int:
	var first_byte = file.get_8()
	var result = 0
	if( (first_byte >> 7) == 1):
		var second_byte = file.get_8()
		result = ((first_byte-(1<<7)) << 7) + second_byte
	else:
		result = first_byte
	if(result%2 == 1):
		_flat_indicator = true
		result -= 1
	else:
		_flat_indicator = false
	return result

func has_dot(length: int) -> bool:
	for i in range(Note.Type.size()-1):
		if((float(length)/float(_quarter_note_length*4)) == 0.5**i):
			return false
	return true

func get_note_type_from_lenght(length: int) -> int:
	if(has_dot(length)):
		length -= length/3
	return log((float(length)/float(_quarter_note_length*4)))/log(0.5) + 1

func read_pause_into(track: Track):
	move_in_file(_file, 2)
	var length = read_midi_length(_file)
	if(length == 0):
		return 
	
	while(length > 0):
		if(float(length)/float(_quarter_note_length*4) > track.get_bars()[-1].space_left()):
			length -= (track.get_bars()[-1].space_left()*(_quarter_note_length*4))
			track.get_bars()[-1].add_element(create_pause_from_length(track.get_bars()[-1].space_left()*_quarter_note_length*4))
			track.add_bar(Bar.new())
		else:
			track.get_bars()[-1].add_element(create_pause_from_length(length))
			length = 0
	

func create_pause_from_length(length: int) -> Pause:
	var dot = has_dot(length)
	var type_int = get_note_type_from_lenght(length)
	var new_pause = Pause.new()
	if(_pedal_bufor != null):
		new_pause.add_pedal_event(_pedal_bufor)
		_pedal_bufor = null
	new_pause.set_type_and_dot(type_int, dot)
	
	return new_pause

func move_in_file(file: FileAccess, bytesNumber: int):
	file.seek(file.get_position()+bytesNumber)

func get_64_MSB(file: FileAccess) -> int:
	var result = 0
	result += file.get_8() << 56
	result += file.get_8() << 48
	result += file.get_8() << 40
	result += file.get_8() << 32
	result += file.get_8() << 24
	result += file.get_8() << 16
	result += file.get_8() << 8
	result += file.get_8()
	return result

func get_32_MSB(file: FileAccess) -> int:
	var result = 0
	result += file.get_8() << 24
	result += file.get_8() << 16
	result += file.get_8() << 8
	result += file.get_8()
	return result

func get_16_MSB(file: FileAccess) -> int:
	var result = 0
	result += file.get_8() << 8
	result += file.get_8()
	return result

func get_8_MSB(file: FileAccess) -> int:
	return file.get_8()
