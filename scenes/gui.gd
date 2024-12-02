extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D/HScrollBar.max_value = Global.stave_length - get_viewport_rect().size.x
	Global.stave_length_changed.connect(_reload_camera_length)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_h_scroll_bar_value_changed(value: float) -> void:
	$Camera2D.position.x = value
	$Toolbox.position.x = value

func _reload_camera_length(length: int):
	$Camera2D/HScrollBar.max_value = length - get_viewport_rect().size.x
