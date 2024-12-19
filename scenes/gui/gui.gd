extends CanvasLayer

var viewportrect_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewportrect_size = get_viewport().size
	$HScrollBar.max_value = Global.stave_length - viewportrect_size.x
	Global.stave_length_changed.connect(_reload_camera_length)
	# To set the first buttons disability based on number of tracks
	_on_button_camera_down_pressed()
	_on_button_camera_up_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_h_scroll_bar_value_changed(value: float) -> void:
	$Camera2D.position.x = value

func _reload_camera_length(length: int):
	$HScrollBar.max_value = length - viewportrect_size.x
	pass

func _on_button_camera_up_pressed() -> void:
	$Camera2D.position.y-=viewportrect_size.y
	Global.current_viewing_track-=1
	if Global.current_viewing_track == 0:
		$ContainerCameraUpDown/ButtonCameraUp.disabled = true
	if $ContainerCameraUpDown/ButtonCameraDown.disabled == true:
		$ContainerCameraUpDown/ButtonCameraDown.disabled = false

func _on_button_camera_down_pressed() -> void:
	$Camera2D.position.y+=viewportrect_size.y
	Global.current_viewing_track+=1
	if Global.current_viewing_track == Global.max_track:
		$ContainerCameraUpDown/ButtonCameraDown.disabled = true
	if $ContainerCameraUpDown/ButtonCameraUp.disabled == true:
		$ContainerCameraUpDown/ButtonCameraUp.disabled = false
