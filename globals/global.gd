extends Node

# Stave logic
var stave_length: int = 0
var current_viewing_track = 0
var max_track = 0
var dnd_element = null

signal stave_length_changed(length: int)
signal toolbox_element_changed
signal toolbox_element_reseted
signal current_track_changed

func set_stave_length(leng: int):
	#if stave_length < leng:
	stave_length = leng
	stave_length_changed.emit(stave_length)

func change_viewing_track(number: int):
	current_viewing_track = number
	stave_length = get_node("/root/Main/Editor/Stave"+str(current_viewing_track)).stave_length
	stave_length_changed.emit(stave_length)
	current_track_changed.emit()

func reset():
	stave_length = 0
	current_viewing_track = 0
	max_track = 0

# Toolbox logic

var toolbox_element = null

func change_toolbox_element(te):
	toolbox_element = te
	if toolbox_element != "Remove":
		toolbox_element_changed.emit()

func reset_toolbox():
	toolbox_element = null
	toolbox_element_reseted.emit()
