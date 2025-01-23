extends CanvasLayer

@export var btn_group: ButtonGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for btn in btn_group.get_buttons():
		btn.pressed.connect(_on_button_pressed.bind(btn))
	for el in $HBoxContainer.get_children():
		el.gui_input.connect(_on_element_gui_input.bind(el))

var note_names = ["WholeNote", "HalfNote", "QuarterNote", "EightNote", "SixteenthNote", "ThirtysecondNote"]
var pause_names = ["WholeRest", "HalfRest", "QuarterRest", "EightRest", "SixteenthRest", "ThirtysecondRest"]
var accidentals_names = ["Flat", "Natural", "Sharp"]
var misc_names = ["Dot", "PedalOn", "PedalOff", "Dynamic"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed(btn: Button):
	if btn.text == "Nuty":
		clear_all()
		for node in $HBoxContainer.get_children():
			if node.name in note_names:
				node.visible = true
	if btn.text == "Pauzy":
		clear_all()
		for node in $HBoxContainer.get_children():
			if node.name in pause_names:
				node.visible = true
	if btn.text == "Znaki chromatyczne":
		clear_all()
		for node in $HBoxContainer.get_children():
			if node.name in accidentals_names:
				node.visible = true
	if btn.text == "Różne":
		clear_all()
		for node in $HBoxContainer.get_children():
			if node.name in misc_names:
				node.visible = true
	$HBoxContainer/Remove.visible = true

func clear_all():
	for node in $HBoxContainer.get_children():
		node.visible = false

func _on_element_gui_input(event: InputEvent, sender) -> void:
	#Tutaj dodaj indykator że element jest zaznaczony
	if event is InputEventMouseButton and event.pressed:
		Global.change_toolbox_element(sender.name)
		get_node("/root/Main/GUI/PhantomElement").set_active()
