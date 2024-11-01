class_name Note

enum NoteType { WHOLE = 384, HALF = 192, QUARTER = 96, EIGHTH = 48, SIXTEENTH = 24 }
enum ObjectType { NOTE = 0, REST = 1 }

var _type  : NoteType
var _isPause : bool
var _sound : int

func _init(type :NoteType, object :ObjectType, sound :int = -1):
	self._type = type
	_isPause = object > 0
	self._sound = sound

func _to_string() -> String:
	return "Note: type = %s, isPause = %s, sound = %d" % [_type, _isPause, _sound]

func getType()->NoteType:
	return _type
func isPause() -> bool:
	return _isPause
func getSound() -> int:
	return _sound
