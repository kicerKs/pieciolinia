class_name Pause extends Note

func _init(type :Type, hasDot: bool = false):
	self._type = type
	self._position = 6 #zawsze środek
	self._dot = hasDot
		

func _to_string() -> String:
	return "Pause: type = %s" % [type_to_string(_type)]

func is_pause() -> bool:
	return true
