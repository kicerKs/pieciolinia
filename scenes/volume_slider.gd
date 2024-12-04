extends HSlider

var melody: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	melody = get_node("/root/Melody")
	value = melody.rate
	value_changed.connect(_on_value_changed)

func _on_value_changed(value: float) -> void:
	if melody:
		melody.rate = int(value)
