class_name Bar

var maxValue: float #to powinno być zaciagane z globalnych zmiennych
var fulfillment: float
var _elements: Array[StaffDrawable]

func get_elements() -> Array[StaffDrawable]:
	return _elements

func is_full() -> bool:
	return fulfillment == maxValue

func is_empty() -> bool:
	return fulfillment == 0.0

func add_element(element: StaffDrawable) -> bool:
	if(element is Accidental):
		_elements.append(element)
		return true
	
	if(fulfillment + element.get_value() > maxValue):
		return false
	
	fulfillment += element.get_value()
	_elements.append(element)
	return true

func remove_element_at(index: int) -> bool:
	if(index < 0 or index >= _elements.size()):
		return false
	
	_elements.remove_at(index)
	return true
