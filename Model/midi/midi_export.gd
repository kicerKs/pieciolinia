class_name NewMidiExport extends Node

var _header_flag = "MThd" # nagłówek MIDI
var _track_flag = "MTrk" # ścieżka MIDI
var _file : FileAccess 
var _track_lenght_byte : int # pozycja długości ścieżki w pliku
var _end_of_track_position : int 
var _instrument = 3 # domyślny instrument
var _quarter_note_length: int = 96 # domyslna dlugosc cwiercnuty

func save_file(file_name: String, track: Track):
	_file = FileAccess.open(file_name, FileAccess.WRITE)
	if(FileAccess.file_exists(file_name)):
		header(track)
		write_all_notes(track.get_octave(), track.get_notes())  # zapis nut
		footer()
		write_track_length()  # długośc ścieżki

func header(track: Track) -> void:
	_file.store_string(_header_flag) # nagłówek
	_file.store_32(6<<24)          # długość nagłówka w bajtach
	_file.store_16(1)                # format pliku MIDI
	_file.store_16(1<<8)           # liczba ścieżek w pliku
	_file.store_16(_quarter_note_length << 8)  # długość trwania ćwierćnuty (w tikach)
	_file.store_string(_track_flag)  # ścieżka
	_track_lenght_byte = _file.get_position()
	_file.store_32(0)                # placeholder długości ścieżki w bajtach
	_file.store_8(0)                 # interwal do pierwszej instrukcji

func write_all_notes(octave: int, notes: Array[Note]) -> void: # zapis wszystkich nut w sciezce
	for note in notes:
		if !note.is_pause():
			write_single_note(note, octave)
		else:
			add_pause_of(note)

func write_single_note(note: Note, octave: int) -> void: # zapis pojedynczej nuty
	var sound = note.get_sound() + note.get_pitch() + octave * 12
	_file.store_8(0x90)  # wciśnięcie nuty
	_file.store_8(sound)  # dzwiek
	_file.store_8(64)  # tempo/dynamika
	write_variable_length(note.get_length())  # dlugosc nuty
	_file.store_8(0x80)  # puszczenie nuty
	_file.store_8(sound)  # dzwięk
	_file.store_8(64)  # predkosc odtworzenia

func write_variable_length(value: int) -> void:
	if value < 128:
		_file.store_8(value)
	else:
		var bytes = []
		while value > 0:
			bytes.append(value & 0x7F)
			value >>= 7
		for i in range(bytes.size()):
			_file.store_8(bytes[bytes.size() - i - 1] | (0x80 if i > 0 else 0))
			
func add_pause_of(note: Note) -> void:
	write_variable_length(note.get_length()) # dlugosc pauzy zalezy od tikow (zalezy od division) moze miec np. 96 / 120 / 480 tikow itd.
 	
func write_meta_event(type: int, data: Array) -> void:
	_file.store_8(0xFF)  # id meta-eventu
	_file.store_8(type)  # typ meta-eventu
	_file.store_8(data.size())  # dlugosc danych
	for byte in data:
		_file.store_8(byte)  # meta-event
		
func footer() -> void:
	write_meta_event(0x2F, [])  # koniec ścieżki
	_end_of_track_position = _file.get_position()
	
func write_track_length() -> void:
	_file.seek(_track_lenght_byte)
	var length = _end_of_track_position - _track_lenght_byte - 4
	write_variable_length(length)
