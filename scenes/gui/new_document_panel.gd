extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show():
	if !visible:
		$MarginContainer/HBoxContainer/MetreButton.selected = 0
		$MarginContainer/HBoxContainer/ClefButton.selected = 0
		visible = true

func _on_button_create_pressed() -> void:
	var clef: Track.KeyType
	if $MarginContainer/HBoxContainer/ClefButton.selected == 0:
		clef = Track.KeyType.TREBLE
	else:
		clef = Track.KeyType.BASS
	match $MarginContainer/HBoxContainer/MetreButton.selected:
		0:
			Melody.new(4, 4, clef)
		1:
			Melody.new(3, 4, clef)
		2:
			Melody.new(2, 4, clef)
		3:
			Melody.new(2, 2, clef)
		4:
			Melody.new(6, 8, clef)
		5:
			Melody.new(3, 8, clef)
	visible = false

func _on_button_cancel_pressed() -> void:
	visible = false
