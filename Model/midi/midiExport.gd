class_name MidiExport

var _headerFlag = "MThd"
var _trackFlag = "MTrk"
var _file : FileAccess
var _trackLenghtByte : int
var _endOfTrackPosition : int
var _instrument = 3

func _init(filename: String, track: Track) -> void:
	_file = FileAccess.open(filename, FileAccess.WRITE)
	header(track)
	writeAllNotes(track.getOctave(), track.getNotes())
	footer()
	writeTrackLength()

func header(track: Track) -> void:
	_file.store_string(_headerFlag) #nagłówek
	_file.store_32(6<<24)			#długość nagłówka w bajtach
	_file.store_16(0)				#format pliku midi
	_file.store_16(1<<8)			#ilość ścieżek w pliku
	_file.store_16((24+track.getRate())<<8)		#długość trawnia ćwierćnuty (w tikach)
	_file.store_string(_trackFlag)	#ścieżka
	_trackLenghtByte = _file.get_position()
	_file.store_32(0)				#placeholder do długości ścieżki w bajtach
	_file.store_32(0x0101FF00)		#meta-event informujący o oktawie
	_file.store_8(track.getOctave())		#oktawa
	_file.store_16(0xC000)			#instrukcja ustawienia instrumentu
	_file.store_8(track.getInstrument())	#instrument 0-127
	_file.store_32(0x0458FF00)		#nagłówek ustawienia metrum
	_file.store_8(track.getMeterTop())	#metrum pierwsza część
	_file.store_8(log(track.getMeterBottom())/log(2))	 #metrum druga część
	_file.store_16(0x0824)
	_file.store_8(0)				#interwał przed następną instrukcją

func footer() -> void:
	_file.store_16(0x2FFF)
	_file.store_8(0)
	_endOfTrackPosition = _file.get_position()

func writeAllNotes(octave: int, notes: Array[Note]) -> void:
	for note: Note in notes:
		if(!note.isPause):
			writeSingleNote(note, octave)
		else:
			addPauseOf(note)

func writeSingleNote(note: Note, octave: int) -> void:
	_file.store_8(0x90)				#instrukcja wciśnięcia nuty
	_file.store_8((note.sound + octave*12))		#dźwięk
	_file.store_8(64)				#prędkość wciśnięcia
	if(note.type < 128):			#zapis długości trwania dźwięku
		_file.store_8(note.type)
	else:
		_file.store_16(note.type)
	_file.store_8(0x80)				#instrukcja puszczenia nuty
	_file.store_8((note.sound + octave*12))		#dźwięk
	_file.store_8(24)				#prędkość puszczenia
	_file.store_8(0)				#odstęp do następnej instrukcji

func addPauseOf(note: Note) -> void:
	_file.seek(_file.get_position()-1)
	if(note.type < 128):			#zapis długości trwania dźwięku
		_file.store_8(note.type)
	else:
		_file.store_16(note.type)

func writeTrackLength() -> void:
	_file.seek(_trackLenghtByte)
	var lenght = _endOfTrackPosition-_trackLenghtByte-4
	if lenght<128:
		_file.store_32(lenght << 24)
	elif lenght<65536:
		var firstHalf = (lenght >> 8)
		var secondHalf = lenght - (firstHalf<<8)
		_file.store_16(0)
		_file.store_8(firstHalf)
		_file.store_8(secondHalf)
	else:
		_file.store_32(lenght << 8)
