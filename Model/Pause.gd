class_name Pause extends Note

func _init():
	self._type = Type.QUARTER
	self._position = 3 #zawsze środek
	self._dot = false

func _to_string() -> String:
	return "Pause: type = %s" % [type_to_string(_type)]

func is_pause() -> bool:
	return true
