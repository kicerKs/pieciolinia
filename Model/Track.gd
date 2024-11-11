class_name Track

const MIN_OCTAVE: int = 0
const MAX_OCTAVE: int = 9
const MIN_RATE: int = 0
const MAX_RATE: int = 100
const MIN_METER_TOP: int = 1
const MAX_METER_TOP: int = 12
const MIN_METER_BOTTOM: int = 1
const MAX_METER_BOTTOM: int = 16

@export var _instrument = Instruments.Instrument.ACOUSTIC_GRAND_PIANO

var _octave: int
var _meter_bottom: int
var _meter_top: int
var _rate: int
var _notes: Array[Note] = []

func _init(rate: int, meter_top: int, meter_bottom: int, octave: int, instrument: int, notes: Array[Note]):
	self._rate = rate
	self._meter_top = meter_top
	self._meter_bottom = meter_bottom
	self._octave = octave
	self._instrument = instrument
	self._notes = notes
	# Wouldn't it be better to do it this way? self.rate = rate -> self.set_rate(rate)

func set_rate(rate: int):
	self._rate = clamp(rate, MIN_RATE, MAX_RATE)

func set_meter(meter_bottom: int, meter_top: int):
	self._meter_bottom = clamp(meter_bottom, MIN_METER_BOTTOM, MAX_METER_BOTTOM)
	self._meter_top = clamp(meter_top, MIN_METER_TOP, MAX_METER_TOP)

func set_octave(octave: int):
	self._octave = clamp(octave, MIN_OCTAVE, MAX_OCTAVE)
	
func set_instrument(instrument: int): 
	if instrument in range(Instruments.Instrument.ACOUSTIC_GRAND_PIANO, Instruments.Instrument.GUNSHOT + 1):
		self._instrument = instrument
	else:
		self._instrument = -1
		
func set_notes(notes: Array[Note]):
	self._notes = notes

func get_rate() -> int:
	return _rate

func get_meter_top() -> int:
	return _meter_top
	
func get_meter_bottom() -> int:
	return _meter_bottom

func get_octave() -> int:
	return _octave

func get_instrument() -> Instruments.Instrument:
	return _instrument

func get_notes() -> Array[Note]:
	return _notes

func _to_string() -> String:
	return "Track: rate = %d, meter = %d/%d, octave = %d, instrument = %d, notes count = %d" % [_rate, _meter_top, _meter_bottom, _octave, _instrument, _notes.size()]
