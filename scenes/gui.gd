extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D/HScrollBar.max_value = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_h_scroll_bar_value_changed(value: float) -> void:
	$Camera2D.position.x = value
