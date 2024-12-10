extends Node2D

@export var btn_group: ButtonGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for btn in btn_group.get_buttons():
		btn.pressed.connect(_on_button_pressed.bind(btn))

var note_names = ["WholeNote", "HalfNote", "QuarterNote", "EightNote", "SixteenthNote"]
var pause_names = ["WholeRest", "HalfRest", "QuarterRest", "EightRest", "SixteenthRest"]
var accidentals_names = ["Flat", "Natural", "Sharp"]
var misc_names = []

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

func clear_all():
	for node in $HBoxContainer.get_children():
		node.visible = false
