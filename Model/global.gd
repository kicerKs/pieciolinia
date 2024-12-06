extends Node

#var current_track: TrackOld = TrackOld.new(0,0,0,0,Instruments.ACOUSTIC_BASS,[])
var stave_length: int = 0
var current_viewing_track = 0
var max_track = 0

signal stave_length_changed(length: int)

func set_stave_length(leng: int):
	stave_length = leng
	stave_length_changed.emit(stave_length)
