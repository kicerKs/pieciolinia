
var meter_top: int = 3
var meter_bottom: int = 4
var rate: int = 50
var tracks: Array[Track] = []
var _instrument = Instrument.ACOUSTIC_GRAND_PIANO

func add_track(track: Track):
	tracks.append(track)

func get_max_bar_value() -> float:
	return meter_top/meter_bottom
