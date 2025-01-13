extends Node

@onready var player: MidiPlayer = get_node("/root/Main/GodotMIDIPlayer")

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
		player.volume_db = value*40/100 - 40
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

func modelValidate() -> bool:
	for track in tracks:
		for bar in track.bars:
			var sum = 0.0
			for element in bar.get_elements():
				if(element.has_method("get_value")):
					sum += element.get_value()
					if(sum > get_max_bar_value()):
						print("NIEPOPRAWNY")
						return false
	return true

func save():
	var save_dict = {
		"meter_top": meter_top,
		"meter_bottom": meter_bottom,
		"rate": rate,
		"volume": volume,
		"tracks": serializeTracksToJson(),
	}
	return save_dict

func serializeTracksToJson():
	var json_array = []
	for track in tracks:
		json_array.append(track.save())
	return json_array
