class_name CustomPopup extends Control

signal popup_close()
signal approve_button_down()
signal discard_button_down()
signal action()

@onready var window: Window = find_child("PopUp")
@onready var label: Label = find_child("Label")

enum ButtonOption {YES_NO = 0, OK = 1, OK_CANCEL = 2}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_message(message: String):
	label.text = message

func show(buttonOption: ButtonOption = ButtonOption.YES_NO):
	assign_buttons(buttonOption)
	window.visible = true

func assign_buttons(buttonOption: ButtonOption):
	$PopUp/VBoxContainer/HBoxContainer/ButtonDiscard.visible = true
	match(buttonOption):
		ButtonOption.YES_NO:
			$PopUp/VBoxContainer/HBoxContainer/ButtonApproved.text = "Tak"
			$PopUp/VBoxContainer/HBoxContainer/ButtonDiscard.text = "Nie"
		ButtonOption.OK:
			$PopUp/VBoxContainer/HBoxContainer/ButtonApproved.text = "Ok"
			$PopUp/VBoxContainer/HBoxContainer/ButtonDiscard.visible = false
		ButtonOption.OK_CANCEL:
			$PopUp/VBoxContainer/HBoxContainer/ButtonApproved.text = "Ok"
			$PopUp/VBoxContainer/HBoxContainer/ButtonDiscard.text = "Anuluj"

func hide():
	window.visible = false

func approve_button_down_internal():
	self.hide()
	approve_button_down.emit()
	action.emit()

func discard_button_down_internal():
	self.hide()
	discard_button_down.emit()
	action.emit()

func popup_close_internal():
	self.hide()
	popup_close.emit()
	action.emit()
