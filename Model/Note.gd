class_name Note

enum NoteType { WHOLE = 384, HALF = 192, QUARTER = 96, EIGHTH = 48, SIXTEENTH = 24 }
enum ObjectType { NOTE = 0, PAUZA = 1 }

var _type  : NoteType
var _isPause : bool
var _sound : int

func _init(type :NoteType, object :ObjectType, sound :int = -1):
	self._type = type
	#_isPause = object > 0
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
			
func _to_string() -> String:
	return "Note: type = %s, isPause = %s, sound = %d" % [note_type_to_string(_type), _isPause, _sound]

func getType()->NoteType:
	return _type
func isPause() -> bool:
	return _isPause
func getSound() -> int:
	return _sound
