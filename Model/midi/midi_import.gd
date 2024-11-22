class_name  MidiImport

var _file: FileAccess
var _track: Track

func _init(file_name: String):
	_track = Track.new(0,0,0,0,0, [])
	if(is_file_correct(file_name)):
		_file = FileAccess.open(file_name, FileAccess.READ)
		read_configs()
		read_notes()
	else:
		inform_about_file_error()

func get_track() -> Track:
	return _track

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

func inform_about_file_error():
	pass

func read_configs():
	move_in_file(13)
	_track.set_rate(_file.get_8() - 24)
	move_in_file(12)
	_track.set_octave(_file.get_8())
	move_in_file(2)
	_track.set_instrument(_file.get_8())
	move_in_file(4)
	_track.set_meter(_file.get_8(), 2 ** _file.get_8())
	move_in_file(2)


func move_in_file(step: int):
	_file.seek(_file.get_position()+step)

func read_notes():
	var notes: Array[Note] = []
	var pause = 0
	var byte = 0
	var pitch = Note.Pitch.NORMAL
	
	while(byte != 0xFF):
		pause = _file.get_8()
		if(pause > 0):
			notes.append(Note.new(pause, Note.ObjectType.PAUSE))
			
		byte = _file.get_8()
		if(byte == 0x90):
			byte = _file.get_8() - _track.get_octave()*12
			pitch = check_pitch(byte)
			_file.get_8()
			notes.append(Note.new(_file.get_8(), Note.ObjectType.NOTE, byte, pitch))
			move_in_file(3)
	_track.set_notes(notes)
	
func check_pitch(note :int) -> Note.Pitch:
	var upper_pitch = [1,3,6,8,10,13,15,18,20,22]
	if(upper_pitch.find(note) >= 0):
		return Note.Pitch.UPPER
	return Note.Pitch.NORMAL
