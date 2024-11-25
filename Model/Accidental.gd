class_name Accidental extends StaffDrawable

enum Type{ 
	FLAT = -1,
	NATURAL = 0,
	SHARP = 1, 
}

var _type: Type

func _init(type: Type, position: int):
	self._position = clamp(position, 0, 15)
	self._type = type

func type_to_string(note_type: Type) -> String:
	match note_type:
		Type.FLAT:
			return "FLAT"
		Type.NATURAL:
			return "NATURAL"
		Type.SHARP:
			return "SHARP"
		_:
			return "UNKNOWN"

func _to_string() -> String:
	return "Accidental: type = %s, position = %s" % [type_to_string(_type), _position]

func get_type()->Type:
	return _type
