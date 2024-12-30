extends HSlider

var melody: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value_changed.connect(_on_value_changed)
	_get_melody_params()

func _on_value_changed(value: float) -> void:
	if melody:
		melody.volume = int(value)
		print(melody.volume)
	else:
		print("Melody is null")

func _get_melody_params():
	melody = get_node("/root/Melody")
	value = melody.volume
