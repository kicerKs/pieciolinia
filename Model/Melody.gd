extends Node

var tracks: Array[Track] = []
var meter_top: int = 3
var meter_bottom: int = 4
var rate: int = 50:
	set(value):
		rate_change.emit()
		rate=value
var volume: int = 50:
	set(value):
		volume_change.emit()
		volume=value

signal volume_change
signal rate_change

func add_track(track: Track):
	tracks.append(track)

func get_max_bar_value() -> float:
	return float(meter_top)/float(meter_bottom)

func _to_string() -> String:
	return "Melody: meter = %d/%d, rate = %d, track 1 = %d"%[meter_top,meter_bottom,rate,tracks[0].to_string()]

func clear():
	meter_top = 3
	meter_bottom = 4
	rate= 60
	tracks = []
