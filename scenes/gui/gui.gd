extends CanvasLayer

var viewportrect_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewportrect_size = get_viewport().size
	$HScrollBar.max_value = Global.stave_length - viewportrect_size.x
	Global.stave_length_changed.connect(_reload_camera_length)
	# To set the first buttons disability based on number of tracks
	#_on_button_camera_down_pressed()
	#_on_button_camera_up_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_h_scroll_bar_value_changed(value: float) -> void:
	$Camera2D.position.x = value

func _reload_camera_length(length: int):
	print("Camera length changed: "+str($HScrollBar.max_value)+" -> "+str(length - viewportrect_size.x))
	if $Camera2D.position.x == $HScrollBar.max_value:
		$HScrollBar.max_value = length - viewportrect_size.x
		$HScrollBar.value = $HScrollBar.max_value
		$Camera2D.position.x = $HScrollBar.max_value
	else:
		$HScrollBar.max_value = length - viewportrect_size.x
	pass

func _on_button_camera_up_pressed() -> void:
	if Global.current_viewing_track > 0:
		if len(Melody.tracks[Global.current_viewing_track].bars) == 0:
			Melody.tracks.remove_at(Global.current_viewing_track)
			$Camera2D.position.y-=viewportrect_size.y
			Global.change_viewing_track(Global.current_viewing_track-1)
			get_node("/root/Main/Editor").initialize_editor()
		else:
			$Camera2D.position.y-=viewportrect_size.y
			Global.change_viewing_track(Global.current_viewing_track-1)

func _on_button_camera_down_pressed() -> void:
	if len(Melody.tracks) > Global.current_viewing_track+1:
		$Camera2D.position.y+=viewportrect_size.y
		Global.change_viewing_track(Global.current_viewing_track+1)
		#if Global.current_viewing_track == Global.max_track:
		#	$ContainerCameraUpDown/ButtonCameraDown.disabled = true
		#if $ContainerCameraUpDown/ButtonCameraUp.disabled == true:
		#	$ContainerCameraUpDown/ButtonCameraUp.disabled = false
	elif len(Melody.tracks) > 0:
		Melody.add_track(Track.new())
		get_node("/root/Main/Editor").initialize_editor()
		$Camera2D.position.y+=viewportrect_size.y
		Global.change_viewing_track(Global.current_viewing_track+1)

func activate_validation_label(tekst):
	$ValidationLabel.text = tekst
	$ValidationLabel.visible = true

func deactivate_validation_label():
	$ValidationLabel.visible = false

func focus_camera(pos):
	$HScrollBar.value = clamp(pos-viewportrect_size.x/2, 0, max($HScrollBar.max_value, 0))

func reset_camera():
	$Camera2D.position = Vector2(0, 0)

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_window().size.y += 500
	else:
		get_window().size.y -= 500
