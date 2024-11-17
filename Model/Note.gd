class_name Note extends StaffDrawable

enum Type { WHOLE = 1, HALF = 2, QUARTER = 3, EIGHTH = 4, SIXTEENTH = 5, THIRTYSECOND = 6 } # DLA MIDI 1 = 384 reszta przez podział przez 2^wartość 
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

func gas_dynamic_event() -> bool:
	return _dynamicsMetaEvent != null

func get_pedal_event() -> PedalMetaEvent:
	return _pedalMetaEvent

func get_dynamic_event() -> DynamicsMetaEvent:
	return _dynamicsMetaEvent

func _to_string() -> String:
	return "Note: type = %s, sound = %d" % [type_to_string(_type), _position]

func get_type()->Type:
	return _type

func get_value()->float:
	if(_dot):
		return 1/2**(1-_type) + 1/2**(-_type)
	else:
		return 1/2**(1-_type)

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
