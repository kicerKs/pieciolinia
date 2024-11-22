class_name MidiExport

var _header_flag = "MThd"
var _track_flag = "MTrk"
var _file : FileAccess
var _track_lenght_byte : int
var _end_of_track_position : int
var _instrument = 3

func _init(file_name: String, track: Track) -> void:
	_file = FileAccess.open(file_name, FileAccess.WRITE)
	if(FileAccess.file_exists(file_name)):
		header(track)
		write_all_notes(track.get_octave(), track.get_notes())
		footer()
		write_track_length()

func header(track: Track) -> void:
	_file.store_string(_header_flag) #nagłówek
	_file.store_32(6<<24)			#długość nagłówka w bajtach
	_file.store_16(0)				#format pliku midi
	_file.store_16(1<<8)			#ilość ścieżek w pliku
	_file.store_16((24+track.get_rate())<<8)		#długość trawnia ćwierćnuty (w tikach)
	_file.store_string(_track_flag)	#ścieżka
	_track_lenght_byte = _file.get_position()
	_file.store_32(0)				#placeholder do długości ścieżki w bajtach
	_file.store_32(0x0101FF00)		#meta-event informujący o oktawie
	_file.store_8(track.get_octave())		#oktawa
	_file.store_16(0xC000)			#instrukcja ustawienia instrumentu
	_file.store_8(track.get_instrument())	#instrument 0-127
	_file.store_32(0x0458FF00)		#nagłówek ustawienia metrum
	_file.store_8(track.get_meter_top())	#metrum pierwsza część
	_file.store_8(log(track.get_meter_bottom())/log(2))	 #metrum druga część
	_file.store_16(0x0824)
	_file.store_8(0)				#interwał przed następną instrukcją

func footer() -> void:
	_file.store_16(0x2FFF)
	_file.store_8(0)
	_end_of_track_position = _file.get_position()

func write_all_notes(octave: int, notes: Array[Note]) -> void:
	for note: Note in notes:
		if(!note.is_pause()):
			write_single_note(note, octave)
		else:
			add_pause_of(note)

func write_single_note(note: Note, octave: int) -> void:
	_file.store_8(0x90)				#instrukcja wciśnięcia nuty
	_file.store_8((note.get_sound() + note.get_pitch() + octave*12))		#dźwięk
	_file.store_8(64)				#prędkość wciśnięcia
	if(note.get_type() < 128):			#zapis długości trwania dźwięku
		_file.store_8(note.get_type())
	else:
		_file.store_16(note.get_type())
	_file.store_8(0x80)				#instrukcja puszczenia nuty
	_file.store_8((note.get_sound() + note.get_pitch() + octave*12))		#dźwięk
	_file.store_8(24)				#prędkość puszczenia
	_file.store_8(0)				#odstęp do następnej instrukcji

func add_pause_of(note: Note) -> void:
	_file.seek(_file.get_position()-1)
	if(note.get_type() < 128):			#zapis długości trwania dźwięku
		_file.store_8(note.get_type())
	else:
		_file.store_16(note.get_type())

func write_track_length() -> void:
	_file.seek(_track_lenght_byte)
	var length = _end_of_track_position-_track_lenght_byte-4
	if length<128:
		_file.store_32(length << 24)
	elif length<65536:
		var first_half = (length >> 8)
		var second_half = length - (first_half<<8)
		_file.store_16(0)
		_file.store_8(first_half)
		_file.store_8(second_half)
	else:
		_file.store_32(length << 8)
