class_name Bar

var fulfillment: float
var _elements: Array[StaffDrawable]

func get_elements() -> Array[StaffDrawable]:
	return _elements

func is_full() -> bool:
	return fulfillment == Melody.get_max_bar_value()

func is_empty() -> bool:
	return fulfillment == 0.0

func add_element(element: StaffDrawable) -> bool:
	if(element is Accidental):
		_elements.append(element)
		return true
	
	#print(str(fulfillment)+" "+ str(element.get_value())+" "+str(Melody.get_max_bar_value()))
	
	if(fulfillment + element.get_value() > Melody.get_max_bar_value()):
		return false
	
	fulfillment += element.get_value()
	_elements.append(element)
	return true

func remove_element_at(index: int) -> bool:
	if(index < 0 or index >= _elements.size()):
		return false
	
	_elements.remove_at(index)
	return true

func _to_string() -> String:
	return "Bar: fulfullment = %d, elements cound = %d" % [fulfillment, _elements.size()]
