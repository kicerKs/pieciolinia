class_name Note

enum NoteType { WHOLE = 384, HALF = 192, QUARTER = 96, EIGHTH = 48, SIXTEENTH = 24 }
enum ObjectType { NOTE = 0, PAUZA = 1 }
enum Pitch {LOWER = -1, NORMAL = 0, UPPER = 1}

var _type : NoteType
var _isPause : bool
var _sound : int
var _pitch : Pitch

func _init(type :NoteType, object :ObjectType, sound :int = -1, pitch :Pitch = Pitch.NORMAL):
	self._type = type
	_isPause = (object == ObjectType.PAUZA)
	self._sound = clamp(sound, 0, 127) 
	self._pitch = clamp(pitch, -1, 1)

func _to_string() -> String:
	return "Note: type = %s, isPause = %s, sound = %d, pitch" % [_type, _isPause, _sound, _pitch]

func getType()->NoteType:
	return _type
func isPause() -> bool:
	return _isPause
func getSound() -> int:
	return _sound
func getPitch() -> Pitch:
	return _pitch
