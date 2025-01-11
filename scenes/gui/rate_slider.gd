extends HSlider

@export var melody: Node = null

func _ready() -> void:
	value_changed.connect(_on_value_changed)
	_get_melody_params()

func _on_value_changed(value: float) -> void:
	if melody:
		melody.rate = int(value)
	else:
		print("Rate is null")

func _get_melody_params():
	melody = get_node("/root/Melody")
	value = melody.rate
