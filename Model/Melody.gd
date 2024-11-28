extends Node

var meter_top: int = 3
var meter_bottom: int = 4
var rate: int = 60
var tracks: Array[Track] = []

func add_track(track: Track):
	tracks.append(track)

func get_max_bar_value() -> float:
	return float(meter_top)/float(meter_bottom)

func _to_string() -> String:
	return "Melody: meter = %d/%d, rate = %d, track 1 = %d"%[meter_top,meter_bottom,rate,tracks[0].to_string()]
