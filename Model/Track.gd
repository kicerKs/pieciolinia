class_name Track

var _rate: int #tempo
var _meter_top: int
var _meter_bottom: int
var _octave: int #od 0 do 10
var _instrument: int = 0

var _notes: Array[Note] #lista Intrumentów będzie w osobnym pliku, póki co na 0

func _init(rate: int, meter_top: int, meter_bottom: int, octave: int, instrument: int, notes: Array[Note]):
	self._rate = rate
	self._meter_top = meter_top
	self._meter_bottom = meter_bottom
	self._octave = octave
	self._instrument = instrument
	self._notes = notes

func _to_string() -> String:
	return "Track: rate = %d, meter = %d/%d, octave = %d, intrument = %d, notes count = %d, First note: %s" % [_rate,_meter_top,_meter_bottom,_octave,_instrument, _notes.size(),_notes[0]]

func setRate(rate: int):
	self._rate = rate
func setMeter(meter_top: int, meter_botton: int):
	self._meter_top = meter_top
	self._meter_bottom = meter_botton
func setOctave(octave: int):
	self._octave = octave
func setInstrument(instrument: int):
	self._instrument = instrument
func setNotes(notes: Array[Note]):
	notes = notes

func getRate() -> int:
	return _rate
func getMeterTop() -> int:
	return _meter_top
func getMeterBottom() -> int:
	return _meter_bottom
func getOctave() -> int:
	return _octave
func getInstrument() -> int:
	return _instrument
func getNotes() -> Array[Note]:
	return _notes
