class_name Note extends StaffDrawable

# DLA MIDI 1 = 384 reszta przez podział przez 2^wartość 
enum Type { 
  WHOLE = 1, 
  HALF = 2, 
  QUARTER = 3, 
  EIGHTH = 4, 
  SIXTEENTH = 5, 
  THIRTYSECOND = 6,
  NONE = 0,
} 
var _type: Type
var _dot: bool
var _pedalMetaEvent: PedalMetaEvent
var _dynamicsMetaEvent: DynamicsMetaEvent

func _init(type :Type, position :int = 0, hasDot: bool = false):
	self._type = type
	self._position = clamp(position, 0, 15) 
	self._dot = hasDot


func add_pedal_event(pedalEvent: PedalMetaEvent):
	_pedalMetaEvent = pedalEvent

func add_dynamic_event(dynamicEvent: DynamicsMetaEvent):
	_dynamicsMetaEvent = dynamicEvent

func has_pedal_event() -> bool:
	return _pedalMetaEvent != null

func has_dynamic_event() -> bool:
	return _dynamicsMetaEvent != null

func remove_pedal_event():
	_pedalMetaEvent = null

func remove_dynamic_event():
	_dynamicsMetaEvent = null

func set_type_and_dot(value: int, dot: bool):
	self._type = type_from_int(value)
	self._dot = dot

func get_pedal_event() -> PedalMetaEvent:
	return _pedalMetaEvent

func get_dynamic_event() -> DynamicsMetaEvent:
	return _dynamicsMetaEvent

func _to_string() -> String:
	var pedal: String = "none"
	if(_pedalMetaEvent!=null): 
		pedal = str(_pedalMetaEvent.type)
	return "Note: type = %s, sound = %d, pedal = %s" % [type_to_string(_type), _position, pedal]

func get_type()->Type:
	return _type

func get_value()->float:
	if(_dot):
		return (2.0**(1-_type)) + (2.0**(-_type))
	else:
		return 2.0**(1-_type)

func is_pause() -> bool:
	return false

func type_to_string(note_type: Type) -> String:
	match note_type:
		Type.WHOLE:
			return "WHOLE"
		Type.HALF:
			return "HALF"
		Type.QUARTER:
			return "QUARTER"
		Type.EIGHTH:
			return "EIGHTH"
		Type.SIXTEENTH:
			return "SIXTEENTH"
		Type.THIRTYSECOND:
			return "THIRTYSECOND"
		_:
			return "UNKNOWN"

func type_from_int(value: int) -> Type:
	match value:
		1:
			return Type.WHOLE
		2:
			return Type.HALF
		3:
			return Type.QUARTER
		4:
			return Type.EIGHTH
		5:
			return Type.SIXTEENTH
		6:
			return Type.THIRTYSECOND
		_:
			return Type.QUARTER
