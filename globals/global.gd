extends Node

var stave_length: int = 0
var current_viewing_track = 0
var max_track = 0

signal stave_length_changed(length: int)

func set_stave_length(leng: int):
	if stave_length < leng:
		stave_length = leng
	stave_length_changed.emit(stave_length)

func change_viewing_track(number: int):
	current_viewing_track = number
	stave_length = get_node("/root/Main/Editor/Stave"+str(current_viewing_track)).stave_length
	stave_length_changed.emit(stave_length)

func reset():
	stave_length = 0
	current_viewing_track = 0
	max_track = 0
