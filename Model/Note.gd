class_name Note

enum NoteType {
	WHOLE = 384,
	HALF = 192,
	QUARTER = 96,
	EIGHTH = 48,
	SIXTEENTH = 24,
}
enum ObjectType {
	NOTE = 0,
	PAUZA = 1,
}
enum Pitch {
	LOWER = -1,
	NORMAL = 0,
	UPPER = 1,
}

var _type : NoteType
var _isPause : bool
var _sound : int
var _pitch : Pitch

func _init(type :NoteType, object :ObjectType, sound :int = -1, pitch :Pitch = Pitch.NORMAL):
	self._type = type
	_isPause = (object == ObjectType.PAUZA)
	if _isPause:
		self._sound = -1  
	else:
		self._sound = clamp(sound, 0, 127) 

func note_type_to_string(note_type: NoteType) -> String:
	match note_type:
		NoteType.WHOLE:
			return "WHOLE"
		NoteType.HALF:
			return "HALF"
		NoteType.QUARTER:
			return "QUARTER"
		NoteType.EIGHTH:
			return "EIGHTH"
		NoteType.SIXTEENTH:
			return "SIXTEENTH"
		_:
			return "UNKNOWN"

func get_type()->NoteType:
	return _type
func is_pause() -> bool:
	return _isPause
func get_sound() -> int:
	return _sound
func get_pitch() -> Pitch:
	return _pitch

func _to_string() -> String:
	return "Note: type = %s, isPause = %s, sound = %d" % [note_type_to_string(_type), _isPause, _sound]
