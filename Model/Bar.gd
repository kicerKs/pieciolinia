class_name Bar

var fulfillment: float
var _elements: Array[StaffDrawable]

func get_elements() -> Array[StaffDrawable]:
	return _elements

func space_left() -> float:
	return Melody.get_max_bar_value() - fulfillment

func is_full() -> bool:
	return fulfillment == Melody.get_max_bar_value()

func is_empty() -> bool:
	return fulfillment == 0.0

func add_element(element: StaffDrawable, index: int = -1):
	if(element is Accidental):
		if(index<0):
			_elements.append(element)
		else:
			_elements.insert(index, element)
		return
	
	fulfillment += element.get_value()
	if(index<0):
		_elements.append(element)
	else:
		_elements.insert(index, element)

func remove_element_at(index: int = -1):
	if(index < 0 or index >= _elements.size()): return false
	if(_elements[index] is not Accidental):
		fulfillment -= _elements[index].get_value()
	_elements.remove_at(index)
	
	return true


func can_add_element(element: StaffDrawable) -> bool:
	if(element is Accidental):
		return true
	if(fulfillment + element.get_value() > Melody.get_max_bar_value()):
		return false
	return true

func can_swap_elements(previousElement: StaffDrawable, newElement: StaffDrawable) -> bool:
	var previous_value = 0 if(previousElement is Accidental) else previousElement.get_value()
	var new_value = 0 if(newElement is Accidental) else newElement.get_value()
	if(fulfillment - previous_value + new_value > Melody.get_max_bar_value()):
		return false
	return true

func can_change_element_at(position: int, newElement: StaffDrawable) -> bool:
	var previous_value = 0 if(_elements[position] is Accidental) else _elements[position].get_value()
	var new_value = 0 if(newElement is Accidental) else newElement.get_value()
	if(fulfillment - previous_value + new_value > Melody.get_max_bar_value()):
		return false
	return true

func is_bar_valid() -> bool:
	var sum = 0.0
	for element in _elements:
		if(element.has_method("get_value")):
			sum += element.get_value()
	if(sum != Melody.get_max_bar_value()):
		print("NIEPOPRAWNY")
		return false
	return true


func save():
	var save_dict = {
		"fulfillment": fulfillment,
		"_elements":  serializeElementsToJson(),
	}
	return save_dict

func serializeElementsToJson():
	var json_array = []
	for element in _elements:
		json_array.append(element.save())
	return json_array

func _to_string() -> String:
	return "Bar: fulfullment = %d, elements cound = %d" % [fulfillment, _elements.size()]
