extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D/HScrollBar.max_value = Global.stave_length - get_viewport_rect().size.x
	Global.stave_length_changed.connect(_reload_camera_length)
	# To set the first buttons disability based on number of tracks
	_on_button_camera_down_pressed()
	_on_button_camera_up_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_h_scroll_bar_value_changed(value: float) -> void:
	$Camera2D.position.x = value
	$Toolbox.position.x = value
	$ButtonCameraDown.position.x = value + 1200
	$ButtonCameraUp.position.x = value + 1200

func _reload_camera_length(length: int):
	$Camera2D/HScrollBar.max_value = length - get_viewport_rect().size.x

func _on_button_camera_up_pressed() -> void:
	$Camera2D.position.y-=get_viewport_rect().size.y
	$Toolbox.position.y-=get_viewport_rect().size.y
	$ButtonCameraDown.position.y-=get_viewport_rect().size.y
	$ButtonCameraUp.position.y-=get_viewport_rect().size.y
	Global.current_viewing_track-=1
	if Global.current_viewing_track == 0:
		$ButtonCameraUp.disabled = true
	if $ButtonCameraDown.disabled == true:
		$ButtonCameraDown.disabled = false

func _on_button_camera_down_pressed() -> void:
	$Camera2D.position.y+=get_viewport_rect().size.y
	$Toolbox.position.y+=get_viewport_rect().size.y
	$ButtonCameraDown.position.y+=get_viewport_rect().size.y
	$ButtonCameraUp.position.y+=get_viewport_rect().size.y
	Global.current_viewing_track+=1
	if Global.current_viewing_track == Global.max_track:
		$ButtonCameraDown.disabled = true
	if $ButtonCameraUp.disabled == true:
		$ButtonCameraUp.disabled = false
