extends HSlider

@export var melody: Node = null

func _ready() -> void:
	melody = get_node("/root/Melody")
	value = melody.rate
	value_changed.connect(_on_value_changed)

func _on_value_changed(value: float) -> void:
	if melody:
		melody.rate = int(value)
		print(melody.rate)
	else:
		print("Melody is null")
