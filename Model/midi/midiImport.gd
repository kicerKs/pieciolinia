class_name  MidiImport

var _file: FileAccess
var _track: Track

func _init(fileName: String):
	_track = Track.new(0,0,0,0,0, [])
	if(isFileCorrect(fileName)):
		_file = FileAccess.open(fileName, FileAccess.READ)
		readConfigs()
		readNotes()
	else:
		informAboutFileError()

func getTrack() -> Track:
	return _track

func isFileCorrect(fileName: String) -> bool:
	if(!FileAccess.file_exists(fileName)):
		return false
	_file = FileAccess.open(fileName, FileAccess.READ)
	_file.seek_end(0)
	if(_file.get_position()<26):
		return false
	_file.seek(0)
	if(_file.get_buffer(4).get_string_from_ascii() != "MThd"):
		return false
	_file.seek(0)
	_file.close()
	return true

func informAboutFileError():
	pass

func readConfigs():
	moveInFile(13)
	_track.setRate(_file.get_8() - 24)
	moveInFile(12)
	_track.setOctave(_file.get_8())
	moveInFile(2)
	_track.setInstrument(_file.get_8())
	moveInFile(4)
	_track.setMeter(_file.get_8(), 2 ** _file.get_8())
	moveInFile(2)


func moveInFile(step: int):
	_file.seek(_file.get_position()+step)

func readNotes():
	var notes: Array[Note] = []
	var pause = 0
	var byte = 0
	var pitch = Note.Pitch.NORMAL
	
	while(byte != 0xFF):
		pause = _file.get_8()
		if(pause > 0):
			notes.append(Note.new(pause, Note.ObjectType.PAUZA))
			
		byte = _file.get_8()
		if(byte == 0x90):
			byte = _file.get_8() - _track.getOctave()*12
			pitch = checkPitch(byte)
			_file.get_8()
			notes.append(Note.new(_file.get_8(), Note.ObjectType.NOTE, byte, pitch))
			moveInFile(3)
	_track.setNotes(notes)
	
func checkPitch(note :int) -> Note.Pitch:
	var upperPitch = [1,3,6,8,10,13,15,18,20,22]
	if(upperPitch.find(note) >= 0):
		return Note.Pitch.UPPER
	return Note.Pitch.NORMAL
