class_name NewMidiExport extends Node

var _file: FileAccess 
var _dynamics: int
var _pause_present: bool
var _quarter_note_length: int = 96 # default quarter note length

func save_file(file_name: String):
	_file = FileAccess.open(file_name, FileAccess.WRITE)
	if(FileAccess.file_exists(file_name)):
		header()
		for track in Melody.tracks:
			_pause_present = true
			write_track(track)
	_file.close()

func header() -> void:
	_file.store_string("MThd")					# header label
	store_32_MSB(_file, 6)						# header length
	store_16_MSB(_file, 1)                		# one of midi formats ( 1 = one or more symultaniously playing tracks)
	store_16_MSB(_file, Melody.tracks.size())	# number od tracks in file
	store_16_MSB(_file, _quarter_note_length)	# quarter note length (in ticks)

func write_track(track: Track):
	_file.store_string("MTrk")												# Track label
	var track_length_byte = _file.get_position()							# position of length 64 bits
	_file.store_32(0)                										# track length placeholder
	_file.store_8(0)                										# first delta time
	write_instrument_change(track.get_instrument())							# instrument change
	write_meta_event(0x58, [Melody.meter_top, meter_bottom_log(), 0x24, 8])	# Meter meta-event
	write_meta_event(0x51, [(Melody.rate + 15) * 10000]) 					# rate meta-event
	
	var key = track.get_key_type()
	for bar in track.get_bars():
		write_bar_in_key(bar, key)
	footer()
	write_track_length(track_length_byte, _file.get_position())

func meter_bottom_log() -> int:
	return log(Melody.meter_bottom)/log(2)

func footer() -> void:
	write_meta_event(0x2F, [])  # koniec ścieżki

func write_track_length(start: int, end: int):
	_file.seek(start)
	store_32_MSB(_file, end - start - 4)
	_file.seek_end()

func write_meta_event(type: int, data: Array) -> void:
	_file.store_8(0xFF)  # meta-event id 
	_file.store_8(type)  # meta-event type
	if(type != 0x51):
		_file.store_8(data.size())  # data length
		for byte in data:
			_file.store_8(byte)  # meta-event
	else:
		store_32_MSB(_file, (3<<24) | data[0])
	_file.store_8(0)

func write_instrument_change(instrument: Instruments.Instrument):
	store_8_MSB(_file, 0xC0)  # instruction id
	store_8_MSB(_file, instrument) # instruction id
	store_8_MSB(_file, 0) # delta time

func write_controle_change(controler: int, value: int):
	store_8_MSB(_file, 0xB0) # instruction id
	store_8_MSB(_file, controler) # controler number id
	store_8_MSB(_file, value) # new controler value
	store_8_MSB(_file, 0) # delta time

func write_bar_in_key(bar: Bar, key: Track.KeyType):
	var _accidental_dict = {}
	for element in bar.get_elements():
		if(element is Pause): 
			write_pause(element)
		elif(element is Note):
			var accidental = null if(_accidental_dict.keys().find(element.get_position()) < 0) else _accidental_dict[element.get_position()]
			write_note(element, key, accidental)
		elif(element is Accidental):
			_accidental_dict[element.get_position()] = element as Accidental

func write_pause(pause: Pause):
	if(_pause_present):
		store_8_MSB(_file, 0x80)
		store_8_MSB(_file, 0)
		store_8_MSB(_file, 0)
		write_to_file_midi_delta_time(_file, pause.get_value() * 4 * _quarter_note_length)
	else:
		move_back_in_file(_file, 1)
		write_to_file_midi_delta_time(_file, pause.get_value() * 4 * _quarter_note_length)
	_pause_present = true
	

func write_note(note: Note, key: Track.KeyType, accidental: Accidental):
	var sounds = [0,2,4,5,7,9,11,12,14,16,17,19,21,23]
	var sound = sounds[note.get_position()] + 36 + 24 * key;
	sound += 0 if(accidental == null) else accidental.get_type()
	_dynamics = _dynamics if(note.get_dynamic_event() == null) else note.get_dynamic_event().type
	if(note.get_pedal_event() != null):
		write_pedal_event(note.get_pedal_event())
	
	store_8_MSB(_file, 0x90)
	store_8_MSB(_file, sound)
	store_8_MSB(_file, _dynamics)
	write_to_file_midi_delta_time(_file, note.get_value() * 4 * _quarter_note_length)
	store_8_MSB(_file, 0x80)
	store_8_MSB(_file, sound)
	store_8_MSB(_file, 64)
	store_8_MSB(_file, 0) #brak pauzy domyślnie
	_pause_present = false

func write_pedal_event(pedalEvent: PedalMetaEvent):
	write_controle_change(0x40, 127*pedalEvent.type)

static func write_to_file_midi_delta_time(file: FileAccess, value: int):
	if(value < 128):
		store_8_MSB(file, value)
	else:
		store_8_MSB(file, 0x80 | (value >> 7))
		store_8_MSB(file, value & 0x7F)

static func move_back_in_file(_file: FileAccess, bytes: int):
	_file.seek_end(-bytes)

static func store_32_MSB(file: FileAccess, data: int):
	file.store_8(data >> 24)
	file.store_8((data >> 16) & ~0xFF00)
	file.store_8((data >> 8) & ~0xFFFF00)
	file.store_8(data & ~0xFFFFFF00)

static func store_16_MSB(file: FileAccess, data: int):
	file.store_8(data >> 8)
	file.store_8(data & ~0xFF00)

static func store_8_MSB(file: FileAccess, data: int):
	file.store_8(data)